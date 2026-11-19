---
name: verify-herdr-config-sync
description: Exhaustively check the Herdr config.toml activation copy in nix/nix-darwin/home-manager/files.nix. Use when editing copyHerdrConfig, or when a switch must not wipe Herdr GUI edits and must still pick up a dotfiles change.
---

# Herdr config copy

A Herdr GUI edit to `config.toml` survives the next activation unless the dotfiles copy of that file changed since the previous activation. A missing `config.toml` is restored from the dotfiles copy. The first activation leaves an existing `config.toml` in place.

Harm if this breaks: the next `just switch` either wipes the user's Herdr settings or ignores a `config.toml` change they committed.

The check runs the bash embedded in `home.activation.copyHerdrConfig`. It does not run a separate model of that bash. Bash has no verifier on this machine (no Java, so no TLC), and the step is one straight-line decision per file, so every combination of the three file bodies is runnable on the real script.

## When a change touches this

The covered code is the body of `home.activation.copyHerdrConfig` in `nix/nix-darwin/home-manager/files.nix`, the `for file in config.toml` loop. Last confirmed at commit `fbc68955d205134f4b089d620c90541568260f0c`.

If that loop changes after that commit, read the new bash, rerun the command below, and move this commit forward only after the check still describes the new bash. A passing check against an old extract is not a pass.

## Run

From the repo root:

```bash
python3 .cursor/skills/verify-herdr-config-sync/check.py
```

Exit 0 and a final line `PASS herdr-config-sync` means every case matched. Exit 1 means a case disagreed with the property. The failing line names the file states before the run and the bytes after it. Exit 2 means the script could not extract the activation or find `install` and `cmp` in `/nix/store`.

## How to read a failure

The property, in the code's words:

- `target` is missing, or `previous` exists and `cmp -s` says `source` and `previous` differ: `install -Dm600` copies `source` onto `target`.
- Otherwise `target` is left as it was. That is the GUI edit, and the first-run case where `previous` does not exist yet.
- `previous` is always then set to `source`.

A counterexample is one of those states. Example: `previous` equals `source`, `target` is the GUI text, and after the run `target` equals `source`. The activation took the copy branch even though the dotfiles file had not changed. Fix the bash, or fix the checker if it no longer matches the bash. Do not loosen the expected bytes to make the run pass.

A modeling error looks different: exit 2, a missing `install`, or an extract that does not contain `cmp -s`. That is the checker failing to see the code, not Herdr failing the property.

## Bounds

- One file name, `config.toml`. The loop lists no other name.
- Bodies are empty, `a\n`, and `GUI\n`, plus missing for `target` and `previous`. `source` is always present. That is 3 × 4 × 4 = 48 single runs, then one three-step story (adopt, keep a GUI edit, apply a dotfiles change).
- Comparison is `cmp -s`, byte for byte, not TOML equality.
- `run` executes its arguments. Home Manager dry-run is out of scope.
- The tools are some GNU `coreutils` `install` and `diffutils` `cmp` from `/nix/store`, not necessarily the store paths of the current flake evaluation.
- No concurrent activation. The rest of Home Manager is not run. `just switch` is not run.

`config-gpui.local.toml` is not in the loop. `script/test-herdr-config-sync.py` still lists it. This check does not cover that name.
