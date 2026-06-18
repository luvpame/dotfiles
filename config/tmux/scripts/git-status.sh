#!/bin/bash
set -euo pipefail

mode="${1:-full}"
path="${2:-$PWD}"

git_read() {
	GIT_OPTIONAL_LOCKS=0 git "$@"
}

if ! git_read -C "$path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	exit 0
fi

branch="$(git_read -C "$path" branch --show-current 2>/dev/null || true)"
if [[ -z $branch ]]; then
	branch="$(git_read -C "$path" rev-parse --short HEAD 2>/dev/null || true)"
fi

if [[ -z $branch ]]; then
	exit 0
fi

print_branch() {
	printf " #[fg=#1e66f5]󰊢#[fg=#4c4f69] %s" "$branch"
}

print_diff() {
	local added_lines=0
	local deleted_lines=0
	local diff_added
	local diff_deleted
	local modified=0
	local status
	local untracked=0

	while read -r diff_added diff_deleted _; do
		[[ $diff_added == "-" || $diff_deleted == "-" ]] && continue

		added_lines=$((added_lines + diff_added))
		deleted_lines=$((deleted_lines + diff_deleted))
	done < <(git_read -C "$path" diff --numstat HEAD -- 2>/dev/null || true)

	while IFS= read -r line; do
		status="${line:0:2}"

		case "$status" in
			"??")
				((untracked += 1))
				continue
				;;
		esac

		[[ $status == *M* || $status == *R* || $status == *C* ]] && ((modified += 1))
	done < <(git_read -C "$path" status --porcelain=v1 2>/dev/null || true)

	printf " #[fg=#4c4f69]| L:"
	printf " #[fg=#40a02b]+%02d" "$added_lines"
	printf " #[fg=#d20f39]-%02d" "$deleted_lines"
	printf " #[fg=#4c4f69]| 󰈙:"
	printf " #[fg=#df8e1d]~%02d" "$modified"
	printf " #[fg=#8839ef]?%02d" "$untracked"
}

case "$mode" in
	branch)
		print_branch
		;;
	diff)
		print_diff
		;;
	*)
		print_branch
		print_diff
		printf " #[fg=#4c4f69]・"
		;;
esac
