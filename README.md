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
git clone https://github.com/luvpame/dotfiles.git <dotfiles_directory>
cd <dotfiles_directory>

test -f nix/local.nix || cp nix/local.nix.example nix/local.nix
$EDITOR nix/local.nix
```

`nix/local.nix` に以下を設定する。
このファイルはローカル専用で、Git にはコミットしない。

```nix
{
  darwinConfigName = "your-darwin-config-name";
  userName = "your-user-name";
  homeDirectory = "/Users/your-user-name";
  dotfilesRoot = "/Users/your-user-name/dev/github.com/your-account/dotfiles";
  profile = "private";
}
```

- `darwinConfigName`: nix-darwin の設定名。
- `userName`: macOS のユーザー名。
- `homeDirectory`: ユーザーのホームディレクトリの絶対パス。
- `dotfilesRoot`: このリポジトリの絶対パス。clone したパスと一致させる。
- `profile`: `work` または `private`。用途別のパッケージとリンクを切り替える。

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
DARWIN_CONFIG_NAME="$(nix eval --file local.nix darwinConfigName --raw)"
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run github:LnL7/nix-darwin -- switch --flake "path:.#$DARWIN_CONFIG_NAME"
```

初回 switch 後は Home Manager 経由で `just` が使える。

```bash
cd <dotfiles_directory>
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
