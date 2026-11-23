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


def text_at(value, *keys):
    for key in keys:
        if not isinstance(value, dict):
            return None
        value = value.get(key)
    if isinstance(value, str) and value:
        return value
    return None


def number_at(value, *keys):
    for key in keys:
        if not isinstance(value, dict):
            return None
        value = value.get(key)
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        return None
    return value


def repo_and_branch(payload):
    root = text_at(payload, "workspace", "repo_root")
    branch = text_at(payload, "workspace", "branch")
    if not root or not branch:
        return None, None
    repo = os.path.basename(root.rstrip("/")) or root
    current = text_at(payload, "workspace", "current_dir") or text_at(payload, "cwd")
    if current:
        current_name = os.path.basename(current.rstrip("/"))
        if current_name and os.path.normpath(current) != os.path.normpath(root):
            repo = f"{repo}/{current_name}"
    return repo, branch


lines = []
parts = []
model = text_at(data, "model", "display_name")
effort = text_at(data, "effort", "level")
if model:
    model_line = f"{HEADER_MODEL_COLOR}\uf444 {model}{R}"
    if effort:
        model_line += f" {HEADER_MODEL_COLOR}\U000f04c5 {effort}{R}"
    parts.append(model_line)

repo, branch = repo_and_branch(data)
if repo:
    parts.append(
        (
            f"{HEADER_SEPARATOR_COLOR}│{R} "
            f"{HEADER_BRANCH_COLOR}\ue725 {branch}{R}  "
            f"{HEADER_REPO_COLOR}\uf114 {repo}{R}"
        )
    )
if parts:
    lines.append(" ".join(parts))

context = number_at(data, "context_window", "used_percentage")
if context is not None:
    lines.append(fmt("ctx", context))

if lines:
    print("\n".join(lines), end="")
