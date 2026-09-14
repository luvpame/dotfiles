#!/bin/bash

set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

if ! command -v media-control >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

normalize_text() {
  printf '%s' "$1" \
    | tr '\r\n' '  ' \
    | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

format_playing_line() {
  local title="$1"
  local artist="$2"
  local summary="Playing"

  if [[ -n "$title" && -n "$artist" ]]; then
    summary="$title - $artist"
  elif [[ -n "$title" ]]; then
    summary="$title"
  elif [[ -n "$artist" ]]; then
    summary="$artist"
  fi

  printf '▶ %s\n' "$summary"
}

player_state="$(
  media-control get --no-artwork 2>/dev/null \
    | jq -r '
        select(
          .playing == true
          and (
            .bundleIdentifier == "com.spotify.client"
            or .bundleIdentifier == "company.thebrowser.dia"
          )
        )
        | "playing", (.title // ""), (.artist // "")
      ' 2>/dev/null \
    || true
)"

if [[ -z "$player_state" ]]; then
  exit 0
fi

title="$(printf '%s\n' "$player_state" | sed -n '2p')"
artist="$(printf '%s\n' "$player_state" | sed -n '3p')"

format_playing_line "$(normalize_text "$title")" "$(normalize_text "$artist")"
