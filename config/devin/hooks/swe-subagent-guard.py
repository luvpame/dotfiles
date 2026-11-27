#!/usr/bin/env python3
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

TARGET_PROFILE = "poteto-swe-agent"
REWRITES = {
    "pstack:poteto-agent": TARGET_PROFILE,
}


def emit(payload):
    print(json.dumps(payload, ensure_ascii=False), flush=True)


def main():
    try:
        event = json.load(sys.stdin)
    except Exception:
        return 0

    if event.get("hook_event_name") != "PreToolUse" or event.get("tool_name") != "run_subagent":
        return 0

    tool_input = event.get("tool_input") or {}
    profile = tool_input.get("profile")
    replacement = REWRITES.get(profile)
    if not replacement:
        return 0

    agent_file = Path.home() / ".config" / "devin" / "agents" / f"{TARGET_PROFILE}.md"
    try:
        agent_text = agent_file.read_text(encoding="utf-8")
    except OSError:
        emit({
            "decision": "block",
            "reason": f"Blocked {profile}: SWE replacement profile is missing at {agent_file}",
        })
        return 0

    model_line = next(
        (line.split(":", 1)[1].strip() for line in agent_text.splitlines() if line.startswith("model:")),
        "",
    )
    if not model_line.startswith("swe-"):
        emit({
            "decision": "block",
            "reason": f"Blocked {profile}: {agent_file} does not pin a SWE model",
        })
        return 0

    log_path = Path.home() / ".local" / "share" / "devin" / "cli" / "swe-subagent-guard.jsonl"
    try:
        log_path.parent.mkdir(parents=True, exist_ok=True)
        with log_path.open("a", encoding="utf-8") as log:
            log.write(json.dumps({
                "at": datetime.now(timezone.utc).isoformat(),
                "session_id": event.get("session_id"),
                "prompt_id": event.get("prompt_id"),
                "tool_use_id": event.get("tool_use_id"),
                "from": profile,
                "to": replacement,
                "model": model_line,
            }, ensure_ascii=False) + "\n")
    except OSError:
        pass

    emit({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "updatedInput": {"profile": replacement},
        }
    })
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
