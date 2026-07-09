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
  local now="$2"

  jq -r --arg now "$now" '
    def self_declined:
      any(.attendees[]?; .self == true and .responseStatus == "declined");

    def title:
      (.summary // "(無題)")
      | gsub("[\r\n\t ]+"; " ")
      | gsub("^ +| +$"; "")
      | gsub("\\|"; "／");

    def timed:
      .status == "confirmed"
      and (.start.dateTime? != null)
      and (self_declined | not);

    def iso_epoch:
      gsub(":(?=[0-9][0-9]$)"; "")
      | strptime("%Y-%m-%dT%H:%M:%S%z")
      | mktime;

    def minutes_until($time):
      ((($time | iso_epoch) - ($now | iso_epoch)) / 60 | floor);

    def duration_label:
      . as $minutes
      | ($minutes % 60) as $remainder
      | if $minutes > 60 then
        (($minutes / 60 | floor | tostring) + "時間"
          + if $remainder == 0 then "" else (($remainder | tostring) + "分") end
          + "後")
      else
        (($minutes | tostring) + "分後")
      end;

    def start_time: .startLocal[11:16];
    def running: .startLocal <= $now and .endLocal > $now;
    def future: .startLocal >= $now;
    def today_event: .startLocal[0:10] == $now[0:10];
    def starts_in: minutes_until(.startLocal);
    def upcoming_badge($icon): $icon + " " + (starts_in | duration_label);
    def upcoming_text($icon):
      upcoming_badge($icon) + " " + start_time + " " + title;

    (.events // []) as $events
    | ($events | map(select(timed)) | sort_by(.startLocal)) as $timed
    | ($timed | map(select(running))) as $current
    | ($timed | map(select(future and (running | not)))[0]) as $next
    | ($timed | map(select(future and today_event))[0]) as $next_today
    | if ($current | length) > 0 then
        (($current | map("󰥔 " + title) | join("  "))
          + if $next == null then "" else "  " + ($next | upcoming_badge("󰝖")) end)
      elif $next_today != null then
        ($next_today | upcoming_text("󰃭"))
      else
        "󰅐 空き"
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
        "endLocal": "2026-07-07T11:00:00+09:00"
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
  far_fixture='{
    "events": [
      {
        "status": "confirmed",
        "summary": "Far",
        "start": { "dateTime": "2026-07-07T12:30:00+09:00" },
        "end": { "dateTime": "2026-07-07T13:00:00+09:00" },
        "startLocal": "2026-07-07T12:30:00+09:00",
        "endLocal": "2026-07-07T13:00:00+09:00"
      }
    ]
  }'

  output="$(render_calendar "$fixture" "2026-07-07T10:30:00+09:00")"
  [[ "$output" == "󰥔 Current 😎  󰝖 60分後" ]]

  output="$(render_calendar "$fixture" "2026-07-07T10:10:00+09:00")"
  [[ "$output" == "󰥔 Current 😎  󰝖 1時間20分後" ]]

  output="$(render_calendar "$far_fixture" "2026-07-07T10:30:00+09:00")"
  [[ "$output" == "󰃭 2時間後 12:30 Far" ]]

  output="$(render_calendar "$fixture" "2026-07-07T11:00:00+09:00")"
  [[ "$output" == "󰃭 30分後 11:30 Next" ]]

  output="$(render_calendar '{"events":[]}' "2026-07-07T10:30:00+09:00")"
  [[ "$output" == "󰅐 空き" ]]
  exit 0
fi

if ! events_json="$(gog calendar events "$calendar_id" -j 2>/dev/null)"; then
  exit 0
fi

if [[ -z "$events_json" ]]; then
  exit 0
fi

now="$(date +%Y-%m-%dT%H:%M:%S%z)"
now="${now%??}:${now: -2}"

output="$(render_calendar "$events_json" "$now")"

printf '%s\n' "$output"
