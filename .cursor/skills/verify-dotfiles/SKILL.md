---
name: verify-dotfiles
description: Drive this dotfiles repo from the terminal and prove just recipes. Use when a change touches the justfile, nix/flake.nix, or nix/nix-darwin/home-manager/files.nix and the result has to be shown on the real commands, not only by reading them.
---

# Verify dotfiles

The surface is the `just` CLI in this repo. There is no web UI and no long-running server. A drive is one command in its own temp home, or a read-only `just` recipe. `just switch`, `just update-and-switch`, and `just clean` change this Mac. Do not run them for verification. Two drives may run `just check` together. Two drives may not run `just switch`.

Evidence lives in `.state/verify-dotfiles/evidence/`. That directory is gitignored. Cleanup never deletes it.

## Launch

From the repo root:

```bash
bash .cursor/skills/verify-dotfiles/scripts/doctor.sh
```

Ready when the last line is `doctor ok`. There is no port and no seed database. `just check` needs network access to Nix. The switch guard does not.

## Doctor

`doctor.sh` is read-only. It checks that `justfile`, `nix/flake.nix`, and `nix/nix-darwin/home-manager/files.nix` exist, that `just`, `nix`, and `python3` are on `PATH`, and that `just --list` still shows `check`, `switch`, and `build`. It prints whether the live `$HOME/.dotfiles` is a symlink, something else, or absent. It does not change that path.

Run doctor again whenever a command fails before assuming the recipe is wrong.

## Drive

Run commands from the repo root. The harness is the shell scripts in `.cursor/skills/verify-dotfiles/scripts/` plus the repo's own `just`.

- Flake check: `just check`. Exit 0 is the proof. This evaluates `nix/flake.nix`. It does not activate the config.
- Switch guard: `bash .cursor/skills/verify-dotfiles/scripts/switch-guard.sh`. It copies the guard out of the `switch` recipe in `justfile`, from the `repo_root=` line up to but not including `nh darwin switch`, and runs that fragment with `HOME` set to a temp directory and the working directory set to `nix/`, which is where `just` runs the recipe.

Refuse `just switch`, `just update-and-switch`, `just clean`, and `script/migrate-agent-skills.sh` without `--dry-run`. Those write the live home or the Nix system profile.

## Evidence

Write one directory per feature under `.state/verify-dotfiles/evidence/<feature>/`. Keep the command, stdout, stderr, and exit code. For the switch guard, also keep `*.observe`, which records the temp `$HOME/.dotfiles` kind and the sentinel file.

A passing dry-run is not proof that the real command skipped a write. `switch-guard.sh` never calls `nh`. Say that in the proof.

Proof has to show the action and the resulting state. A zero exit code alone is not enough when the feature claims a file was kept or replaced.

## Cleanup

```bash
bash .cursor/skills/verify-dotfiles/scripts/cleanup.sh
```

This deletes temp directories recorded in `.state/verify-dotfiles/temps/list` when they are under `/tmp` or `/var/folders`. It does not delete `.state/verify-dotfiles/evidence/`. Do not `pkill` by name.

## Helpers

- `bash .cursor/skills/verify-dotfiles/scripts/doctor.sh`
- `bash .cursor/skills/verify-dotfiles/scripts/switch-guard.sh`
- `bash .cursor/skills/verify-dotfiles/scripts/cleanup.sh`

The feature map is `.cursor/skills/verify-dotfiles/features/README.md`.
