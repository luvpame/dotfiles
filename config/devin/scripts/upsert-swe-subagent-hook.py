#!/usr/bin/env python3
import argparse
import json
import os
import tempfile
from pathlib import Path

GUARD_BASENAME = "swe-subagent-guard.py"


def desired_entry(command):
    return {
        "matcher": "^run_subagent$",
        "hooks": [
            {
                "type": "command",
                "command": command,
                "timeout": 5,
            }
        ],
    }


def is_guard_hook(hook):
    return hook.get("type") == "command" and GUARD_BASENAME in hook.get("command", "")


def upsert(data, command):
    if not isinstance(data, dict):
        raise TypeError("Devin config must be a JSON object")

    hooks = data.setdefault("hooks", {})
    if not isinstance(hooks, dict):
        raise TypeError("Devin config hooks must be a JSON object")

    pre_tool_use = hooks.setdefault("PreToolUse", [])
    if not isinstance(pre_tool_use, list):
        raise TypeError("Devin config hooks.PreToolUse must be a list")

    found = False
    for entry in pre_tool_use:
        for hook in entry.get("hooks", []):
            if is_guard_hook(hook) or hook.get("command") == command:
                if hook.get("command") != command or hook.get("timeout") != 5:
                    hook["command"] = command
                    hook["timeout"] = 5
                found = True

    if not found:
        pre_tool_use.append(desired_entry(command))


def write_json(path, data):
    existing_mode = path.stat().st_mode & 0o777 if path.exists() else 0o600
    with tempfile.NamedTemporaryFile(
        "w",
        encoding="utf-8",
        dir=path.parent,
        prefix=f".{path.name}.",
        delete=False,
    ) as temp:
        json.dump(data, temp, ensure_ascii=False, indent=2)
        temp.write("\n")
        temp_path = Path(temp.name)
    os.chmod(temp_path, existing_mode)
    os.replace(temp_path, path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--hook-command", required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    path = args.config.expanduser()
    if path.exists():
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            parser.exit(1, f"error: cannot read Devin config {path}: {exc}\n")
    else:
        data = {}

    before = json.dumps(data, sort_keys=True, ensure_ascii=False)
    try:
        upsert(data, args.hook_command)
    except TypeError as exc:
        parser.exit(1, f"error: {exc}\n")
    after = json.dumps(data, sort_keys=True, ensure_ascii=False)

    if before == after:
        print("Devin SWE subagent hook is already registered.")
        return 0

    if args.dry_run:
        print(f"Would register Devin SWE subagent hook in {path}.")
        return 0

    path.parent.mkdir(parents=True, exist_ok=True)
    write_json(path, data)
    print(f"Registered Devin SWE subagent hook in {path}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
