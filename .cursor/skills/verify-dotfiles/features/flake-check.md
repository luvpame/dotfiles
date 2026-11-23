# Flake check

`just check` evaluates this repo's Nix flake. The user runs it before a commit that changes `nix/`.

## Sub-features

- `flake-check-pass` exits 0 when the flake evaluates.

## How to get to it (user POV)

- From the repo root, run `just check`.
- From the repo root, run `just c`.

## Driving it with dotfiles-verify

Preconditions:

- `doctor.sh` prints `doctor ok`.
- The machine can reach the Nix substituters this flake uses.

- **Check.** Run `just check`. Send stdout to `.state/verify-dotfiles/evidence/flake-check/stdout.txt` and stderr to `.state/verify-dotfiles/evidence/flake-check/stderr.txt`. Write the exit code to `.state/verify-dotfiles/evidence/flake-check/exit.txt`.
- **Proof.** `exit.txt` is `0`. The stderr log has no evaluation error. This does not activate the system.

## Gotchas

- `just check` does not build the system profile and does not update `$HOME/.dotfiles`.
- A green check does not prove `just switch` will leave the live home intact.
- The recipe runs with working directory `nix/` because `justfile` sets that. Invoke it as `just check` from the repo root, not as a hand-built `nix flake check` from another directory, unless you are recording that you left the recipe.
