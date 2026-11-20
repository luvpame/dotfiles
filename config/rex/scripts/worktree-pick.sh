#!/usr/bin/env bash
# Show a worktree list in the terminal. Rex's own picker has a fixed width,
# so paths are chosen here, where the pane can use the window.
set -euo pipefail

result=${1:?}
list=${2:?}
prompt=${3:-">"}
multi=${4:-}

export PATH="${HOME}/.nix-profile/bin:/etc/profiles/per-user/${USER:-}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:${PATH:-/usr/bin:/bin}"
export FZF_DEFAULT_OPTS=
unset FZF_DEFAULT_COMMAND || true

finish() {
  if [[ ! -f "$result" ]]; then
    : >"$result"
  fi
}
trap finish EXIT

if ! command -v fzf >/dev/null 2>&1; then
  printf '%s\n' "fzf が見つかりません" >"${result}.err"
  exit 1
fi

args=(
  --reverse
  --height=100%
  --delimiter=$'\t'
  --with-nth=2
  --prompt="${prompt} "
)
if [[ "$multi" == "multi" ]]; then
  args+=(--multi --header="Tab で選択、Enter で決定")
fi

if choice=$(fzf "${args[@]}" <"$list"); then
  printf '%s\n' "$choice" >"${result}.part"
  mv "${result}.part" "$result"
else
  : >"$result"
fi
