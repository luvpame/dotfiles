#!/bin/sh
# SessionStart hook: Claude desktop が作った worktree に、本体の .worktree-setup を流す。
# Desktop の worktree 作成は wt も WorktreeCreate フックも通らず、worktrunk の pre-start が走らないため。
# CLI では worktrunk に任せるので、Desktop 以外では何もしない。

set -eu

[ "${CLAUDE_CODE_ENTRYPOINT:-}" = "claude-desktop" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

cwd="$(jq -r '.cwd // empty')"
[ -n "$cwd" ] || exit 0

worktree="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)" || exit 0
primary="$(dirname "$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir)")"
[ "$worktree" != "$primary" ] || exit 0
[ -x "$primary/.worktree-setup" ] || exit 0

# セットアップに失敗してもセッションは止めない。
"$primary/.worktree-setup" "$primary" "$worktree" >&2 || true
