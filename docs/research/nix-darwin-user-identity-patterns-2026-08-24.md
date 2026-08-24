# nix-darwin と Home Manager のユーザー識別情報の管理パターン

調査日：2026-08-24

## 結論

公開されている設定を12件調べると、macOS のユーザー名を Nix が実行時に自動検出するより、flake またはホストプロファイルに一度だけ記述し、`specialArgs`、`users.users`、`home-manager.users` へ配る構成が多く見つかる。

`system.primaryUser` だけを読み取り、他の設定をすべて自動生成する構成は今回の対象には見つからなかった。

実際には、同じ値から `system.primaryUser` と `users.users.<name>.home` を設定し、nix-darwin に組み込んだ Home Manager の `home.username` と `home.homeDirectory` は公式モジュールの既定値に任せる構成が扱いやすい。

このリポジトリでは、次の分担が適している。

1. ユーザー名を一つの小さなホストプロファイルへ置く。
2. `users.users.<name>.home` を同じプロファイルから設定する。
3. `system.primaryUser` は現行 nix-darwin が要求する値として同じプロファイルから設定する。
4. nix-darwin 統合の Home Manager では `home.username` と `home.homeDirectory` を重複して書かない。
5. `mkOutOfStoreSymlink` の参照先は `${config.home.homeDirectory}/.dotfiles` から導く。

この形なら、ユーザー名とホームディレクトリを各モジュールへ渡す配線を減らしつつ、`.dotfiles` の安定したシンボリックリンクによる即時反映を残せる。

## 調査方法

公開リポジトリの default branch にある `flake.nix`、nix-darwin モジュール、Home Manager モジュールを一次資料として読み、次の項目を記録した。

- ユーザー名の定義場所と渡し方
- `system.primaryUser` と `users.users.<name>.home` の設定方法
- `home-manager.users.<name>` の構成方法
- `home.username` と `home.homeDirectory` の明示有無
- `builtins.getEnv` と `--impure` の利用有無
- ホストまたは個人プロファイルへの分離有無

対象は、公開状態を保ち、調査時点に default branch と設定ファイルを確認できるリポジトリから選んだ。
「現役」はこの条件で判定しており、公開されている nix-darwin 設定全体の母集団統計ではない。

公式実装も確認した。

- Home Manager の nix-darwin モジュールは、`home-manager.users` の各ユーザーを `launchctl asuser` と `sudo -u` で有効化する。
- Home Manager 共通モジュールは、統合先の `users.users.<name>.name` と `users.users.<name>.home` から `home.username` と `home.homeDirectory` を設定する。
- nix-darwin の `system.primaryUser` は、以前は `darwin-rebuild` を実行したユーザーへ適用されていた設定を移行するための項目で、将来は不要になり削除される予定の移行手段と説明されている。

## 比較表

分類は主たる構成に付けた。
複数の場所へ同じ値を重複して書く場合は、分類名の後ろに「重複」と記した。

