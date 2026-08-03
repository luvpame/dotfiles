#!/usr/bin/env python3

import json
import os
import subprocess
import sys


def latest_usage(transcript_path):
    # ponytail: rollout JSONL is Codex's only per-session usage source; replace
    # this parser when lifecycle hooks expose usage directly.
    # ponytail: scan 200 lines; read backwards if token_count moves away from turn end.
    result = subprocess.run(
        ["tail", "-n", "200", transcript_path],
        capture_output=True,
        text=True,
        check=False,
    )
    for line in reversed(result.stdout.splitlines()):
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        payload = event.get("payload", {})
        if payload.get("type") == "token_count":
            return payload
    return None


def main():
    try:
        hook = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return
    pane_id = os.environ.get("HERDR_PANE_ID")
    transcript_path = hook.get("transcript_path")
    if os.environ.get("HERDR_ENV") != "1" or not pane_id:
        return

    usage = latest_usage(transcript_path) if transcript_path else None
    info = (usage.get("info") or {}) if usage else {}
    total = (info.get("last_token_usage") or {}).get("total_tokens")
    context_window = info.get("model_context_window")
    context = total / context_window * 100 if total is not None and context_window else None
    args = [
        "herdr",
        "pane",
        "report-metadata",
        pane_id,
        "--source",
        "codex-usage",
    ]
    if context is None:
        args.extend(("--clear-token", "context"))
    else:
        args.extend(("--token", f"context={round(context)}%"))
    for name in ("model", "effort", "fast_mode"):
        args.extend(("--clear-token", name))
    subprocess.run(
        args,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )


if __name__ == "__main__":
    main()
