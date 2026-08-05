#!/usr/bin/env python3

import json
import os
import subprocess


REVIEW_REQUEST_ICON = ""


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


def stdout(*args, cwd=None, timeout=None):
    result = run(*args, cwd=cwd, timeout=timeout)
    if result is None or result.returncode != 0:
        return None
    return result.stdout.strip()


def herdr_items(name, *args):
    output = stdout("herdr", *args)
    if output is None:
        return None
    try:
        items = json.loads(output)["result"][name]
    except (json.JSONDecodeError, KeyError, TypeError):
        return None
    return items if isinstance(items, list) else None


def repository_root(cwd):
    if not isinstance(cwd, str) or not cwd:
        return None
    return stdout("git", "-C", cwd, "rev-parse", "--show-toplevel")


def workspace_repository_root(workspace):
    worktree = workspace.get("worktree")
    if isinstance(worktree, dict):
        for name in ("repo_root", "checkout_path"):
            root = repository_root(worktree.get(name))
            if root:
                return root

    workspace_id = workspace.get("workspace_id")
    if not isinstance(workspace_id, str):
        return None
    panes = herdr_items("panes", "pane", "list", "--workspace", workspace_id)
    if panes is None:
        return None
    for pane in panes:
        if not isinstance(pane, dict):
            continue
        for name in ("foreground_cwd", "cwd"):
            root = repository_root(pane.get(name))
            if root:
                return root
    return None


def review_request_count(root):
    output = stdout(
        "gh",
        "pr",
        "list",
        "--state",
        "open",
        "--search",
        "review-requested:@me",
        "--limit",
        "1000",
        "--json",
        "number",
        "--jq",
        "length",
        cwd=root,
        timeout=10,
    )
    try:
        count = int(output)
    except (TypeError, ValueError):
        return None
    return count if count >= 0 else None


def report_review_requests(workspace_id, count):
    run(
        "herdr",
        "workspace",
        "report-metadata",
        workspace_id,
        "--source",
        "review-requests",
        "--token",
        f"review_requests={REVIEW_REQUEST_ICON} Reviews {count}",
    )


def main():
    workspaces = herdr_items("workspaces", "workspace", "list")
    if workspaces is None:
        return

    counts = {}
    for workspace in workspaces:
        if not isinstance(workspace, dict):
            continue
        workspace_id = workspace.get("workspace_id")
        if not isinstance(workspace_id, str):
            continue
        root = workspace_repository_root(workspace)
        if root is None:
            continue
        if root not in counts:
            counts[root] = review_request_count(root)
        count = counts[root]
        if count is not None:
            report_review_requests(workspace_id, count)


if __name__ == "__main__":
    main()
