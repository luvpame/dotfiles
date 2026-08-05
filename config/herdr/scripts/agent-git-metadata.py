#!/usr/bin/env python3

import hashlib
import json
import os
import subprocess
import tempfile
import time
from pathlib import Path


CACHE_TTL_SECONDS = 60
METADATA_TOKENS = (
    "git_branch",
    "pr_open",
    "pr_draft",
    "pr_merged",
    "pr_closed",
)
MOVED_TOKENS = ("git_additions", "git_deletions")
PR_ICONS = {
    "open": "",
    "draft": "",
    "merged": "",
    "closed": "",
}
CI_FAILURE_STATES = {
    "ACTION_REQUIRED",
    "CANCELLED",
    "ERROR",
    "FAILURE",
    "STALE",
    "TIMED_OUT",
}
CI_SUCCESS_STATES = {"NEUTRAL", "SKIPPED", "SUCCESS"}
REVIEW_STATUSES = {
    "APPROVED": "✓ approved",
    "CHANGES_REQUESTED": "× changes",
    "REVIEW_REQUIRED": "○ review",
}


def run(*args, cwd=None, timeout=None):
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


def pane_cwd(pane_id):
    result = stdout("herdr", "pane", "get", pane_id)
    if result is None:
        return None
    try:
        return json.loads(result)["result"]["pane"]["foreground_cwd"]
    except (json.JSONDecodeError, KeyError, TypeError):
        return None


def checkout(cwd):
    root = stdout("git", "-C", cwd, "rev-parse", "--show-toplevel")
    branch = stdout("git", "-C", cwd, "symbolic-ref", "--quiet", "--short", "HEAD")
    if not root or not branch:
        return None
    return Path(root), branch


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
        "number,state,isDraft,baseRefName,updatedAt,reviewDecision,statusCheckRollup",
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


def ci_status(pull_request):
    if pull_request is None or pull_request.get("state") != "OPEN":
        return ""
    checks = pull_request.get("statusCheckRollup")
    if not isinstance(checks, list) or not checks:
        return ""

    states = []
    for check in checks:
        if not isinstance(check, dict):
            continue
        state = check.get("conclusion") or check.get("state") or check.get("status")
        if isinstance(state, str):
            states.append(state.upper())
    if not states:
        return ""

    if any(state in CI_FAILURE_STATES for state in states):
        return "× CI"
    if any(state not in CI_SUCCESS_STATES for state in states):
        return "… CI"
    return "✓ CI"


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


def workspace_label(workspace_id):
    result = stdout("herdr", "workspace", "get", workspace_id)
    if result is None:
        return None
    try:
        return json.loads(result)["result"]["workspace"]["label"]
    except (json.JSONDecodeError, KeyError, TypeError):
        return None


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


def workspace_metadata(workspace_id, tokens, pull_request):
    workspace_tokens = {
        "agent_summary": agent_summary(workspace_id),
        **tokens,
        "ci_status": ci_status(pull_request),
        "review_status": review_status(pull_request),
    }

    branch = workspace_tokens["git_branch"].removeprefix(" ")
    if branch and branch == workspace_label(workspace_id):
        workspace_tokens["git_branch"] = ""
    return workspace_tokens


def report_metadata(target, target_id, source, tokens, clear_tokens=()):
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
    for name in clear_tokens:
        args.extend(("--clear-token", name))
    run(*args)


def main():
    pane_id = os.environ.get("HERDR_PANE_ID")
    workspace_id = os.environ.get("HERDR_WORKSPACE_ID")
    if os.environ.get("HERDR_ENV") != "1" or not pane_id:
        return

    tokens = {name: "" for name in METADATA_TOKENS}
    pull_request = None
    cwd = pane_cwd(pane_id)
    current_checkout = checkout(cwd) if cwd else None
    if current_checkout is not None:
        tokens, pull_request = metadata(*current_checkout)
    report_metadata(
        "pane", pane_id, "agent-git", tokens, clear_tokens=MOVED_TOKENS
    )
    if workspace_id:
        report_metadata(
            "workspace",
            workspace_id,
            "workspace-git",
            workspace_metadata(workspace_id, tokens, pull_request),
            clear_tokens=MOVED_TOKENS,
        )


if __name__ == "__main__":
    main()
