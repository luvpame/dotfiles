# dotfiles

## setup

### 対象環境

- Apple Silicon Mac
- macOS

### 事前準備

このリポジトリを適用する前に、Xcode Command Line Tools、Nix、Homebrew をインストールする。
Nix は [`NixOS/nix-installer`](https://github.com/NixOS/nix-installer) からインストールする。

```bash
xcode-select --install

curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Nix のインストール後は、`nix` コマンドを使えるようにシェルを再起動する。

### 初回適用

clone 先は任意に決められる。
以下では `~/src/dotfiles` を例にする。

```bash
git clone https://github.com/luvpame/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
```

Nix は `$HOME/.dotfiles` を現在使う checkout の入口として参照する。
初回 switch の前に、clone した場所からこのシンボリックリンクを作成する。
`$HOME/.dotfiles` にシンボリックリンクではないファイルやディレクトリがある場合は、上書きせずに停止する。

```bash
if [ -e "$HOME/.dotfiles" ] && [ ! -L "$HOME/.dotfiles" ]; then
  echo "$HOME/.dotfiles が既存のシンボリックリンクではないため、上書きせずに停止しました。" >&2
  exit 1
fi
ln -shf "$(pwd -P)" "$HOME/.dotfiles"
```

ユーザー名を変更する場合は、`nix/nix-darwin/users.nix` の `dotfiles.user.name` だけを変更する。

設定ファイルは checkout から out-of-store symlink で配置するため、設定の編集は switch を待たずに反映される。
Nix パッケージ、Homebrew、macOS defaults、配置するファイルの追加や削除を変更した場合は switch を実行する。

Git のユーザー情報は `config/git/config.local` に設定する。
ひな形は `config/git/config.local.example` を参照する。
このファイルもローカル専用で、Git にはコミットしない。

```bash
test -f config/git/config.local || cp config/git/config.local.example config/git/config.local
$EDITOR config/git/config.local
```

`config/git/config` は `~/.config/git/config.local` を include しているため、
switch 後は Home Manager がリンクした `~/.config/git/config.local` として読み込まれる。
`user.name`、`user.email`、`user.signingkey`、`ghq.root` を環境に合わせて設定する。
このリポジトリは 1Password の SSH 署名を使うため、コミット前に 1Password と SSH Agent も有効にしておく。

この設定は `mas` で Mac App Store アプリをインストールするため、switch 前に App Store にサインインしておく。

初回 switch を実行する。このコマンドは `just` がまだインストールされていなくても実行できる。

```bash
cd nix
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run github:LnL7/nix-darwin -- switch --flake "path:.#default"
```

初回 switch 後は Home Manager 経由で `just` が使える。

```bash
cd ~/src/dotfiles
just check
just build
just switch
just clean
```

`just switch`（`just s`）は、実行した checkout の物理パスへ `$HOME/.dotfiles` を更新してから適用する。
そのため、clone 先を ghq の規約に合わせる必要はなく、Git worktree からも switch できる。

### 適用後の作業

```bash
./script/set-fish-default.sh
```

ログアウトして再ログインするか、新しい Fish セッションを開始する。

```bash
fish
fisher update
```

switch 後、ユーザー認証が必要なサービスにサインインする。

- 1Password と 1Password CLI
- GitHub CLI が必要な場合: `gh auth login`
