#!/usr/bin/env python3

import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path


CACHE_TTL_SECONDS = 60
REVIEW_SPACE_PATTERN = re.compile(r"^review-#[0-9]+$")
REVIEW_SPACE_ICON = ""
METADATA_TOKENS = (
    "git_branch",
    "pr_open",
    "pr_draft",
    "pr_merged",
    "pr_closed",
)
PR_TOKEN_NAMES = ("pr_open", "pr_draft", "pr_merged", "pr_closed")
# Herdr trims regular whitespace around token values, so use U+2800 for indenting.
WORKSPACE_PR_INDENT = "\u2800\u2800"
PR_ICONS = {
    "open": "",
    "draft": "",
    "merged": "",
    "closed": "",
}
REVIEW_STATUSES = {
    "APPROVED": "✓ approved",
    "CHANGES_REQUESTED": "× changes",
    "REVIEW_REQUIRED": "○ review",
}


def run(*args, cwd=None, timeout=5):
    try:
        return subprocess.run(
            args,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=False,
            env={**os.environ, "GIT_OPTIONAL_LOCKS": "0"},
            timeout=timeout,
        )
    except (OSError, subprocess.TimeoutExpired, UnicodeError):
        return None


def stdout(*args, cwd=None):
    result = run(*args, cwd=cwd)
    if result is None or result.returncode != 0:
        return None
    return result.stdout.strip()


def herdr_data(name, *args):
    result = stdout("herdr", *args)
    if result is None:
        return None
    try:
        return json.loads(result)["result"][name]
    except (json.JSONDecodeError, KeyError, TypeError):
        return None


def checkout(cwd):
    root = stdout("git", "-C", cwd, "rev-parse", "--show-toplevel")
    branch = stdout("git", "-C", cwd, "symbolic-ref", "--quiet", "--short", "HEAD")
    if not root or not branch:
        return None
    return Path(root), branch


def pane_checkout(pane):
    for name in ("foreground_cwd", "cwd"):
        cwd = pane.get(name)
        if isinstance(cwd, str) and cwd:
            current_checkout = checkout(cwd)
            if current_checkout is not None:
                return current_checkout
    return None


def workspace_checkout(workspace, pane_checkouts):
    worktree = workspace.get("worktree")
    if isinstance(worktree, dict):
        cwd = worktree.get("checkout_path")
        return checkout(cwd) if isinstance(cwd, str) and cwd else None
    for pane_id in sorted(pane_checkouts):
        if pane_checkouts[pane_id] is not None:
            return pane_checkouts[pane_id]
    return None


def cache_path(root, branch):
    configured_cache_home = os.environ.get("XDG_CACHE_HOME")
    cache_home = (
        Path(configured_cache_home)
        if configured_cache_home
        else Path.home() / ".cache"
    )
    key = hashlib.sha256(f"{root}\0{branch}".encode()).hexdigest()
    return cache_home / "herdr" / "agent-git-metadata" / f"{key}.json"


def read_cache(path):
    try:
        data = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError, TypeError):
        return None
    queried_at = data.get("queried_at")
    pull_requests = data.get("pull_requests")
    if not isinstance(queried_at, (int, float)) or not isinstance(pull_requests, list):
        return None
    if time.time() - queried_at >= CACHE_TTL_SECONDS:
        return None
    return pull_requests


def write_cache(path, pull_requests):
    temporary_path = None
    try:
        path.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(
            "w", dir=path.parent, delete=False, encoding="utf-8"
        ) as file:
            json.dump(
                {"queried_at": time.time(), "pull_requests": pull_requests},
                file,
            )
            temporary_path = Path(file.name)
        temporary_path.replace(path)
        temporary_path = None
    except OSError:
        pass
    finally:
        if temporary_path is not None:
            try:
                temporary_path.unlink(missing_ok=True)
            except OSError:
                pass


def pull_requests(root, branch):
    path = cache_path(root, branch)
    cached = read_cache(path)
    if cached is not None:
        return cached

    result = run(
        "gh",
        "pr",
        "list",
        "--head",
        branch,
        "--state",
        "all",
        "--limit",
        "100",
        "--json",
        "number,state,isDraft,baseRefName,updatedAt,reviewDecision",
        cwd=root,
        timeout=3,
    )
    if result is None or result.returncode != 0:
        return None
    try:
        found = json.loads(result.stdout)
    except json.JSONDecodeError:
        return None
    if not isinstance(found, list):
        return None
    write_cache(path, found)
    return found


def select_pull_request(candidates):
    valid = [
        pull_request
        for pull_request in candidates
        if isinstance(pull_request, dict)
        and pull_request.get("state") in {"OPEN", "MERGED", "CLOSED"}
        and isinstance(pull_request.get("number"), int)
        and isinstance(pull_request.get("baseRefName"), str)
    ]
    if not valid:
        return None
    return max(
        valid,
        key=lambda pull_request: (
            pull_request["state"] == "OPEN",
            pull_request.get("updatedAt", ""),
        ),
    )


