# Herdr GUI settings

Home Manager activation copies `config/herdr/config.toml` into the Herdr config directory. An edit made in the Herdr GUI stays in place until the dotfiles copy of that file changes. The first run leaves an existing file in place. A missing file is restored from the dotfiles copy.

## Sub-features

- `herdr-keep-gui` keeps a GUI edit across a second sync when the dotfiles file is unchanged.
- `herdr-dotfiles-wins` replaces only the file whose dotfiles copy changed.
- `herdr-adopt` keeps a file that already existed before the first sync.
- `herdr-restore` recreates a deleted destination from the dotfiles copy.
- `herdr-dry-run` writes neither the destination nor the state file.

## How to get to it (user POV)

- Edit Herdr's `config.toml` in the app, then run `just switch` from the repo root.
- Change `config/herdr/config.toml` in this repo, then run `just switch`.

## Driving it with dotfiles-verify

Preconditions:

- `doctor.sh` prints `doctor ok`.
- `/nix/store` contains a `coreutils` that provides `bin/install` and a `diffutils` that provides `bin/cmp`. `check.py` looks these up itself.

- **Sync.** Run `python3 .cursor/skills/verify-herdr-config-sync/check.py`. Send stdout to `.state/verify-dotfiles/evidence/herdr-gui-survives/stdout.txt` and stderr to `.state/verify-dotfiles/evidence/herdr-gui-survives/stderr.txt`. Write the exit code to `.state/verify-dotfiles/evidence/herdr-gui-survives/exit.txt`.
- **Proof.** `exit.txt` is `0` and stdout ends with `PASS herdr-config-sync`. This runs the activation bash extracted from `files.nix` inside temp directories. It does not run `just switch`.

## Gotchas

- `just switch` is the user entry point and is not driven here. Report the activation half as a stand-in. The stand-in substitutes `${configRoot}`, `${config.xdg.configHome}`, `${config.xdg.stateHome}`, `${pkgs.coreutils}`, and `${pkgs.diffutils}`, and it defines `run` so the commands execute. Home Manager's dry-run flag, the rest of activation, and the system profile are not run.
- `python3 script/test-herdr-config-sync.py` errors on `config-gpui.local.toml`. The activation loop lists only `config.toml`. Do not treat that unit test as this feature's proof.
- Byte equality is `cmp -s`. Two TOML texts that parse the same and differ as bytes are a change.
