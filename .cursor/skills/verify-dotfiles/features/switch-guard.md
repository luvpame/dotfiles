# Switch guard

`just switch` stops when `$HOME/.dotfiles` exists and is not a symlink. It prints `上書きせずに停止しました` and does not replace that path.

## Sub-features

- `switch-refuse-directory` leaves a real directory in place and exits 1.
- `switch-replace-symlink` points an existing symlink at this repo.
- `switch-create-link` creates the symlink when the path is absent.

## How to get to it (user POV)

- From the repo root, run `just switch`.
- From the repo root, run `just s`.

## Driving it with dotfiles-verify

Preconditions:

- `doctor.sh` prints `doctor ok`.
- The live `$HOME` is not the home under test. `switch-guard.sh` sets `HOME` to a temp directory.

- **Refuse a directory.** Run `bash .cursor/skills/verify-dotfiles/scripts/switch-guard.sh`. The `directory` case writes `.state/verify-dotfiles/evidence/switch-guard/directory.observe` with `status=1`, `kind=directory`, and `sentinel=kept`, and `directory.stderr` contains `上書きせずに停止しました`.
- **Replace a symlink.** The same command's `symlink` case writes `symlink.observe` with `status=0`, `kind=symlink`, and `target=` set to this repo's physical path.
- **Create a missing link.** The `absent` case writes the same shape as the symlink case.
- **Proof.** `.state/verify-dotfiles/evidence/switch-guard/summary.txt` ends with `PASS switch-guard`.

The full user command also runs `nh darwin switch`. This drive stops before that line. A pass does not prove the activation.

## Gotchas

- Do not point this script at the real `$HOME`. The guard is the part that protects a non-symlink `.dotfiles`.
- `ln -shf` is reached only after the guard. On a directory case the link command must not run. `kind=directory` and `sentinel=kept` are the proof, not the exit code alone.
- `just switch` from the live home is a refused entry point. Report it as not driven.
