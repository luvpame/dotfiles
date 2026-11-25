#!/usr/bin/env bash
# Show a list in the terminal. Rex's own picker has a fixed width,
# so the choice is made here, where the pane can use the window.
# Rex stops an init.lua action after 30 seconds, so the action does not wait
# for the choice. This pane hands the choice to the wide_pick_done action.
set -euo pipefail

list=${1:?}
prompt=${2:-">"}
multi=${3:-}
header=${4:-}
to=${5:?}
cwd=${6:?}

export PATH="${HOME}/.nix-profile/bin:/etc/profiles/per-user/${USER:-}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:${HOME}/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS:${PATH:-/usr/bin:/bin}"
export FZF_DEFAULT_OPTS=
unset FZF_DEFAULT_COMMAND || true

trap 'rm -f "$list"' EXIT

fail() {
  printf '%s\n' "$1" >&2
  read -r -p "Enter で閉じる" _ || true
  exit 1
}

if ! command -v fzf >/dev/null 2>&1; then
  fail "fzf が見つかりません"
fi

args=(
  --reverse
  --height=100%
  --delimiter=$'\t'
  --with-nth=2
  --prompt="${prompt} "
)
if [[ "$multi" == "multi" ]]; then
  args+=(--multi)
  if [[ -n "$header" ]]; then
    header="${header}"$'\n'"Tab で選択、Enter で決定"
  else
    header="Tab で選択、Enter で決定"
  fi
fi
if [[ -n "$header" ]]; then
  args+=(--header="$header")
fi

choice=$(fzf "${args[@]}" <"$list") || exit 0
picked=$(cut -f1 <<<"$choice")
if [[ -z "$picked" ]]; then
  exit 0
fi
if ! rex do wide_pick_done "to=${to}" "cwd=${cwd}" "picked=${picked}"; then
  fail "${to} を続けられませんでした"
fi
