#!/bin/bash
set -euo pipefail

# 外部スキルへの切り替え後に旧原本を退避する。反映前には移動しない。
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
names=(show-me japanese-tech-writing cognitive-rhythm-writing code-simplifier empirical-prompt-tuning herdr)
case "${1:-}" in
  --dry-run)
    printf 'After just switch, archive these local originals under archive/agents/skills/:\n'
    printf '  %s\n' "${names[@]}"
    exit 0
    ;;
  "") ;;
  *) printf 'Usage: %s [--dry-run]\n' "$0" >&2; exit 2 ;;
esac

cd "$repo_root"
just switch

# 全配布先が Nix store を参照していることを、原本を移動する前に確認する。
for name in "${names[@]}"; do
  for target in "$HOME/.agents/skills" "$HOME/.claude/skills"; do
    actual="$(cd "$target/$name" && pwd -P)"
    case "$actual" in
      /nix/store/*) ;;
      *) printf 'Skill is not externally managed yet: %s\n' "$target/$name" >&2; exit 1 ;;
    esac
  done
  if [[ -e "$repo_root/config/agents/skills/$name" && ( -e "$repo_root/archive/agents/skills/$name" || -L "$repo_root/archive/agents/skills/$name" ) ]]; then
    printf 'Archive already exists: %s\n' "$repo_root/archive/agents/skills/$name" >&2
    exit 1
  fi
done

mkdir -p "$repo_root/archive/agents/skills"
for name in "${names[@]}"; do
  if [[ -d "$repo_root/config/agents/skills/$name" ]]; then
    mv "$repo_root/config/agents/skills/$name" "$repo_root/archive/agents/skills/$name"
  fi
done
printf 'External skills activated; local originals archived.\n'
