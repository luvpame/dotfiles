# T17: Nixのrelaxed sandboxを有効にする

- Status: 未着手
- Audit IDs: CORE-01
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T11、T12、T13、T15、T16、T18

## Goal

通常のderivationをsandbox内でbuildし、未宣言のhost fileやtoolへ依存しているbuildを検出できるようにする。

## Architecture

nix.settings.sandboxをrelaxedに設定する。
fixed-output derivationと__noChrootを要求するderivationには互換性を残し、strict trueへの移行は別判断とする。
このタスクはsandbox設定だけを変更し、GC、trusted user、substituterなどの設定と混ぜない。

## 対象ファイル

- 変更: nix/nix-darwin/nix-core.nix

## 未チェックの実施手順

- [ ] 変更前にjust buildを実行し、sandbox以外の失敗がないことを確認する。
- [ ] nix.settings.sandboxへrelaxedを追加する。
- [ ] 変更したNixファイルへnixfmtを実行する。
- [ ] just checkとjust buildで新しいsystem generationを生成する。
- [ ] 適用を許可された場合だけjust switchを実行する。
- [ ] daemonの実効値がrelaxedになったことを確認する。
- [ ] substituterを無効にした小さなderivationを一つbuildし、cache hitだけではなく実buildも通ることを確認する。
- [ ] 主要なcustom inputとHome Manager packageをsmoke testする。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] Hunkでsandbox以外のNix設定を変更していないことを確認する。

## 検証コマンドと期待結果

~~~console
nixfmt --check nix/nix-darwin/nix-core.nix
just check
just build
~~~

すべてexit 0になること。

適用を許可された場合だけ、次を実行する。

~~~console
just switch
nix config show sandbox
nix build --no-link --option substitute false --impure --expr 'let f = builtins.getFlake (toString ./nix); pkgs = f.inputs.nixpkgs.legacyPackages.aarch64-darwin; in pkgs.hello.overrideAttrs (_: { TASK_SANDBOX_PROBE = "1"; })'
~~~

sandboxの実効値がrelaxedになり、probe derivationがhost依存エラーなしでbuildできること。
Claude、Herdr、Hunk、Crit、mise、statixなど主要CLIも起動すること。

## 完了条件

- Nix daemonのsandbox実効値がrelaxedになる。
- 通常buildとsubstitute無効のprobe buildが成功する。
- strict sandboxは有効化していない。
- just checkとjust buildが成功する。

## ロールバック

sandbox設定を削除してjust buildを通し、just switchで以前のfalse相当へ戻す。
switchまたはbuildが成立しない場合は、前のdarwin generationへrollbackする。
ロールバック後にnix config show sandboxがfalseを示すことを確認する。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
