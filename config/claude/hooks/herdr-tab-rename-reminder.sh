#!/bin/sh
# UserPromptSubmit hook: herdr 内なら、会話ごとに現在のタブ名更新をリマインドする。
# 実際のリネーム判断・実行は Claude 本体が herdr skill 経由で行う。

set -eu

cat >/dev/null 2>&1 || true

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_TAB_ID:-}" ] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

context="herdr: 現在のタブ(id: ${HERDR_TAB_ID})の名前が今回の会話の作業内容と食い違っている場合のみ、herdr skill 経由で \`herdr tab rename ${HERDR_TAB_ID} \"{作業名}\"\` を実行してタブ名を更新すること。作業名はこの発言の内容から要約する。workspace 名は変更しないこと。既に適切な名前なら何もしない。"

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
