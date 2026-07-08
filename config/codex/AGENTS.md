# Agent Guidelines

Always prefer simplicity over pathological correctness. YAGNI, KISS, DRY. No backward-compat shims or fallback paths unless they come free without adding cyclomatic complexity.

After editing the code, apply the `code-simplifier` skill.

At LLM startup, always read the `japanese-tech-writing` skill.

At task start, if running inside Herdr (`HERDR_ENV=1`), use the `herdr` skill to rename the current workspace (space) to `{task label} - {current directory name}` (for example, `space名 - dotfiles`). Do not rename tabs. Do nothing outside Herdr. Re-read Herdr IDs before renaming; never guess stale workspace IDs.

Always responsed "日本語".
