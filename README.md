# dotfiles

Reproducible macOS dotfiles for Apple Silicon.

Built with Nix, nix-darwin, Home Manager, Homebrew, and Fish.

## What it manages

| Area | Location |
| --- | --- |
| System and packages | `nix/` |
| User and application configuration | `config/` |
| Menu bar helpers | `menubar-script/` |
| Small utilities | `script/` |

Most managed files use Home Manager out-of-store symlinks into the checkout, so edits take effect immediately. Run `just switch` after changing Nix packages, Homebrew applications, macOS defaults, or the set of managed files.

## Requirements

- Apple Silicon Mac running macOS
- [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/)
- [Nix](https://github.com/NixOS/nix-installer) with flakes enabled
- [Homebrew](https://brew.sh/)

Install anything missing:

```bash
xcode-select --install

curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Restart the shell after installing Nix so that `nix` is available.

## Setup

Clone the repository and point `$HOME/.dotfiles` at the checkout:

```bash
git clone https://github.com/luvpame/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles

if [ -e "$HOME/.dotfiles" ] && [ ! -L "$HOME/.dotfiles" ]; then
  echo "$HOME/.dotfiles is not a symlink; refusing to overwrite it." >&2
  exit 1
fi

ln -shf "$(pwd -P)" "$HOME/.dotfiles"
```

Set `dotfiles.user.name` in [`nix/nix-darwin/users.nix`](nix/nix-darwin/users.nix). This is the single user name used by the configuration.

Create the local Git configuration from [`config/git/config.local.example`](config/git/config.local.example), then fill in your identity:

```bash
test -f config/git/config.local || cp config/git/config.local.example config/git/config.local
$EDITOR config/git/config.local
```

Set `user.name`, `user.email`, and `ghq.root`. Home Manager exposes this file as `~/.config/git/config.local`, which the managed Git config includes. Keep it out of version control. The shared Git configuration uses Secure Enclave for commit signing, so complete the Git commit signing setup below before committing. Keep the 1Password SSH Agent enabled for push and pull.

## Git commit signing

The repository includes a repeatable setup wizard for moving commit signing to a non-exportable Secure Enclave key. Run it from a normal interactive Terminal session on each Mac. `sc_auth` and CryptoTokenKit may not be available from an agent or another non-interactive process.

The wizard creates or validates a `p-256-ne` CTK identity with `-t none`, creates the SSH key handle pair at `~/.ssh/id_git_sign` and `~/.ssh/id_git_sign.pub` when needed, and runs a temporary signed commit verification. The private key never leaves the Secure Enclave, while the reference files remain device-specific.

OpenSSH may show a generic authenticator PIN prompt even for this key. The wizard answers it with an empty input; if a PIN or password is requested interactively, enter nothing and stop the wizard.

The default command performs the local setup and self-test, then prints the exact GitHub command without changing the GitHub account:

```bash
./script/setup-git-signing.sh
```

To let the wizard check the GitHub signing-key list and register the public key after the self-test and an explicit confirmation, use:

```bash
gh auth login
# Run this once before the first registration (or when the wizard reports a missing scope).
gh auth refresh -h github.com -s admin:ssh_signing_key
./script/setup-git-signing.sh --register-github
```

The wizard checks that scope before it changes GitHub. If the check reports a network or other API error, it stops without treating that error as a scope problem.

The GitHub key title uses `git-sign@<short-hostname>` so multiple Macs can be distinguished. If the hostname is unavailable, the title falls back to `git-sign`; repeated-run detection compares the public-key contents instead of the title.

The shared Git configuration now uses Secure Enclave for commit signing. On an existing Mac, run the wizard before relying on the new configuration. With `--register-github`, it checks GitHub API access during preflight, completes the local self-test, and then registers the key after confirmation. After the new key produces a `Verified` commit on GitHub, remove only the old 1Password Signing key from GitHub. Keep the 1Password SSH Agent and its authentication key for push and pull.

This migration changes commit signing only. Tag signing is unchanged. `-t none` deliberately avoids Touch ID or passcode prompts so an unattended Coding Agent can finish a commit; any process running as the logged-in user can therefore request a signature. Secure Enclave storage protects the private key from export, but it does not protect against malware already running in that account.

The wizard does not create a permanent `allowedSignersFile`. Its verification file and temporary Git repository are removed after the self-test; GitHub's `Verified` status is the ongoing verification record.

Sign in to the Mac App Store before switching; `mas` installs App Store applications as part of the configuration.

Apply the initial system configuration. `just` is installed by Home Manager during this step, so it is not required yet:

```bash
cd nix
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run github:LnL7/nix-darwin -- switch --flake "path:.#default"
cd ..
```

## Everyday commands

| Command | Purpose |
| --- | --- |
| `just check` | Validate the flake |
| `just build` | Build the Darwin system |
| `just switch` | Apply the configuration |
| `just clean` | Remove old Nix generations |

`just switch` updates `$HOME/.dotfiles` to the physical path of the current checkout before applying changes, so clone locations and Git worktrees are supported.

## Fish

Set Fish as the default shell after the first switch:

```bash
./script/set-fish-default.sh
```

Log out and back in, or start a new Fish session, then update plugins:

```bash
fish
fisher update
```

## CI and Cachix

GitHub Actions checks and prebuilds `darwinConfigurations.default.system` for `aarch64-darwin` on `macos-15`, then publishes the result to the public `luvpame` Cachix cache. Add a repository secret named `CACHIX_AUTH_TOKEN` with permission to push to Cachix. The flake and nix-darwin configuration already declare `luvpame.cachix.org`, so local builds can use the same cache.

Pushes to `main` that change `nix/**` or this workflow build the current `flake.lock`. A schedule runs at 17 minutes past every hour (UTC), updates flake inputs, and builds only when `flake.lock` changes. A successful update commits the new lock file to `main`. Manual runs on `main` can enable `force_build` to rebuild the current lock even when it is unchanged.

Pull CI's updated `nix/flake.lock` before running `just switch` to use the prebuilt inputs. `just us` updates inputs locally and switches immediately, so its result may differ from the CI build.

## Authentication

After switching, sign in to services that need authentication:

- 1Password and 1Password CLI
- GitHub CLI, if needed: `gh auth login`
