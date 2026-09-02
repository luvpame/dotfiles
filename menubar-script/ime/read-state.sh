#!/bin/bash
set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:${PATH:-}"

# 必要な input source id / pattern はここに追加する
a_input_patterns=(
  "com.apple.keylayout.*"
  "*.Roman"
)

hiragana_input_patterns=(
  "*.Japanese"
)

matches_any_pattern() {
  local value="$1"
  shift

  local pattern
  for pattern in "$@"; do
    if [[ "$value" == $pattern ]]; then
      return 0
    fi
  done

  return 1
}

if ! command -v im-select >/dev/null 2>&1; then
  exit 0
fi

input_id=$(im-select 2>/dev/null || true)

if [[ -z "$input_id" ]]; then
  exit 0
fi

if matches_any_pattern "$input_id" "${a_input_patterns[@]}"; then
  echo "A"
elif matches_any_pattern "$input_id" "${hiragana_input_patterns[@]}"; then
  echo "あ"
else
  echo "?"
fi

exit 0
