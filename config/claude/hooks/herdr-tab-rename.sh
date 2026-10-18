#!/usr/bin/env bash
# UserPromptSubmit hook: herdr 内なら、セッション最初の発言を Haiku で要約して現在のタブ名にする。
# Claude 本体へのリマインドでは無視されがちだったため、hook 側で完結させる。

set -euo pipefail

input=$(cat)

[[ "${HERDR_ENV:-}" == "1" && -n "${HERDR_TAB_ID:-}" ]] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0
command -v claude >/dev/null 2>&1 || exit 0

read_field() {
  INPUT="$input" python3 -c 'import json, os, sys; print(json.loads(os.environ["INPUT"]).get(sys.argv[1]) or "")' "$1"
}

session_id=$(read_field session_id)
prompt=$(read_field prompt)

# スラッシュコマンドだけの発言は作業内容を表さないので、次の発言で名付ける
[[ -n "$session_id" && -n "$prompt" && "$prompt" != /* ]] || exit 0

marker_dir="${TMPDIR:-/tmp}/claude-herdr-tab-rename"
mkdir -p "$marker_dir"
marker="$marker_dir/$session_id"
[[ -e "$marker" ]] && exit 0
: >"$marker"

instruction="次の依頼内容を、ターミナルのタブ名として 20 文字以内の日本語で要約せよ。タブ名だけを出力し、引用符や説明は付けない。

依頼: ${prompt:0:2000}"

# 要約に数秒かかるため、発言の送信を待たせないよう裏で動かす。
# HERDR_ENV を外し、子の claude でこの hook が再帰しないようにする。
(
  label=$(env -u HERDR_ENV claude -p --model haiku --no-session-persistence --disable-slash-commands "$instruction" 2>/dev/null | head -n 1 | tr -d '"`')
  [[ -n "$label" ]] && herdr tab rename "$HERDR_TAB_ID" "$label" >/dev/null 2>&1
) </dev/null >/dev/null 2>&1 &
disown
