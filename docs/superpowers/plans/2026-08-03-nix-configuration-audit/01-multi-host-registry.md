# T01 マルチホスト構成を tracked host registry へ移行する

- Status: 未着手
- Audit IDs: `FLAKE-03`, `FLAKE-07`, `SYS-14`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし

## Goal

複数のMacで共有する非機密のホスト定義をGit管理し、ローカル設定には構成を選ぶために必要な最小限の値だけを残す。

同時に、`darwinSystem.system`を`nixpkgs.hostPlatform`へ移し、標準のhome directoryを使うホストでは冗長なuser定義を外す。

`nix/local.nix`はNix storeへコピーされ得るため、credentialやtokenの置き場所にはしない。
このタスクでは同ファイルの内容を開かず、値を計画、ログ、差分、コミットへ転記しない。

## Architecture

tracked host registryを`nix/hosts/`に置き、構成名をkeyとして`hostPlatform`と`profile`などの非機密metadataを定義する。
`nix/flake.nix`はregistryから`darwinConfigurations`を組み立て、各host moduleへ選択済みmetadataを`specialArgs`で渡す。

checkoutごとに変わるpathや、公開範囲を限定したいuser metadataまで追跡するかは、`nix/local.nix.example`に示されたschemaと利用者の申告だけで判定する。
実ファイルを調べて推測しない。
tracked registryへ載せない値が残る場合、`local.nix`は構成選択とhost-local pathだけを持つ薄いadapterとする。

`nixpkgs.hostPlatform`はhost moduleの値から設定する。
構成ごとのplatformがmodule graphに入るため、`nix-darwin.lib.darwinSystem`の互換用`system`引数は削除できる。

`users.nix`は全対象hostが`/Users/<userName>`を使うと利用者が確認した場合に限り削除する。
一台でも非標準homeを必要とするならmoduleを残し、重複する`name`属性だけを外す。

## 対象ファイル

- `nix/flake.nix`
- `nix/hosts/default.nix`（新規候補）
- `nix/hosts/<darwinConfigName>.nix`（必要な場合のみ新規作成）
- `nix/local.nix.example`
- `nix/nix-darwin/default.nix`
- `nix/nix-darwin/users.nix`
- `nix/nix-darwin/nix-core.nix`
- `nix/AGENTS.md`
- `justfile`

## 未チェックの実施手順

- [ ] 作業開始時に`git status --short`を記録し、`nix/nix-darwin/system.nix`の未コミットHot Corner差分をこのタスクの変更へ取り込まない。
- [ ] `nix/local.nix.example`とtracked Nix moduleだけを読み、現在moduleが参照するlocal schemaを一覧にする。
- [ ] 利用者に、対象host名、platform、profile、homeが標準形かどうか、追跡してよいmetadataの範囲を確認する。
- [ ] `nix/local.nix`の実体を開かず、内容を出力するcommandも実行しない。
- [ ] registryのkey、必須属性、許容するprofile、重複hostの検出方法を決める。
- [ ] registryへcredentialやtokenを置けないことをassertionと文書で明示する。
- [ ] `darwinConfigurations`をregistryから生成し、未知の構成名やprofileを評価時に拒否する。
- [ ] host metadataをmoduleへ渡し、module側で`nixpkgs.hostPlatform`を設定する。
- [ ] `darwinSystem { system = ...; }`を削除する。
- [ ] 全対象hostが標準homeを使うと確認できた場合だけ`users.nix`とそのimportを削除する。
- [ ] 非標準homeを許容する場合は`users.nix`を残し、冗長な`name = local.userName;`だけを削除する。
- [ ] `nix/local.nix.example`を最小schemaに合わせ、秘密情報を置かない注意書きを更新する。
- [ ] `nix/AGENTS.md`の「秘密情報を含む」という記述を「秘密情報を置かない」へ直す。
- [ ] `justfile`が新しい構成選択方法で`build`、`switch`、`check`を実行できるようにする。
- [ ] 変更したコードへ`code-simplifier`スキルを適用し、不要なadapterや重複validationを削る。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
nixfmt nix/flake.nix nix/hosts/default.nix nix/local.nix.example nix/nix-darwin/default.nix nix/nix-darwin/users.nix nix/nix-darwin/nix-core.nix
```

期待結果: 対象として残ったNixファイルが整形され、再実行しても差分が増えない。
削除したファイルや採用しなかった候補はcommandから外す。

```sh
just check
```

期待結果: registryに含まれる全構成を評価でき、未知のprofile、欠けた必須属性、platformの二重指定がない。

```sh
just build
```

期待結果: 現在選択されているhostのdarwin systemをbuildできる。
commandの出力に`nix/local.nix`の値を追加表示しない。

```sh
git diff --check
git status --short
```

期待結果: whitespace errorがなく、`nix/nix-darwin/system.nix`の既存Hot Corner差分が作業開始時から変化していない。

## 完了条件

- tracked registryだけを読めば、共有するhostとprofileの対応が分かる。
- `nixpkgs.hostPlatform`が各host moduleに設定され、`darwinSystem.system`が残っていない。
- `local.nix`に秘密情報を置かない方針がexampleとagent向け文書で一致している。
- 標準homeかどうかを確認できなかったhostについて、`users.nix`を推測で削除していない。
- `just check`と`just build`が成功している。

## ロールバック

registry生成を外し、`flake.nix`の単一構成生成と`darwinSystem.system`を直前の形へ戻す。
`users.nix`を削除していた場合はimportと一緒に戻す。
ローカル設定の実ファイルには触れないため、退避や復元は行わない。

## 作業規約

コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
