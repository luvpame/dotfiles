#!/bin/bash
# Drive the just switch symlink guard against a temp HOME.
# Stops before `nh darwin switch`. Does not touch the real $HOME/.dotfiles.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../../../.." && pwd)"
evidence="${EVIDENCE:-$repo_root/.state/verify-dotfiles/evidence/switch-guard}"
temps="$repo_root/.state/verify-dotfiles/temps"
mkdir -p "$evidence" "$temps"
: >"$evidence/summary.txt"

justfile="$repo_root/justfile"
extracted="$(
  awk '
    /^    repo_root=/ { p = 1 }
    p && /^    nh darwin switch/ { exit }
    p { sub(/^    /, ""); print }
  ' "$justfile"
)"

if [[ "$extracted" != *'上書きせずに停止しました'* ]]; then
  printf 'justfile guard text not found\n' >&2
  exit 2
fi
if [[ "$extracted" == *'nh darwin switch'* ]]; then
  printf 'extraction included nh darwin switch; refusing\n' >&2
  exit 2
fi

expected_repo="$(cd "$repo_root/nix" && cd .. && pwd -P)"

run_case() {
  local name="$1"
  local home status
  home="$(mktemp -d)"
  printf '%s\n' "$home" >>"$temps/list"

  case "$name" in
    directory)
      mkdir -p "$home/.dotfiles/keep"
      printf 'kept\n' >"$home/.dotfiles/keep/file"
      ;;
    symlink)
      mkdir -p "$home/old-target"
      ln -s "$home/old-target" "$home/.dotfiles"
      ;;
    absent) ;;
    *)
      printf 'unknown case %s\n' "$name" >&2
      exit 2
      ;;
  esac

  # set -e would stop the script on the directory case before the status is recorded.
  set +e
  (
    cd "$repo_root/nix"
    export HOME="$home"
    bash -s
  ) <<<"$extracted" >"$evidence/$name.stdout" 2>"$evidence/$name.stderr"
  status=$?
  set -e

  {
    printf 'status=%s\n' "$status"
    if [[ -L "$home/.dotfiles" ]]; then
      printf 'kind=symlink\n'
      printf 'target=%s\n' "$(readlink "$home/.dotfiles")"
    elif [[ -d "$home/.dotfiles" ]]; then
      printf 'kind=directory\n'
    elif [[ ! -e "$home/.dotfiles" ]]; then
      printf 'kind=absent\n'
    else
      printf 'kind=other\n'
    fi
    if [[ -f "$home/.dotfiles/keep/file" ]]; then
      printf 'sentinel=%s\n' "$(cat "$home/.dotfiles/keep/file")"
    else
      printf 'sentinel=missing\n'
    fi
  } >"$evidence/$name.observe"

  case "$name" in
    directory)
      [[ "$status" -eq 1 ]]
      grep -q '上書きせずに停止しました' "$evidence/$name.stderr"
      grep -q '^kind=directory$' "$evidence/$name.observe"
      grep -q '^sentinel=kept$' "$evidence/$name.observe"
      ;;
    symlink | absent)
      [[ "$status" -eq 0 ]]
      grep -q '^kind=symlink$' "$evidence/$name.observe"
      grep -q "^target=${expected_repo}$" "$evidence/$name.observe"
      ;;
  esac

  printf 'PASS %s\n' "$name" | tee -a "$evidence/summary.txt"
  rm -rf "$home"
}

run_case directory
run_case symlink
run_case absent
printf 'PASS switch-guard\n' | tee -a "$evidence/summary.txt"
