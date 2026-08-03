# T11: statixとRTKの古いtest overrideを外す

- Status: 未着手
- Audit IDs: TEMP-03（statixのみ）、PKG-02
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし。TEMP-03のdirenv部分はT26へ委譲する。

## Goal

固定中のnixpkgsで解消済みの回避設定を外し、statixとRTKを通常のderivationから取得する。
direnvとmiseの回避設定には触れない。

## Architecture

nixpkgs overlayからstatixだけを削除し、direnvとmiseのoverrideは残す。
Home Managerのpackage listではRTKのoverrideAttrsを外し、pkgs.rtkをそのまま使う。
これにより公式binary cacheへ戻り、cache miss時にはupstreamのcheckが実行される。

## 対象ファイル

- 変更: nix/nix-darwin/nix-core.nix
- 変更: nix/nix-darwin/home-manager/packages/common.nix

## 未チェックの実施手順

- [ ] 作業開始時のgit statusと対象2ファイルの差分を保存し、既存変更を特定する。
- [ ] statixのコメントとoverrideAttrsブロックだけをnix-core.nixから削除する。
- [ ] direnvとmiseのoverrideAttrsが残っていることを確認する。
- [ ] RTKの古いコメントとoverrideAttrsを削除し、package listをplain rtkへ変える。
- [ ] 変更したNixファイルへnixfmtを実行する。
- [ ] コード変更後にcode-simplifierスキルを適用し、挙動を変えない範囲で差分を整える。
- [ ] Hunkで差分を確認し、指定外のoverrideを変更していないことを確かめる。

## 検証コマンドと期待結果

~~~console
nixfmt --check nix/nix-darwin/nix-core.nix nix/nix-darwin/home-manager/packages/common.nix
just check
just build
~~~

すべてexit 0になること。
ビルド後の差分にstatixまたはRTKのdoCheck無効化がなく、direnvとmiseの回避設定は残ること。

適用を許可された場合だけ、次も確認する。

~~~console
just switch
statix --version
rtk --version
rtk rewrite "git status"
~~~

statixとRTKが起動し、RTKのrewriteがエラーにならないこと。

## 完了条件

- statixとRTKが通常のnixpkgs packageとして評価される。
- direnvの回避設定はT26まで維持される。
- miseの回避設定はT09で定めた方針どおり維持される。
- just checkとjust buildが成功する。

## ロールバック

このタスクの差分だけを逆向きに適用し、statixとRTKのoverrideを元へ戻す。
switch後に問題が出た場合は、前のdarwin generationへ戻してから原因となったpackageだけを再検証する。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
