#!/bin/bash

set -euo pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly target="$script_dir/focus-agent.sh"
readonly events_file="$(mktemp)"

cleanup() {
  rm -f "$events_file"
}
trap cleanup EXIT

herdr() {
  printf 'herdr %s\n' "$*" >> "$FOCUS_EVENTS"
  [[ "${HERDR_FAIL:-false}" != "true" ]]
}

open() {
  printf 'open %s\n' "$*" >> "$FOCUS_EVENTS"
}

export -f herdr
export -f open

run_target() {
  : > "$events_file"
  FOCUS_EVENTS="$events_file" HERDR_FAIL="${1:-false}" HOME="${HOME:-/tmp}" USER="${USER:-test-user}" \
    "$target" w1:p1
}

assert_events() {
  local description="$1"
  local expected="$2"
  local herdr_fail="$3"
  local actual

  if ! run_target "$herdr_fail"; then
    printf 'FAIL: %s\ntarget exited unsuccessfully\n' "$description" >&2
    exit 1
  fi

  actual="$(<"$events_file")"
  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL: %s\nexpected: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_empty_events() {
  local description="$1"
  local target_value="$2"
  local actual

  : > "$events_file"
  if ! FOCUS_EVENTS="$events_file" HERDR_FAIL=false HOME="${HOME:-/tmp}" USER="${USER:-test-user}" \
    "$target" "$target_value"; then
    printf 'FAIL: %s\ntarget exited unsuccessfully\n' "$description" >&2
    exit 1
  fi

  actual="$(<"$events_file")"
  if [[ -n "$actual" ]]; then
    printf 'FAIL: %s\nexpected no events\nactual: <%s>\n' "$description" "$actual" >&2
    exit 1
  fi
}

assert_events \
  "herdr成功後にWezTermをactivateする" \
  $'herdr agent focus w1:p1\nopen -a WezTerm' \
  false

assert_events \
  "herdr失敗時はWezTermをactivateしない" \
  $'herdr agent focus w1:p1' \
  true

assert_empty_events \
  "不正なpane_idではherdrとopenを呼ばない" \
  'w1;p1'

printf 'PASS\n'
