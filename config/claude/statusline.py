#!/usr/bin/env python3

import json
import os
import subprocess
import sys

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
else:
    HEADER_MODEL_COLOR = rgb(112, 76, 182)
    HEADER_BRANCH_COLOR = rgb(46, 125, 50)
    HEADER_REPO_COLOR = rgb(2, 132, 199)
    HEADER_SEPARATOR_COLOR = LIGHT_LABEL


def gradient(pct):
    if IS_DARK_MODE:
        if pct < 50:
            r = int(pct * 5.1)
            return rgb(r, 200, 80)
        g = int(200 - (pct - 50) * 4)
        return rgb(255, max(g, 0), 60)

    pct = min(max(pct, 0), 100)
    if pct < 70:
        color = blend((46, 125, 50), (198, 124, 28), pct / 70)
    else:
        color = blend((198, 124, 28), (198, 40, 40), (pct - 70) / 30)
    return rgb(*color)


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
    return f"{LABEL_COLOR}{label}{R} {color}{braille_bar(pct)} ({p}%){R}"


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


def report_herdr_usage(tokens):
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
    for name, value in tokens.items():
        args.extend(("--token", f"{name}={value}"))
    try:
        subprocess.run(
            args,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
    except OSError:
        pass


model = data.get("model", {}).get("display_name", "Claude")

lines = []

parts = [f"{HEADER_MODEL_COLOR}\uf444 {model}{R}"]
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
tokens = {}
for name, label, keys in metrics:
    val = data
    for k in keys:
        if not isinstance(val, dict):
            val = None
            break
        val = val.get(k, {})
    tokens[name] = f"{label} {round(val)}%" if isinstance(val, (int, float)) else ""
    if isinstance(val, (int, float)):
        lines.append(fmt(f"{label}: ", val))

report_herdr_usage(tokens)
print("\n".join(lines), end="")
