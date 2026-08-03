# T26 direnvとnix-direnvをmoduleへ移管する

- **Status**: 未着手
- **Audit IDs**: `SHELL-02`, `TEMP-03`（direnv）
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T11（statixとRTKのstale test override撤去）

## Goal

direnv本体、nix-direnv、shell hook、`direnvrc`をnix-darwinの`programs.direnv`へまとめる。
direnvのtestを無効化している一時overrideも外す。

## Architecture

system設定で`programs.direnv.enable = true`と`programs.direnv.nix-direnv.enable = true`を宣言する。
nix-darwin moduleがpackage、Bash、Fish、Zsh hook、nix-direnvの`direnvrc`を所有する。

Home Managerのpackage一覧から`direnv`と`nix-direnv`を外す。
Home Managerが生成している`direnv/direnvrc`と、手書きのFish hookも同じ変更で削除する。
どれか一つだけを残すとhookが二重になるため、所有権は一度に切り替える。

## 対象ファイル

- Modify: `nix/nix-darwin/system.nix`
- Modify: `nix/nix-darwin/nix-core.nix`
- Modify: `nix/nix-darwin/home-manager/packages/common.nix`
- Modify: `nix/nix-darwin/home-manager/files/common.nix`
- Delete: `config/fish/conf.d/direnv.fish`

## 実施手順

- [ ] T11が完了し、残っているoverrideのうちdirenvだけがこのタスクの対象であることを確認する。
- [ ] FishとZshで`command -v direnv`、`direnv version`、現在のhook定義を記録する。
- [ ] `programs.direnv.enable = true`と`programs.direnv.nix-direnv.enable = true`をsystem設定へ追加する。
- [ ] Home Managerのpackage一覧から`direnv`と`nix-direnv`を削除する。
- [ ] Home Managerの`direnv/direnvrc`生成を削除する。
- [ ] `config/fish/conf.d/direnv.fish`を削除する。
- [ ] `nix-core.nix`からdirenvの`doCheck = false` overrideだけを削除し、miseなど別の一時overrideには触れない。
- [ ] コード変更に`code-simplifier`を適用し、direnvの所有元がnix-darwin moduleだけになったことを確認する。
- [ ] Nixの静的検証とbuildを完了し、direnvのtestを有効にしたpackageがbuildできることを確認する。
- [ ] ユーザーが適用を明示した場合だけ`just switch`を実行する。
- [ ] 新しいFishとZshを起動し、hookが一度だけ読み込まれることを確認する。
- [ ] 一時directoryの許可済み`.envrc`で環境変数の設定と解除を確認する。

## 検証コマンドと期待結果

```bash
nixfmt --check \
  nix/nix-darwin/system.nix \
  nix/nix-darwin/nix-core.nix \
  nix/nix-darwin/home-manager/packages/common.nix \
  nix/nix-darwin/home-manager/files/common.nix
just check
just build
```

期待結果は、direnvのtestを無効にせず、すべて終了コード0で完了することである。

```bash
rg -n "direnv|nix-direnv" \
  nix/nix-darwin/nix-core.nix \
  nix/nix-darwin/system.nix \
  nix/nix-darwin/home-manager \
  config/fish
```

期待結果は、nix-darwin moduleの宣言だけが所有元として残り、`doCheck = false`、直接package、生成`direnvrc`、手書きFish hookが見つからないことである。

適用を明示された後だけ、次を実行する。

```bash
just switch
fish --login -c 'type -q direnv; and direnv version'
zsh -lic 'command -v direnv && direnv version'
```

期待結果は、両shellが同じNix管理のdirenvを見つけ、versionを表示することである。

一時directoryで次の動作を確認する。

```bash
direnv allow
direnv status
```

期待結果は、許可した`.envrc`が読み込まれ、directoryを離れると環境変更が解除されることである。

```bash
git diff --check
```

期待結果は、出力なしで終了コードが0になることである。

## 完了条件

- direnvとnix-direnvをnix-darwin moduleだけが管理している。
- direnvのtest overrideがなく、packageを正常にbuildできる。
- FishとZshにhookが入り、二重実行されない。
- 許可済み`.envrc`の設定と解除が正常に動く。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

nix-darwin moduleを無効化し、Home Managerの二package、`direnvrc`、Fish hookを移行前の状態へ戻す。
必要な場合だけdirenvの一時overrideも復元し、理由と解除条件をコメントへ残す。
`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後に`just switch`を行う。

## 実装時の制約

- moduleと手書きhookを部分的に併用しない。
- `nix/nix-darwin/system.nix`の既存Hot Corner差分を保全する。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
