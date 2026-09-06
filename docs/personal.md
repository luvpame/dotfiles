# Personal dotfiles

`main` maintains the work configuration. `personal` keeps the personal changes on top of it, using the same `darwinConfigurations.default` entry point and the same checkout at `/Users/luvpame/dev/github.com/luvpame/dotfiles`.

Do not create a second checkout for the personal branch. Switch branches in this checkout so ghq continues to find the repository at its canonical path.

## Switching branches safely

Before switching branches, commit or stash all local changes and confirm that the worktree is clean:

```bash
cd /Users/luvpame/dev/github.com/luvpame/dotfiles
git status --short
git switch personal
```

Use `git switch main` for the work configuration and `git switch personal` for the personal configuration. Most application settings are linked directly into the selected checkout through `$HOME/.dotfiles`, so switching branches can affect running applications immediately, even before `just switch` runs.

On the personal Mac, keep `personal` checked out and do not apply `main` with `just switch`. Review the branch and the Homebrew application list before applying a configuration; activation uses `cleanup = "zap"`, so applications absent from the managed list may be removed. Sign in to the Mac App Store for Xcode and other managed App Store apps.

## First personal apply

1. Create `config/git/config.local` using the README setup instructions, or copy your existing personal Git configuration there.
2. Follow the README's Git signing setup on this Mac if `~/.ssh/id_git_sign` is not configured.
3. Check out `personal`, then validate and build from the canonical checkout:

   ```bash
   cd /Users/luvpame/dev/github.com/luvpame/dotfiles
   git switch personal
   just check
   just build
   ```

4. Apply the reviewed configuration with `just switch`. Run `fisher update` in Fish afterward if plugin definitions changed.

## Incorporating work configuration updates

Keep personal changes in focused commits. Before syncing, finish or stash local changes and verify `git status --short` is empty. Update `main` and merge it into `personal` from the same checkout:

```bash
cd /Users/luvpame/dev/github.com/luvpame/dotfiles
git switch main
git fetch origin
git merge --ff-only origin/main
git switch personal
git merge main
```

Review incoming user settings, application lists, agent configuration, and any merge conflicts. Preserve the personal user name and required personal applications. Then run `just check` and `just build` before applying the result with `just switch`.

Prefer landing shared improvements on `main`, then merging them into the personal branch. Do not merge the entire personal branch back into the work configuration.

## Dependency updates and CI

Keep `nix/flake.lock` from the main branch's CI updates when syncing. Do not hand-edit the lock file. The existing workflow builds and updates `main`; it does not validate pushes to the personal branch. Shared derivations may reuse the cache, but the personal system still needs its own local validation and build.

Use `just update-and-switch` only when deliberately updating dependencies locally instead of using the versions already built by main's CI.
