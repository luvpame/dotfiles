# T10 Flakeの検査とrevision metadataを整備する

- Status: 未着手
- Audit IDs: `FLAKE-04`, `FLAKE-05`, `FLAKE-06`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: `T01 マルチホスト構成を tracked host registry へ移行する`, `T09 Nixの既定重複と一時無効化を整理する`

## Goal

buildしたdarwin systemへGit revisionを記録し、`nix fmt`と`nix flake check`を品質gateとして使えるようにする。

同時に、formatterとchecksの追加で不要になるbindingを含め、`deadnix`と`statix`が報告する明確な未使用引数を削除する。

## Architecture

`system.configurationRevision`には`self.rev or self.dirtyRev or null`を設定する。
revisionの由来がflake自身だと分かるよう、`flake.nix`のmodule listに小さなinline moduleとして置き、既存の`system.nix`にある未コミットHot Corner差分へ触れない。

formatterは各対応platformへ`nixfmt-tree`を公開する。
checksには全tracked hostのdarwin system closure、format check、`deadnix`、`statix`を含める。
lint checkはrepository sourceを読み取り専用で検査し、formatやfileを書き換えないderivationにする。

T01のregistryからhostとplatformを得て、host名や`aarch64-darwin`を複数箇所へ重複記述しない。
checks追加後に使われる`self`と`nixpkgs`は残し、実際に未使用の`pkgs`、overlayの第一引数、Homebrewの`lib`、private packageの`inputs`だけを削る。

## 対象ファイル

- `nix/flake.nix`
- `nix/nix-darwin/nix-core.nix`
- `nix/nix-darwin/homebrew/common.nix`
- `nix/nix-darwin/home-manager/packages/private.nix`
- `nix/flake.lock`（input更新が必要な場合だけcommandで更新し、手動編集しない）
- `nix/nix-darwin/system.nix`（既存差分の保全確認だけ。編集しない）

## 未チェックの実施手順

- [ ] `git status --short`と`git diff -- nix/nix-darwin/system.nix`を記録し、Hot Corner差分を保全する。
- [ ] T01のregistryから対応platformと全darwin configurationを列挙できるhelperを再利用する。
- [ ] `system.configurationRevision = self.rev or self.dirtyRev or null`をinline moduleで全構成へ渡す。
- [ ] 各対応platformの`formatter`へ`nixfmt-tree`を公開する。
- [ ] 全tracked hostのsystem closureを`checks`へ公開する。
- [ ] repositoryを変更しないformat check、`deadnix` check、`statix` checkを追加する。
- [ ] check名がhost間で衝突せず、失敗時に対象が分かる名前へする。
- [ ] `deadnix`と`statix`を実行し、behaviorを変えない未使用bindingだけを削除する。
- [ ] `self`と`nixpkgs`がformatter、checks、revisionで使用されていることを確認する。
- [ ] style上の好みだけの`inherit`展開や属性set再配置を同じ差分へ混ぜない。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
cd nix
nix flake show path:.
nix fmt path:.
```

期待結果: `formatter`とhostごとの`checks`が表示され、`nix fmt`が成功する。
format後に意図しないfileが変わっていない。

```sh
cd nix
deadnix --fail .
statix check .
```

期待結果: 今回対象にした未使用bindingと静的lint errorが残っていない。

```sh
nixfmt nix/flake.nix nix/nix-darwin/nix-core.nix nix/nix-darwin/homebrew/common.nix nix/nix-darwin/home-manager/packages/private.nix
just check
just build
git diff --check
```

期待結果: format、lint、全host closureを含むflake checkと現在hostのdarwin buildが成功する。

switchを別途許可された場合だけ、生成systemのconfiguration revisionが現在のcleanまたはdirty revisionを示すことを確認する。

## 完了条件

- `nix flake show`にformatterと明示checksが現れる。
- `just check`がformat、`deadnix`、`statix`、全tracked hostのsystem closureを検査する。
- buildしたsystemへGit revisionが記録される。
- 明確な未使用bindingが削除され、styleだけの大規模整形を混ぜていない。
- `system.nix`の既存Hot Corner差分が作業開始時と同一である。
- `just check`と`just build`が成功している。

## ロールバック

formatter、checks、configuration revisionのoutputを一組として外す。
削除したmodule引数が後続変更で必要になっていた場合は、その引数だけを復元する。
`flake.lock`が変わった場合は、このタスクが更新したinput nodeだけを元のlockへ戻し、他者のlock変更を上書きしない。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
