#!/bin/bash

set -euo pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly target="$script_dir/read-state.sh"

media-control() {
  if [[ "${MEDIA_CONTROL_FAIL:-false}" == "true" ]]; then
    return 1
  fi

  [[ "$*" == "get --no-artwork" ]] || return 2

  printf '%s\n' "${MEDIA_CONTROL_RESPONSE:-null}"
}
export -f media-control

assert_output() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local actual

  actual="$(MEDIA_CONTROL_RESPONSE="$response" "$target")"

  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL: %s\nexpected: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_output \
  "Spotify の再生を表示する" \
  "▶ Song - Artist" \
  '{"playing":true,"bundleIdentifier":"com.spotify.client","title":"Song","artist":"Artist"}'
assert_output \
  "Dia の再生を表示する" \
  "▶ Mix - DJ" \
  '{"playing":true,"bundleIdentifier":"company.thebrowser.dia","title":"Mix","artist":"DJ"}'
assert_output \
  "一時停止中は表示しない" \
  "" \
  '{"playing":false,"bundleIdentifier":"com.spotify.client","title":"Song","artist":"Artist"}'
assert_output \
  "対象外アプリは表示しない" \
  "" \
  '{"playing":true,"bundleIdentifier":"com.apple.Music","title":"Song","artist":"Artist"}'
assert_output \
  "メタデータがなければフォールバックを表示する" \
  "▶ Playing" \
  '{"playing":true,"bundleIdentifier":"company.thebrowser.dia","title":null,"artist":null}'

actual="$(MEDIA_CONTROL_FAIL=true "$target")"
if [[ -n "$actual" ]]; then
  printf 'FAIL: 取得失敗時は空出力\nactual: <%s>\n' "$actual" >&2
  exit 1
fi

printf 'PASS\n'
