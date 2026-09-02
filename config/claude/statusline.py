#!/usr/bin/env python3

import json
import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path

try:
    data = json.load(sys.stdin)
except (json.JSONDecodeError, ValueError):
    data = {}

BRAILLE = " ⣀⣄⣤⣦⣶⣷⣿"
R = "\033[0m"
DIM = "\033[2m"
LIGHT_LABEL = "\033[38;2;95;102;118m"


def rgb(r, g, b):
    return f"\033[38;2;{r};{g};{b}m"


def blend(start, end, ratio):
    ratio = max(0.0, min(ratio, 1.0))
    return tuple(
        round(channel + (target - channel) * ratio)
        for channel, target in zip(start, end)
    )


def is_dark_mode():
    try:
        result = subprocess.run(
            ["defaults", "read", "-g", "AppleInterfaceStyle"],
            capture_output=True,
            text=True,
        )
    except OSError:
        return False
    return result.returncode == 0 and result.stdout.strip() == "Dark"


IS_DARK_MODE = is_dark_mode()
GIT_ENV = {**os.environ, "GIT_OPTIONAL_LOCKS": "0"}
LABEL_COLOR = DIM if IS_DARK_MODE else LIGHT_LABEL
if IS_DARK_MODE:
    HEADER_MODEL_COLOR = rgb(180, 140, 255)
    HEADER_BRANCH_COLOR = rgb(80, 200, 120)
    HEADER_REPO_COLOR = rgb(80, 200, 200)
    HEADER_SEPARATOR_COLOR = DIM
    PROGRESS_GRADIENT = (
        (0, (80, 200, 120)),
        (40, (160, 200, 80)),
        (60, (220, 190, 60)),
        (75, (255, 155, 55)),
        (88, (255, 100, 55)),
        (100, (255, 60, 80)),
    )
else:
    HEADER_MODEL_COLOR = rgb(112, 76, 182)
    HEADER_BRANCH_COLOR = rgb(46, 125, 50)
    HEADER_REPO_COLOR = rgb(2, 132, 199)
    HEADER_SEPARATOR_COLOR = LIGHT_LABEL
    PROGRESS_GRADIENT = (
        (0, (46, 125, 50)),
        (40, (100, 130, 35)),
        (60, (160, 125, 25)),
        (75, (198, 105, 25)),
        (88, (205, 68, 35)),
        (100, (198, 40, 40)),
    )


def gradient(pct):
    pct = min(max(pct, 0), 100)
    for (start_pct, start), (end_pct, end) in zip(
        PROGRESS_GRADIENT, PROGRESS_GRADIENT[1:]
    ):
        if pct <= end_pct:
            ratio = (pct - start_pct) / (end_pct - start_pct)
            return rgb(*blend(start, end, ratio))
    return rgb(*PROGRESS_GRADIENT[-1][1])


def braille_bar(pct, width=8):
    pct = min(max(pct, 0), 100)
    level = pct / 100
    bar = ""
    for i in range(width):
        seg_start = i / width
        seg_end = (i + 1) / width
        if level >= seg_end:
            bar += BRAILLE[7]
        elif level <= seg_start:
            bar += BRAILLE[0]
        else:
            frac = (level - seg_start) / (seg_end - seg_start)
            bar += BRAILLE[min(int(frac * 7), 7)]
    return bar


def fmt(label, pct):
    p = round(pct)
    color = gradient(pct)
    return (
        f"{LABEL_COLOR}{label + ':':<4}{R} "
        f"{color}{braille_bar(pct)} ({p:3d}%){R}"
    )


def format_reset_time(timestamp, include_date=False):
    if not isinstance(timestamp, (int, float)):
        return ""
    try:
        time_format = "%m/%d %H:%M" if include_date else "%H:%M"
        return datetime.fromtimestamp(timestamp).strftime(time_format)
    except (OSError, OverflowError, ValueError):
        return ""


def nested_value(value, keys):
    for key in keys:
        if not isinstance(value, dict):
            return None
        value = value.get(key)
    return value


def git_run(*args):
    result = subprocess.run(args, capture_output=True, text=True, env=GIT_ENV)
    return result.stdout.strip() if result.returncode == 0 else ""


def git_info():
    top = git_run("git", "rev-parse", "--show-toplevel")
    branch = git_run("git", "branch", "--show-current")
    if not top or not branch:
        return None, None
    repo = os.path.basename(top)
    cwd = os.getcwd()
    if cwd != top:
        repo += f"/{os.path.basename(cwd)}"
    return repo, branch


def report_herdr_usage(context):
    if os.environ.get("HERDR_ENV") != "1" or not os.environ.get("HERDR_PANE_ID"):
        return
    args = [
        "herdr",
        "pane",
        "report-metadata",
        os.environ["HERDR_PANE_ID"],
        "--source",
        "claude-statusline",
    ]
    if context is None:
        args.extend(("--clear-token", "context"))
    else:
        args.extend(("--token", f"context={round(context)}%"))
    for name in ("model", "effort"):
        args.extend(("--clear-token", name))
    try:
        subprocess.run(
            args,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
    except OSError:
        pass


def report_herdr_git_metadata():
    if os.environ.get("HERDR_ENV") != "1" or not os.environ.get("HERDR_PANE_ID"):
        return
    configured_home = os.environ.get("XDG_CONFIG_HOME")
    config_home = Path(configured_home) if configured_home else Path.home() / ".config"
    reporter = config_home / "herdr" / "scripts" / "agent-git-metadata.py"
    if not reporter.is_file():
        return
    try:
        subprocess.run(
            [reporter],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
            timeout=4,
        )
    except (OSError, subprocess.TimeoutExpired):
        pass


model = data.get("model", {}).get("display_name", "Claude")
effort = nested_value(data, ("effort", "level"))

lines = []

model_line = f"{HEADER_MODEL_COLOR}\uf444 {model}{R}"
if effort:
    model_line += f" {HEADER_MODEL_COLOR}\U000f04c5 {effort}{R}"
parts = [model_line]
repo, branch = git_info()
if repo:
    parts.append(
        (
            f"{HEADER_SEPARATOR_COLOR}│{R} "
            f"{HEADER_BRANCH_COLOR}\ue725 {branch}{R}  "
            f"{HEADER_REPO_COLOR}\uf114 {repo}{R}"
        )
    )
lines.append(" ".join(parts))

metrics = [
    ("context", "ctx", ("context_window", "used_percentage")),
    ("five_hour", "5h", ("rate_limits", "five_hour", "used_percentage")),
    ("seven_day", "7d", ("rate_limits", "seven_day", "used_percentage")),
]
context_usage = None
reset_times = {
    "five_hour": format_reset_time(
        nested_value(data, ("rate_limits", "five_hour", "resets_at"))
    ),
    "seven_day": format_reset_time(
        nested_value(data, ("rate_limits", "seven_day", "resets_at")),
        include_date=True,
    ),
}
for name, label, keys in metrics:
    val = nested_value(data, keys)
    if isinstance(val, (int, float)):
        if name == "context":
            context_usage = val
        line = fmt(label, val)
        if reset_time := reset_times.get(name):
            line += f" {LABEL_COLOR}↻ {reset_time}{R}"
        lines.append(line)

report_herdr_usage(context_usage)
report_herdr_git_metadata()
print("\n".join(lines), end="")
