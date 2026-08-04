# T13: 未使用のsite2skillとPiqueを削除する

- Status: 未着手
- Audit IDs: PKG-03、PKG-05
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T01

## Goal

ユーザーが未使用と回答したsite2skillとPiqueをpackage setから外し、保守対象の独自derivationも削除する。

## Architecture

両packageは代替を追加せず、Home Managerのcommon package listから除去する。
package定義も削除する。
過去の設計判断を示すdocs/superpowers配下の既存文書は履歴として残し、実行構成とnix/AGENTS.mdだけを現状へ合わせる。

## 対象ファイル

- 変更: nix/inventory/software.nix
- 削除: nix/pkgs/site2skill/default.nix
- 削除: nix/pkgs/pique/default.nix
- 変更: nix/AGENTS.md

## 未チェックの実施手順

- [ ] 作業開始時にactiveなNix構成から両packageへの参照を再検索する。
- [ ] software inventoryのcommon `nixPackages`からsite2skillとPiqueのcallPackageを削除する。
- [ ] 両方のpackage定義を削除する。
- [ ] nix/AGENTS.mdのcustom package説明と例を、削除後の実態へ更新する。
- [ ] 過去のPique設計書や調査記録を削除していないことを確認する。
- [ ] 変更したNixファイルへnixfmtを実行する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] Hunkで削除対象がsite2skillとPiqueに限られていることを確認する。

## 検証コマンドと期待結果

~~~console
rg -n "site2skill|pkgs/pique|callPackage .*pique" nix
nixfmt --check nix/inventory/software.nix
just check
just build
~~~

最初のrgは該当なしとなり、Nixの検証はすべてexit 0になること。

適用を許可された場合はjust switch後に、site2skill commandとPique.appが新しいgenerationの管理対象から外れたことを確認する。

## 完了条件

- package listとnix/pkgsにsite2skillとPiqueが残っていない。
- 削除したpackageを前提にするactiveな設定がない。
- 過去の計画と調査記録は保持される。
- just checkとjust buildが成功する。

## ロールバック

削除した2つのpackage定義とsoftware inventoryの参照を、このタスクの開始時点の内容で戻す。
Pique.appが必要になった場合は前のdarwin generationへ戻してから再導入を判断する。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
