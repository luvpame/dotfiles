# T20: 画面ロック後のpassword要求を即時にする

- Status: 未着手
- Audit IDs: SYS-04
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし。T19を実施する場合も別のswitchで適用する。

## Goal

display sleepまたはscreen saverへ移行した直後から、復帰時のpasswordまたは生体認証を必須にする。

## Architecture

system.defaults.screensaver.askForPasswordをtrue、askForPasswordDelayを0として宣言する。
Hot Corner自体の割り当ては変更しない。
Firewallなどほかのsystem設定を同じ適用へ混ぜず、再認証の挙動だけを独立して確認する。

nix/nix-darwin/system.nixにある未コミットのHot Corner差分はユーザー所有である。
このタスクではそのhunkを編集、復元、stageしない。

## 対象ファイル

- 変更: nix/nix-darwin/system.nix

## 未チェックの実施手順

- [ ] 現在のaskForPasswordとaskForPasswordDelayを読み取り、ロールバック用に値と未設定状態を記録する。
- [ ] system.nixの既存差分を保存し、Hot Corner hunkを識別する。
- [ ] screensaver設定へaskForPassword = trueとaskForPasswordDelay = 0を追加する。
- [ ] Hot Cornerの値とコメントを変更しない。
- [ ] system.nixへnixfmtを実行する。
- [ ] just checkとjust buildを実行する。
- [ ] 適用を許可された場合だけ、T20単独の変更としてjust switchする。
- [ ] 手動lock、screen saver、display sleepから復帰し、即時再認証を確認する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] Hunkでscreensaver hunkと既存Hot Corner hunkが分かれていることを確認する。

## 検証コマンドと期待結果

~~~console
nixfmt --check nix/nix-darwin/system.nix
just check
just build
~~~

すべてexit 0になり、Hot Cornerの既存差分がそのまま残ること。

適用を許可された場合だけ、次も確認する。

~~~console
just switch
defaults read com.apple.screensaver askForPassword
defaults read com.apple.screensaver askForPasswordDelay
~~~

askForPasswordが1、askForPasswordDelayが0になること。
Control-Command-Qによる手動lockとdisplay sleepのどちらでも、復帰直後にpasswordまたはTouch IDを要求すること。

## 完了条件

- password要求が有効で、delayが0になる。
- 手動lockとdisplay sleepからの復帰を実機確認する。
- Hot Cornerの既存差分を変更していない。
- T19を実施する場合も別の適用単位になっている。
- just checkとjust buildが成功する。

## ロールバック

着手前に記録したaskForPasswordとdelayへ一時的な宣言またはSystem Settingsで戻し、その反映を確認してから追加した宣言を外す。
optionを削除するだけでは既存defaults値が残る可能性があるため、基準値の復元を省略しない。
緊急時は前のdarwin generationへ戻すが、defaultsの実効値も別途確認する。
Hot Corner hunkはロールバック対象に含めない。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