| リポジトリ | ユーザー識別情報 | nix-darwin 側 | Home Manager 側 | 分類 |
| --- | --- | --- | --- | --- |
| [furedea/dotfiles](https://github.com/furedea/dotfiles/blob/main/flake.nix) | flake の `let` に `username = "kaito"`。`specialArgs` と `extraSpecialArgs` で配る。 | `system.primaryUser = username` と `users.users.${username}.home` を設定。 | `home.username` と `home.homeDirectory` を明示。 | 1、重複 |
| [yuucu/dotfiles](https://github.com/yuucu/dotfiles/blob/main/flake.nix) | `builtins.getEnv "DOTFILES_USER"` を読み、空なら固定値へ戻す。 | `system.primaryUser` と `users.users.<name>.home` を動的に設定。 | `home.username` と `home.homeDirectory` を明示。`--impure` で適用。 | 4 |
| [zupo/dotfiles](https://github.com/zupo/dotfiles/blob/main/flake.nix) | `home-manager.users.zupo` と各 Darwin モジュールに固定値を書く。 | `system.primaryUser = "zupo"`。 | `home.homeDirectory = lib.mkForce "/Users/zupo"` を明示。 | 1、重複 |
| [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles/blob/main/flake.nix) | flake の `let` に `username`、Darwin と Linux のホームを定義し、各モジュールへ渡す。 | `system.primaryUser = username` と `users.users.${username}.home = homedir`。 | 統合 Darwin では `home.*` を書かず、公式既定値に任せる。単独 Linux では明示。 | 1 |
| [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles/blob/main/flake.nix) | flake の `let` に `user = "kunchen"`。`specialArgs` と `extraSpecialArgs` で配る。 | `system.primaryUser = user` と `users.users.${user}.home`。 | `home.username` と `home.homeDirectory` を明示。 | 1、重複 |
| [tskovlund/nix-config](https://github.com/tskovlund/nix-config/blob/main/flake.nix) | `personal` flake input の `identity.username` を利用。ローカルの `local.nix` も任意で読み込む。 | `system.primaryUser` と `users.users.<name>.home` を `username` から設定。 | 統合 Darwin でも `home.username` と `home.homeDirectory` を明示。 | 3、5 |
| [filiptronicek/nix](https://github.com/filiptronicek/nix/blob/main/flake.nix) | flake 内の `vars` attrset に `username` と `homeDirectory` をまとめる。 | `users.users.${vars.username}.home` と `system.primaryUser` を設定。 | 統合 Home Manager では `home.*` を書かず、統合の既定値に任せる。 | 3 |
| [MacroPower/dotfiles](https://github.com/MacroPower/dotfiles/blob/master/lib/mkDarwin.nix) | `mkDarwin` の引数に `username`、`hostname`、`homeModule` をまとめる。 | 共通 Darwin モジュールが `system.primaryUser` と `users.users.<name>.home` を引数から設定。 | `home-manager.users.<name>` の `home.*` は明示しない。 | 3 |
| [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config/blob/main/flake.nix) | flake の `let` に `user = "dustin"`。`specialArgs` で各システムへ配る。 | `system.primaryUser` と `users.users.${user}` を設定するが、ホストモジュールにも同じ値が残る。 | `home.*` は明示せず、`users.users` と統合の既定値を使う。 | 1、重複 |
| [hardselius/dotfiles](https://github.com/hardselius/dotfiles/blob/main/flake.nix) | `primaryUserInfo` attrset に `username`、氏名、メール、鍵設定などをまとめる。 | 独自の `users.primaryUser` モジュールからユーザー情報を取り出し、`users.users.<name>.home` を設定。 | 統合構成は `users.users` から解決し、単独構成では `home.*` を明示。 | 3 |
| [carlthome/dotfiles](https://github.com/carlthome/dotfiles/blob/main/systems/mba/configuration.nix) | ホストごとに `system.primaryUser = "carl"` を置く。単独 Home Manager のホーム名は別の固定値。 | `system.primaryUser` をホスト構成に直接記述。 | `homes/carlthome/home.nix` で `home.username` と `home.homeDirectory` を明示。 | 3、構成分離 |
| [colonelpanic8/dotfiles](https://github.com/colonelpanic8/dotfiles/blob/master/nix-darwin/flake.nix) | `mkDarwinSystem` の引数 `primaryUser` と `enabledHomeUsers` でホスト構成を作る。 | `system.primaryUser` と `users.users` を同じ引数から生成。 | `home-manager.users` を有効ユーザー集合から生成し、`home.*` は統合の既定値を使う。 | 3 |

## パターン別の分析

### flake の `let` に固定値を置く

furedea、ryoppippi、kunchenguid、dustinlyonsは、flake の `let` でユーザー名を一度定義し、`specialArgs` または `extraSpecialArgs` でモジュールへ渡している。

この方式は読みやすく、pure evaluation のまま動く。
一方、`homeDirectory` や `repoRoot` まで同じ層に置くと、ユーザー識別情報とリポジトリ配置の詳細が flake の出力定義へ集まりやすい。

### `system.primaryUser` を唯一の正にする

今回の12件では、`config.system.primaryUser` だけを読み取り、ユーザー属性、Home Manager のユーザー名、ホームディレクトリをすべて導出する構成は確認できなかった。

近い実装は、MacroPower と colonelpanic8 の `mkDarwin` 関数である。
どちらも `primaryUser` をホスト生成関数の引数にしているが、同じ引数から `users.users` と Home Manager のユーザー集合も生成している。
これは `system.primaryUser` を参照元にしたというより、ホストプロファイルの入力を一つにまとめた構成である。

公式の `primary-user.nix` は `system.primaryUser` を移行手段と説明している。
そのため、長期的な独自 API としてこの option だけへ依存する設計は避け、ユーザー情報の元を別の小さなプロファイルへ置くほうが安全である。

### ホストまたはプロファイルの attrset にまとめる

filiptronicek は `vars`、hardselius は `primaryUserInfo`、tskovlund は `identity`、MacroPower と colonelpanic8 はホスト生成関数の引数を使っている。

この方式は、ユーザー名だけでなく、ホスト名、CPU アーキテクチャ、Homebrew の利用者、秘密情報の参照先を一つの境界に置ける。
複数台を同じ flake で管理するなら適している。

ただし、単一ユーザーの構成で属性を増やしすぎると、単なる `username` の置き換えに対して構造が重くなる。

### `builtins.getEnv` と `--impure`

yuucu は `DOTFILES_USER` を `builtins.getEnv` で読み、適用コマンドに `--impure` を付けている。
ユーザー名が機種ごとに異なる問題を実行時に解決できる一方、純粋評価では環境変数が空になるため、固定値へのフォールバックを用意している。

この構成では、`nix flake check` と実機で適用する構成が同じ入力を見ない。
そのため、単一ユーザーの dotfiles で採用する理由は弱い。

### ローカルまたは非公開の identity

tskovlund は `personal` を別の flake input とし、公開リポジトリには stub を置いている。
さらに `~/.config/nix-config/local.nix` が存在する場合だけ読み込む。

この方式なら、公開する設定から氏名、メールアドレス、秘密情報、端末固有の差分を分離できる。
ただし、ローカルファイルの存在確認には impure な評価が関係し、初回セットアップと CI の説明が増える。

### Home Manager のホーム情報を明示するか

Home Manager を nix-darwin の module として組み込む場合、公式の共通モジュールは次の値を設定する。

```nix
home.username = config.users.users.${name}.name;
home.homeDirectory = config.users.users.${name}.home;
```

したがって、`users.users.<name>.home` を宣言していれば、統合 Home Manager で同じ値をもう一度書く必要はない。

実際に、ryoppippi、filiptronicek、MacroPower、dustinlyons、hardselius、colonelpanic8 は統合 Darwin 側でこの既定値に任せている。

一方、`home-manager.lib.homeManagerConfiguration` で単独構成を作る場合は OS 側の `users.users` がないため、`home.username` と `home.homeDirectory` を明示する必要がある。

この違いを混同して両方へ同じ値を書くと、設定の重複だけが増える。

## このリポジトリへの推奨

現在の構成は、flake の `userName`、`homeDirectory`、`repoRoot` を `specialArgs` で全モジュールへ渡し、Home Manager 側でも `home.*` を明示している。

調査結果からは、次の順で整理するのがよい。

### ユーザー名の境界を一つにする

`nix/nix-darwin/users.nix` などに、単一ユーザーのプロファイルを置く。
そこではユーザー名を一度だけ記述し、`system.primaryUser` と `users.users.<name>.home` を同じ値から設定する。

概念的には次の形である。

```nix
{ ... }:
let
  primaryUser = "nasuno.ayumu";
  primaryHome = "/Users/${primaryUser}";
in
{
  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    name = primaryUser;
    home = primaryHome;
  };
}
```

`system.primaryUser` の将来変更に備える必要が生じた場合も、変更箇所はこの境界に限定できる。

### Home Manager の重複設定を消す

統合 Home Manager の `home-manager.users.<name>` では、`home.username` と `home.homeDirectory` を省略する。

Home Manager 側でユーザー名が必要な場合は、`config.home.username` を使う。
ユーザーのホームを必要とする場合は、`config.home.homeDirectory` を使う。

これにより、`files.nix` の参照先は次の形で書ける。

```nix
let
  dotfilesRoot = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/config/nvim";
}
```

`.dotfiles` は clone 先を指すシンボリックリンクなので、設定ファイルの編集はそのまま即時反映される。
Nix がリポジトリの実体を固定パスとして知る必要もなくなる。

### `getEnv` は採用しない

機種ごとにユーザー名が違う場合でも、まずは新しい Mac のログインユーザー名をプロファイルの一か所へ記述するほうがよい。
`builtins.getEnv` と `--impure` は、純粋な評価、CI、再現可能な build の境界を曖昧にする。

複数ユーザーへ公開するテンプレートを作る段階になったら、tskovlund のように identity をローカル flake input または非追跡ファイルへ分離する方法を検討できる。

## 一次資料一覧

### 公式実装

- [Home Manager の nix-darwin module](https://github.com/nix-community/home-manager/blob/master/nix-darwin/default.nix)
- [Home Manager 共通 module](https://github.com/nix-community/home-manager/blob/master/nixos/common.nix)
- [nix-darwin の `system.primaryUser` 定義](https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/primary-user.nix)
- [nix-darwin の primary user 検証](https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/checks.nix)

### 公開設定

- [furedea/dotfiles の flake.nix](https://github.com/furedea/dotfiles/blob/main/flake.nix)
- [furedea/dotfiles の Darwin module](https://github.com/furedea/dotfiles/blob/main/nix/darwin/default.nix)
- [furedea/dotfiles の Home Manager module](https://github.com/furedea/dotfiles/blob/main/nix/home/default.nix)
- [yuucu/dotfiles の flake.nix](https://github.com/yuucu/dotfiles/blob/main/flake.nix)
- [yuucu/dotfiles の Darwin module](https://github.com/yuucu/dotfiles/blob/main/darwin/default.nix)
- [yuucu/dotfiles の Home Manager module](https://github.com/yuucu/dotfiles/blob/main/home/default.nix)
- [zupo/dotfiles の flake.nix](https://github.com/zupo/dotfiles/blob/main/flake.nix)
- [zupo/dotfiles の Darwin host module](https://github.com/zupo/dotfiles/blob/main/darwin/zbook.nix)
- [zupo/dotfiles の Home Manager module](https://github.com/zupo/dotfiles/blob/main/darwin/home.nix)
- [ryoppippi/dotfiles の flake.nix](https://github.com/ryoppippi/dotfiles/blob/main/flake.nix)
- [ryoppippi/dotfiles の Darwin system module](https://github.com/ryoppippi/dotfiles/blob/main/nix/modules/darwin/system.nix)
- [ryoppippi/dotfiles の Home module](https://github.com/ryoppippi/dotfiles/blob/main/nix/modules/home/default.nix)
- [kunchenguid/dotfiles の flake.nix](https://github.com/kunchenguid/dotfiles/blob/main/flake.nix)
- [kunchenguid/dotfiles の Darwin module](https://github.com/kunchenguid/dotfiles/blob/main/configuration.nix)
- [kunchenguid/dotfiles の Home Manager module](https://github.com/kunchenguid/dotfiles/blob/main/home.nix)
- [tskovlund/nix-config の flake.nix](https://github.com/tskovlund/nix-config/blob/main/flake.nix)
- [filiptronicek/nix の flake.nix](https://github.com/filiptronicek/nix/blob/main/flake.nix)
- [MacroPower/dotfiles の Darwin 生成関数](https://github.com/MacroPower/dotfiles/blob/master/lib/mkDarwin.nix)
- [MacroPower/dotfiles の Darwin module](https://github.com/MacroPower/dotfiles/blob/master/hosts/darwin/default.nix)
- [dustinlyons/nixos-config の flake.nix](https://github.com/dustinlyons/nixos-config/blob/main/flake.nix)
- [dustinlyons/nixos-config の Darwin host module](https://github.com/dustinlyons/nixos-config/blob/main/hosts/darwin/default.nix)
- [dustinlyons/nixos-config の Darwin Home Manager module](https://github.com/dustinlyons/nixos-config/blob/main/modules/darwin/home-manager.nix)
- [hardselius/dotfiles の flake.nix](https://github.com/hardselius/dotfiles/blob/main/flake.nix)
- [hardselius/dotfiles のユーザー option](https://github.com/hardselius/dotfiles/blob/main/modules/users.nix)
- [carlthome/dotfiles の Darwin host](https://github.com/carlthome/dotfiles/blob/main/systems/mba/configuration.nix)
- [carlthome/dotfiles の Home Manager 設定](https://github.com/carlthome/dotfiles/blob/main/homes/carlthome/home.nix)
- [colonelpanic8/dotfiles の Darwin flake](https://github.com/colonelpanic8/dotfiles/blob/master/nix-darwin/flake.nix)
- [colonelpanic8/dotfiles の Darwin Home Manager module](https://github.com/colonelpanic8/dotfiles/blob/master/nix-darwin/home/common.nix)
