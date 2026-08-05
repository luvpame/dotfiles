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
    "git_additions",
    "git_deletions",
    "pr_open",
    "pr_draft",
    "pr_merged",
    "pr_closed",
)
PR_ICONS = {
    "open": "",
    "draft": "",
    "merged": "",
    "closed": "",
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
        "number,state,isDraft,baseRefName,updatedAt",
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


def remote_base(root, pull_request):
    if pull_request is not None:
        candidate = f"refs/remotes/origin/{pull_request['baseRefName']}"
        exists = stdout("git", "show-ref", "--verify", candidate, cwd=root)
        return candidate if exists else None

    candidate = stdout(
        "git",
        "symbolic-ref",
        "--quiet",
        "refs/remotes/origin/HEAD",
        cwd=root,
    )
    if not candidate:
        return None
    return candidate if stdout("git", "show-ref", "--verify", candidate, cwd=root) else None


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
    result = run(
        "git", "ls-files", "--others", "--exclude-standard", "-z", cwd=root
    )
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


def changed_lines(root, base):
    comparison_base = stdout("git", "merge-base", base, "HEAD", cwd=root)
    if comparison_base is None:
        return None
    output = stdout("git", "diff", "--numstat", comparison_base, "--", cwd=root)
    if output is None:
        return None
    untracked = untracked_additions(root)
    if untracked is None:
        return None
    additions, deletions = numstat(output)
    return additions + untracked, deletions


def metadata(root, branch):
    tokens = {name: "" for name in METADATA_TOKENS}
    tokens["git_branch"] = f" {branch}"

    found = pull_requests(root, branch)
    if found is None:
        return tokens

    pull_request = select_pull_request(found)
    base = remote_base(root, pull_request)
    if base is not None:
        lines = changed_lines(root, base)
        if lines is not None:
            additions, deletions = lines
            tokens["git_additions"] = f"+{additions}"
            tokens["git_deletions"] = f"-{deletions}"

    if pull_request is not None:
        state = pull_request_state(pull_request)
        tokens[f"pr_{state}"] = f"{PR_ICONS[state]} #{pull_request['number']}"
    return tokens


def report_metadata(pane_id, tokens):
    args = [
        "herdr",
        "pane",
        "report-metadata",
        pane_id,
        "--source",
        "agent-git",
    ]
    for name, value in tokens.items():
        args.extend(("--token", f"{name}={value}"))
    run(*args)


def main():
    pane_id = os.environ.get("HERDR_PANE_ID")
    if os.environ.get("HERDR_ENV") != "1" or not pane_id:
        return

    tokens = {name: "" for name in METADATA_TOKENS}
    cwd = pane_cwd(pane_id)
    current_checkout = checkout(cwd) if cwd else None
    if current_checkout is not None:
        tokens = metadata(*current_checkout)
    report_metadata(pane_id, tokens)


if __name__ == "__main__":
    main()
