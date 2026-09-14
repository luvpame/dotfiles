#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
dry_run=false
case "${1:-}" in
  --dry-run) dry_run=true ;;
  "") ;;
  *) printf 'Usage: %s [--dry-run]\n' "$0" >&2; exit 2 ;;
esac

paths=()
for relative in .agents .claude/skills; do
  target="$HOME/$relative"
  if [[ -L "$target" ]]; then
    expected="$repo_root/config/agents"
    [[ "$relative" == .agents ]] || expected="$expected/skills"
    if [[ "$(cd "$target" && pwd -P)" != "$expected" ]]; then
      printf 'Refusing unexpected link: %s\n' "$target" >&2
      exit 1
    fi
    paths+=("$target")
  fi
done
for name in cloudflare-deploy web-perf; do
  target="$HOME/.codex/skills/$name"
  if [[ -L "$target" || ( -e "$target" && ! -d "$target" ) ]]; then
    printf 'Refusing unexpected skill path: %s\n' "$target" >&2
    exit 1
  fi
  if [[ -d "$target" ]]; then
    paths+=("$target")
  fi
done

if $dry_run; then
  printf 'Build, authenticate with sudo, back up these paths, then run just switch:\n'
  if [[ ${#paths[@]} -gt 0 ]]; then
    printf '  %s\n' "${paths[@]}"
  fi
  exit 0
fi

cd "$repo_root"
just build
sudo -v
if [[ ${#paths[@]} -eq 0 ]]; then
  exec just switch
fi

mkdir -p "$HOME/.local/state/dotfiles"
backup_dir="$(mktemp -d "$HOME/.local/state/dotfiles/agent-skills.XXXXXX")"
printf 'Backup: %s\n' "$backup_dir"

rollback() {
  status=$?
  trap - EXIT
  set +e
  for i in "${!paths[@]}"; do
    if [[ -e "$backup_dir/$i" || -L "$backup_dir/$i" ]]; then
      if [[ -e "${paths[$i]}" || -L "${paths[$i]}" ]]; then
        if ! mv "${paths[$i]}" "$backup_dir/failed-$i"; then
          printf 'Could not restore %s; original retained at %s\n' "${paths[$i]}" "$backup_dir/$i" >&2
          continue
        fi
      fi
      if ! mv "$backup_dir/$i" "${paths[$i]}"; then
        printf 'Could not restore %s; original retained at %s\n' "${paths[$i]}" "$backup_dir/$i" >&2
      fi
    fi
  done
  printf 'Migration failed; restoration attempted. Inspect backup: %s\n' "$backup_dir" >&2
  exit "$status"
}
trap rollback EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
for i in "${!paths[@]}"; do
  printf '%s\t%s\n' "$i" "${paths[$i]}" >> "$backup_dir/paths.tsv"
  mv "${paths[$i]}" "$backup_dir/$i"
done
just switch
trap - EXIT INT TERM
printf 'Migration complete. Original paths retained in %s\n' "$backup_dir"
