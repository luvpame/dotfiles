#!/bin/bash
# Remove temp homes this skill recorded. Leave evidence in place.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../../../.." && pwd)"
list="$repo_root/.state/verify-dotfiles/temps/list"

if [[ -f "$list" ]]; then
  while IFS= read -r dir; do
    [[ -n "$dir" ]] || continue
    case "$dir" in
      /tmp/*|/var/folders/*)
        rm -rf "$dir"
        ;;
      *)
        printf 'skip unexpected temp %s\n' "$dir" >&2
        exit 1
        ;;
    esac
  done <"$list"
  rm -f "$list"
fi

printf 'cleanup ok\n'
