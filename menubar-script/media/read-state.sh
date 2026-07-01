#!/bin/bash

set -euo pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v osascript >/dev/null 2>&1; then
  exit 0
fi

readonly spotify_app="/Applications/Spotify.app"

normalize_text() {
  printf '%s' "$1" \
    | tr '\r\n' '  ' \
    | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

read_spotify_state() {
  [[ -d "$spotify_app" ]] || return 1

  osascript 2>/dev/null <<'APPLESCRIPT'
try
  tell application "/Applications/Spotify.app"
    set currentState to player state as text

    if currentState is "playing" or currentState is "paused" then
      return currentState & linefeed & (name of current track) & linefeed & (artist of current track)
    end if

    return currentState
  end tell
on error
  return ""
end try
APPLESCRIPT
}

format_playing_line() {
  local icon="$1"
  local fallback_label="$2"
  local title="$3"
  local artist="$4"
  local summary=""

  if [[ -n "$title" && -n "$artist" ]]; then
    summary="$title - $artist"
  elif [[ -n "$title" ]]; then
    summary="$title"
  elif [[ -n "$artist" ]]; then
    summary="$artist"
  else
    summary="$fallback_label"
  fi

  printf '%s %s\n' "$icon" "$summary"
}

player_state="$(read_spotify_state || true)"

if [[ -z "$player_state" ]]; then
  exit 0
fi

state="$(printf '%s\n' "$player_state" | sed -n '1p')"
title="$(printf '%s\n' "$player_state" | sed -n '2p')"
artist="$(printf '%s\n' "$player_state" | sed -n '3p')"

title="$(normalize_text "$title")"
artist="$(normalize_text "$artist")"

case "$state" in
  playing)
    format_playing_line "▶" "Playing" "$title" "$artist"
    ;;
  paused)
    format_playing_line "⏸" "Paused" "$title" "$artist"
    ;;
esac

exit 0
