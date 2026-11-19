# Dotfiles verification map

This directory is the maintained source for verifying the user-facing `just` commands. Read this index, then use the matching feature file.

## Baseline preconditions

- The current directory is the repo root, the directory that contains `justfile`.
- `bash .cursor/skills/verify-dotfiles/scripts/doctor.sh` prints `doctor ok`.
- Do not run `just switch`, `just update-and-switch`, or `just clean`. They change the live Mac.
- A temp `HOME` created by `switch-guard.sh` is the only home a drive may write.

## Driving conventions

- Start every recipe from the repo root.
- Treat every command as literal.
- Capture stdout, stderr, and the exit code under `.state/verify-dotfiles/evidence/<feature>/`.
- Leave that evidence in place when cleaning up temp homes.

## Proof and skip reporting

- Record the command and the resulting state.
- A skipped `just switch` is not verified by the guard fragment. Say which part was not run.
- If a precondition is missing, stop that journey and write the reason. Do not swap in a weaker command and call the feature verified.

## Features

- [Flake check](./flake-check.md) covers `just check`.
- [Switch guard](./switch-guard.md) covers the refusal to replace a real `$HOME/.dotfiles` directory.
