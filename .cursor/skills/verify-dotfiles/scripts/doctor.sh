#!/bin/bash
# Read-only. Answers whether this checkout can be driven.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../../../.." && pwd)"
cd "$repo_root"

test -f justfile
test -f nix/flake.nix
test -f nix/nix-darwin/home-manager/files.nix
command -v just >/dev/null
command -v nix >/dev/null
command -v python3 >/dev/null

list="$(just --list)"
grep -q '^    check' <<<"$list"
grep -q '^    switch' <<<"$list"
grep -q '^    build' <<<"$list"

printf 'repo=%s\n' "$repo_root"
printf 'just=%s\n' "$(command -v just)"
printf 'nix=%s\n' "$(command -v nix)"
if [[ -L "$HOME/.dotfiles" ]]; then
  printf 'live_dotfiles=symlink:%s\n' "$(readlink "$HOME/.dotfiles")"
elif [[ -e "$HOME/.dotfiles" ]]; then
  printf 'live_dotfiles=not-a-symlink\n'
else
  printf 'live_dotfiles=absent\n'
fi
printf 'doctor ok\n'
