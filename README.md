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

```bash
git clone https://github.com/luvpame/dotfiles.git /Users/nasuno.ayumu/dev/github.com/luvpame/dotfiles
cd /Users/nasuno.ayumu/dev/github.com/luvpame/dotfiles
```

Nix 構成は、単一ユーザーと canonical checkout の場所に固定している。
ユーザー名、ホームディレクトリ、リポジトリのパスは `nix/flake.nix` に定義する。
そのため、別の場所へ clone した場合は `just check` と `just build` だけ実行でき、`just switch` は停止する。

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
cd /Users/nasuno.ayumu/dev/github.com/luvpame/dotfiles
just check
just build
just switch
just clean
```

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
