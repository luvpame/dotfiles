#!/usr/bin/env python3

import json
import os
import shutil
import subprocess


METADATA_SOURCE = "dev-server"
DEV_SERVER_ICON = ""
DEV_SERVER_TOKEN = "dev_server"
PS_COMMAND = shutil.which("ps") or "/bin/ps"
LSOF_COMMAND = shutil.which("lsof") or "/usr/sbin/lsof"


def run(*args, timeout=5):
    try:
        return subprocess.run(
            args,
            capture_output=True,
            text=True,
            check=False,
            env={**os.environ, "GIT_OPTIONAL_LOCKS": "0"},
            timeout=timeout,
        )
    except (OSError, subprocess.TimeoutExpired, UnicodeError):
        return None


def stdout(*args):
    result = run(*args)
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


def pane_process_info(pane_id):
    output = stdout("herdr", "pane", "process-info", "--pane", pane_id)
    if output is None:
        return None
    try:
        process_info = json.loads(output)["result"]["process_info"]
    except (json.JSONDecodeError, KeyError, TypeError):
        return None
    return process_info if isinstance(process_info, dict) else None


def pane_root_pids(process_info):
    foreground_processes = process_info.get("foreground_processes")
    if not isinstance(foreground_processes, list):
        return None

    roots = set()
    shell_pid = process_info.get("shell_pid")
    if shell_pid is not None:
        if not isinstance(shell_pid, int) or shell_pid <= 0:
            return None
        roots.add(shell_pid)

    for process in foreground_processes:
        if not isinstance(process, dict):
            return None
        pid = process.get("pid")
        if not isinstance(pid, int) or pid <= 0:
            return None
        roots.add(pid)
    return roots


def workspace_root_pids(workspace_id):
    panes = herdr_items("panes", "pane", "list", "--workspace", workspace_id)
    if panes is None:
        return None

    roots = set()
    for pane in panes:
        if not isinstance(pane, dict):
            continue
        pane_id = pane.get("pane_id")
        if not isinstance(pane_id, str):
            continue
        process_info = pane_process_info(pane_id)
        if process_info is None:
            return None
        pane_roots = pane_root_pids(process_info)
        if pane_roots is None:
            return None
        roots.update(pane_roots)
    return roots


def process_tree():
    output = stdout(PS_COMMAND, "-axo", "pid=,ppid=")
    if output is None:
        return None

    children = {}
    parsed_processes = 0
    for line in output.splitlines():
        fields = line.split()
        if len(fields) < 2:
            continue
        try:
            pid, parent_pid = (int(value) for value in fields[:2])
        except ValueError:
            continue
        if pid <= 0 or parent_pid < 0:
            continue
        children.setdefault(parent_pid, set()).add(pid)
        parsed_processes += 1
    return children if parsed_processes or not output else None


def listening_pids():
    result = run(
        LSOF_COMMAND,
        "-nP",
        "-a",
        "-iTCP",
        "-sTCP:LISTEN",
        "-F",
        "p",
    )
    if result is None or result.returncode not in {0, 1}:
        return None
    if result.stderr.strip():
        return None

    pids = set()
    for line in result.stdout.splitlines():
        if not line.startswith("p"):
            continue
        try:
            pid = int(line[1:])
        except ValueError:
            continue
        if pid > 0:
            pids.add(pid)
    return pids if pids or not result.stdout.strip() else None


def process_tree_pids(roots, children):
    pids = set(roots)
    pending = list(roots)
    while pending:
        parent_pid = pending.pop()
        for pid in children.get(parent_pid, ()):
            if pid in pids:
                continue
            pids.add(pid)
            pending.append(pid)
    return pids


def workspace_has_listening_process(workspace_roots, children, listening):
    process_ids = process_tree_pids(workspace_roots, children)
    return bool(process_ids & listening)


def report(workspace_id, has_development_server):
    value = DEV_SERVER_ICON if has_development_server else ""
    run(
        "herdr",
        "workspace",
        "report-metadata",
        workspace_id,
        "--source",
        METADATA_SOURCE,
        "--token",
        f"{DEV_SERVER_TOKEN}={value}",
        "--ttl-ms",
        "30000",
    )


def main():
    workspaces = herdr_items("workspaces", "workspace", "list")
    if workspaces is None:
        return

    roots_by_workspace = {}
    for workspace in workspaces:
        if not isinstance(workspace, dict):
            continue
        workspace_id = workspace.get("workspace_id")
        if not isinstance(workspace_id, str):
            continue
        roots = workspace_root_pids(workspace_id)
        if roots is not None:
            roots_by_workspace[workspace_id] = roots

    if not roots_by_workspace:
        return
    children = process_tree()
    listening = listening_pids()
    if children is None or listening is None:
        return

    for workspace_id, roots in roots_by_workspace.items():
        report(
            workspace_id,
            workspace_has_listening_process(roots, children, listening),
        )


if __name__ == "__main__":
    main()
