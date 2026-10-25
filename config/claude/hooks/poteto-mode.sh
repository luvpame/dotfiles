#!/bin/sh
# SessionStart hook: 毎セッション /pstack:poteto-mode を有効にする。
# poteto-mode は disable-model-invocation なので Skill ツールでは呼べず、SKILL.md を Read させる。
# プラグイン更新でバージョン付きのパスが変わるため、パスは決め打ちせず最新版を探す。

set -eu

cat >/dev/null 2>&1 || true

command -v python3 >/dev/null 2>&1 || exit 0

python3 - <<'PY'
import glob
import json
import os

paths = glob.glob(os.path.expanduser("~/.claude/plugins/cache/*/pstack/*/skills/poteto-mode/SKILL.md"))
if not paths:
    raise SystemExit(0)

def version(path):
    v = path.split("/pstack/")[1].split("/")[0]
    return tuple(int(p) if p.isdigit() else 0 for p in v.split("."))

skill = max(paths, key=version)
context = (
    "poteto-mode: このセッションでは /pstack:poteto-mode が有効。"
    f"最初の返答の前に {skill} を Read し、その指示に従って作業する。"
    "Skill ツールでは呼べない（disable-model-invocation）ので Read で読む。"
)

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": context,
    }
}))
PY
