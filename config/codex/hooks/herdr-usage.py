#!/usr/bin/env python3

import json
import os
import subprocess
import sys

BRAILLE = " ⣀⣄⣤⣦⣶⣷⣿"


def braille_bar(percent, width=8):
    percent = min(max(percent, 0), 100)
    level = percent / 100
    bar = ""
    for index in range(width):
        start = index / width
        end = (index + 1) / width
        if level >= end:
            bar += BRAILLE[7]
        elif level <= start:
            bar += BRAILLE[0]
        else:
            bar += BRAILLE[min(int((level - start) / (end - start) * 7), 7)]
    return bar


def format_usage(label, percent):
    return f"{label}: {braille_bar(percent)} ({round(percent)}%)"


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
    if os.environ.get("HERDR_ENV") != "1" or not pane_id or not transcript_path:
        return
    usage = latest_usage(transcript_path)
    if not usage:
        return

    info = usage.get("info") or {}
    total = (info.get("last_token_usage") or {}).get("total_tokens")
    context_window = info.get("model_context_window")
    context = total / context_window * 100 if total is not None and context_window else None
    limits = {
        limit.get("window_minutes"): limit.get("used_percent")
        for limit in (usage.get("rate_limits") or {}).values()
        if isinstance(limit, dict)
    }
    values = {
        "context": format_usage("ctx", context) if context is not None else "",
        "five_hour": format_usage("5h", limits[300]) if limits.get(300) is not None else "",
        "seven_day": format_usage("7d", limits[10080])
        if limits.get(10080) is not None
        else "",
    }
    args = [
        "herdr",
        "pane",
        "report-metadata",
        pane_id,
        "--source",
        "codex-usage",
    ]
    for name, value in values.items():
        args.extend(("--token", f"{name}={value}"))
    subprocess.run(
        args,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )


if __name__ == "__main__":
    main()
