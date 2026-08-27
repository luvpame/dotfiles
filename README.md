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

Set `user.name`, `user.email`, `user.signingkey`, and `ghq.root`. Home Manager exposes this file as `~/.config/git/config.local`, which the managed Git config includes. Keep it out of version control. Commits use 1Password SSH signing, so sign in to 1Password and enable its SSH Agent before committing.

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

Pushes to `nix/**` or this workflow build the current `flake.lock`. A schedule runs at 17 minutes past every hour (UTC), updates flake inputs, and builds only when `flake.lock` changes. A successful update commits the new lock file to `main`. Manual runs can enable `force_build` to rebuild the current lock even when it is unchanged.

Pull CI's updated `nix/flake.lock` before running `just switch` to use the prebuilt inputs. `just us` updates inputs locally and switches immediately, so its result may differ from the CI build.

## Authentication

After switching, sign in to services that need authentication:

- 1Password and 1Password CLI
- GitHub CLI, if needed: `gh auth login`
