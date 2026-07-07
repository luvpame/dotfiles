#!/bin/bash
set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$home_dir/.config}"

readonly calendar_id="nasuno.ayumu@smartcamp.co.jp"

if ! command -v gog >/dev/null 2>&1; then
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

render_calendar() {
  local events_json="$1"
  local today="$2"
  local now="$3"

  jq -r --arg today "$today" --arg now "$now" '
    def self_declined:
      any(.attendees[]?; .self == true and .responseStatus == "declined");

    def title:
      (.summary // "(無題)")
      | gsub("[\r\n\t]+"; " ")
      | gsub("  +"; " ")
      | gsub("^ +| +$"; "")
      | gsub("\\|"; "／");

    def meet_url:
      .hangoutLink
      // ([.conferenceData.entryPoints[]?
        | select(.entryPointType == "video" and ((.uri // "") | startswith("http")))
        | .uri][0])
      // "";

    def attrs:
      (meet_url) as $url
      | if $url == "" then "" else " | href=\"" + $url + "\"" end;

    def timed:
      .status == "confirmed"
      and (.start.dateTime? != null)
      and (self_declined | not);

    def start_time: .startLocal[11:16];
    def end_time: .endLocal[11:16];
    def running: .startLocal <= $now and .endLocal > $now;
    def text($icon): $icon + " " + start_time + "-" + end_time + " " + title;

    (.events // []) as $events
    | ($events | map(select(timed)) | sort_by(.startLocal)) as $timed
    | ($timed | map(select(running))) as $current
    | ($timed | map(select((.startLocal >= $now) and (running | not)))[0]) as $next
    | ($timed | map(select((.startLocal >= $now) and (.startLocal[0:10] == $today)))[0]) as $next_today
    | if ($current | length) > 0 then
        (($current | map(text("󰥔")) | join(" / "))
          + if $next == null then "" else " / " + ($next | text("󰝖")) end)
        + (($current | map(select(meet_url != ""))[0] // $next // {}) | attrs)
      elif $next_today != null then
        ($next_today | text("󰃭") + attrs)
      else
        "󰅐 予定なし"
      end
  ' <<<"$events_json"
}

if [[ "${1:-}" == "--self-test" ]]; then
  fixture='{
    "events": [
      {
        "status": "confirmed",
        "summary": "Today all day",
        "start": { "date": "2026-07-07" },
        "end": { "date": "2026-07-08" },
        "startLocal": "2026-07-07",
        "endLocal": "2026-07-08"
      },
      {
        "status": "confirmed",
        "summary": "Current 😎",
        "start": { "dateTime": "2026-07-07T10:00:00+09:00" },
        "end": { "dateTime": "2026-07-07T11:00:00+09:00" },
        "startLocal": "2026-07-07T10:00:00+09:00",
        "endLocal": "2026-07-07T11:00:00+09:00",
        "hangoutLink": "https://meet.google.com/current"
      },
      {
        "status": "confirmed",
        "summary": "Next",
        "start": { "dateTime": "2026-07-07T11:30:00+09:00" },
        "end": { "dateTime": "2026-07-07T12:00:00+09:00" },
        "startLocal": "2026-07-07T11:30:00+09:00",
        "endLocal": "2026-07-07T12:00:00+09:00"
      }
    ]
  }'

  output="$(render_calendar "$fixture" "2026-07-07" "2026-07-07T10:30:00+09:00")"
  [[ "$output" == *"Current 😎"* ]]
  [[ "$output" == *"Next"* ]]
  [[ "$output" != *"Today all day"* ]]
  [[ "$output" == *'href="https://meet.google.com/current"'* ]]
  [[ "$output" != *$'\n'* ]]
  exit 0
fi

if ! events_json="$(gog calendar events "$calendar_id" -j 2>/dev/null)"; then
  exit 0
fi

if [[ -z "$events_json" ]]; then
  exit 0
fi

today="$(date +%F)"
now="$(date +%Y-%m-%dT%H:%M:%S%z)"
now="${now%??}:${now: -2}"

output="$(render_calendar "$events_json" "$today" "$now")"

printf '%s\n' "$output"
