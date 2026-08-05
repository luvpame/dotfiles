#!/usr/bin/env python3

import json
import os
import subprocess
from pathlib import Path


METADATA_SOURCE = "git-change-lines"


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


def checkout(cwd):
    if not isinstance(cwd, str) or not cwd:
        return None
    root = stdout("git", "-C", cwd, "rev-parse", "--show-toplevel")
    branch = stdout("git", "-C", cwd, "symbolic-ref", "--quiet", "--short", "HEAD")
    if not root or not branch:
        return None
    return Path(root)


def workspace_checkout(workspace):
    worktree = workspace.get("worktree")
    if isinstance(worktree, dict):
        for name in ("checkout_path", "repo_root"):
            current = checkout(worktree.get(name))
            if current is not None:
                return current

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
            current = checkout(pane.get(name))
            if current is not None:
                return current
    return None


def agent_checkout(agent):
    for name in ("foreground_cwd", "cwd"):
        current = checkout(agent.get(name))
        if current is not None:
            return current
    return None


def remote_base(root):
    base_branch = stdout(
        "gh",
        "pr",
        "view",
        "--json",
        "baseRefName",
        "--jq",
        ".baseRefName",
        cwd=root,
        timeout=3,
    )
    if base_branch:
        candidate = f"refs/remotes/origin/{base_branch}"
        if stdout("git", "show-ref", "--verify", candidate, cwd=root):
            return candidate

    candidate = stdout(
        "git",
        "symbolic-ref",
        "--quiet",
        "refs/remotes/origin/HEAD",
        cwd=root,
    )
    if candidate and stdout("git", "show-ref", "--verify", candidate, cwd=root):
        return candidate
    return None


def numstat(output):
    additions = 0
    deletions = 0
    for line in output.splitlines():
        fields = line.split("\t", 2)
        if len(fields) < 2 or not all(field.isdigit() for field in fields[:2]):
            continue
        additions += int(fields[0])
        deletions += int(fields[1])
    return additions, deletions


def untracked_additions(root):
    result = run("git", "ls-files", "--others", "--exclude-standard", "-z", cwd=root)
    if result is None or result.returncode != 0:
        return None

    additions = 0
    for relative_path in result.stdout.split("\0"):
        if not relative_path:
            continue
        result = run(
            "git",
            "diff",
            "--no-index",
            "--numstat",
            os.devnull,
            str(root / relative_path),
            cwd=root,
        )
        if result is None or result.returncode not in {0, 1}:
            return None
        file_additions, _ = numstat(result.stdout)
        additions += file_additions
    return additions


def changed_lines(root):
    base = remote_base(root)
    if base is None:
        return None
    comparison_base = stdout("git", "merge-base", base, "HEAD", cwd=root)
    if comparison_base is None:
        return None
    output = stdout("git", "diff", "--numstat", comparison_base, "--", cwd=root)
    untracked = untracked_additions(root)
    if output is None or untracked is None:
        return None
    additions, deletions = numstat(output)
    return additions + untracked, deletions


def report(target, target_id, lines):
    additions = f"+{lines[0]}" if lines is not None else ""
    deletions = f"-{lines[1]}" if lines is not None else ""
    run(
        "herdr",
        target,
        "report-metadata",
        target_id,
        "--source",
        METADATA_SOURCE,
        "--token",
        f"git_additions={additions}",
        "--token",
        f"git_deletions={deletions}",
    )


def main():
    workspaces = herdr_items("workspaces", "workspace", "list")
    agents = herdr_items("agents", "agent", "list")
    if workspaces is None or agents is None:
        return

    lines_by_checkout = {}

    def lines_for(root):
        if root is None:
            return None
        if root not in lines_by_checkout:
            lines_by_checkout[root] = changed_lines(root)
        return lines_by_checkout[root]

    for workspace in workspaces:
        if not isinstance(workspace, dict):
            continue
        workspace_id = workspace.get("workspace_id")
        if isinstance(workspace_id, str):
            report(
                "workspace",
                workspace_id,
                lines_for(workspace_checkout(workspace)),
            )

    for agent in agents:
        if not isinstance(agent, dict):
            continue
        pane_id = agent.get("pane_id")
        if isinstance(pane_id, str):
            report("pane", pane_id, lines_for(agent_checkout(agent)))


if __name__ == "__main__":
    main()
