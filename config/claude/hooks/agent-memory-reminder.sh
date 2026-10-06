#!/bin/sh
# UserPromptSubmit hook: 発言ごとに Agent Memory Repo へ保存すべきものがあるかを判断させる。
# 保存先・基準は ~/.claude/CLAUDE.md の「Agent Memory Repo」節。拾い漏れは Dreaming が補う。

set -eu

cat >/dev/null 2>&1 || true

[ -d "$HOME/agent-memory" ] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

context="agent-memory: この発言か直前の作業に、次回以降のセッションでも効く好み・訂正とそこから得たルール・決定と理由・ハマりどころがあれば、~/.claude/CLAUDE.md の基準で agent-memory-repo スキルを使って保存する。無ければ何もせず、保存しなかったことにも触れない。"

CONTEXT="$context" python3 - <<'PY'
import json
import os

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalContext": os.environ["CONTEXT"],
    }
}))
PY