def pull_request_state(pull_request):
    state = pull_request["state"]
    if state == "OPEN":
        return "draft" if pull_request.get("isDraft") else "open"
    return state.lower()


def review_status(pull_request):
    if pull_request is None or pull_request.get("state") != "OPEN":
        return ""
    return REVIEW_STATUSES.get(pull_request.get("reviewDecision"), "")


def metadata(root, branch):
    tokens = {name: "" for name in METADATA_TOKENS}
    tokens["git_branch"] = f" {branch}"

    found = pull_requests(root, branch)
    if found is None:
        return tokens, None

    pull_request = select_pull_request(found)
    if pull_request is not None:
        state = pull_request_state(pull_request)
        tokens[f"pr_{state}"] = f"{PR_ICONS[state]} #{pull_request['number']}"
    return tokens, pull_request


def review_space_icon(label):
    if not isinstance(label, str) or REVIEW_SPACE_PATTERN.fullmatch(label) is None:
        return ""
    return REVIEW_SPACE_ICON


def agent_summary(workspace_id):
    result = stdout("herdr", "agent", "list")
    if result is None:
        return ""
    try:
        agents = json.loads(result)["result"]["agents"]
    except (json.JSONDecodeError, KeyError, TypeError):
        return ""
    if not isinstance(agents, list):
        return ""
    count = sum(
        1
        for agent in agents
        if isinstance(agent, dict) and agent.get("workspace_id") == workspace_id
    )
    if count == 0:
        return ""
    return f"{count} agent" if count == 1 else f"{count} agents"


def workspace_metadata(workspace, tokens, pull_request):
    label = workspace.get("label")
    workspace_tokens = {
        "agent_summary": agent_summary(workspace["workspace_id"]),
        **tokens,
        "review_status": review_status(pull_request),
        "review_space": review_space_icon(label),
    }
    for name in PR_TOKEN_NAMES:
        if workspace_tokens[name]:
            workspace_tokens[name] = (
                f"{WORKSPACE_PR_INDENT}{workspace_tokens[name]}"
            )

    branch = workspace_tokens["git_branch"].removeprefix(" ")
    if branch and branch == label:
        workspace_tokens["git_branch"] = ""
    return workspace_tokens


def report_metadata(target, target_id, source, tokens):
    args = [
        "herdr",
        target,
        "report-metadata",
        target_id,
        "--source",
        source,
    ]
    for name, value in tokens.items():
        args.extend(("--token", f"{name}={value}"))
    run(*args)


def checkout_metadata(current_checkout):
    if current_checkout is None:
        return {name: "" for name in METADATA_TOKENS}, None
    return metadata(*current_checkout)


def update_workspace(workspace, *, report_panes=False):
    workspace_id = workspace["workspace_id"]
    panes = herdr_data("panes", "pane", "list", "--workspace", workspace_id)
    if not isinstance(panes, list):
        return
    pane_checkouts = {
        pane["pane_id"]: pane_checkout(pane)
        for pane in panes
        if isinstance(pane, dict) and isinstance(pane.get("pane_id"), str)
    }
    if report_panes:
        for pane_id, current_checkout in pane_checkouts.items():
            tokens, _ = checkout_metadata(current_checkout)
            report_metadata("pane", pane_id, "agent-git", tokens)
    tokens, pull_request = checkout_metadata(
        workspace_checkout(workspace, pane_checkouts)
    )
    report_metadata(
        "workspace",
        workspace_id,
        "workspace-git",
        workspace_metadata(workspace, tokens, pull_request),
    )


def main():
    if sys.argv[1:] == ["--all-workspaces"]:
        workspaces = herdr_data("workspaces", "workspace", "list")
        if isinstance(workspaces, list):
            for workspace in workspaces:
                if isinstance(workspace, dict) and isinstance(
                    workspace.get("workspace_id"), str
                ):
                    update_workspace(workspace, report_panes=True)
        return
    if sys.argv[1:]:
        return
    pane_id = os.environ.get("HERDR_PANE_ID")
    workspace_id = os.environ.get("HERDR_WORKSPACE_ID")
    if os.environ.get("HERDR_ENV") != "1" or not pane_id:
        return

    pane = herdr_data("pane", "pane", "get", pane_id)
    if isinstance(pane, dict):
        tokens, _ = checkout_metadata(pane_checkout(pane))
        report_metadata("pane", pane_id, "agent-git", tokens)
    if workspace_id:
        workspace = herdr_data("workspace", "workspace", "get", workspace_id)
        if isinstance(workspace, dict) and workspace.get("workspace_id") == workspace_id:
            update_workspace(workspace)


if __name__ == "__main__":
    main()
