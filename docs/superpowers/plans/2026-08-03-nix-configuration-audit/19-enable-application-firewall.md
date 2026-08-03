# T19: Application Firewallを有効にする

- Status: 未着手
- Audit IDs: SYS-03
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし。T20を実施する場合も別のswitchで適用して検証する。

## Goal

macOS Application Firewallを宣言的に有効化し、LANと開発用途を維持したまま不要な着信を制御する。

## Architecture

networking.applicationFirewall.enableをtrue、blockAllIncomingをfalseにする。
signed softwareの既定許可は維持し、stealth modeはこのタスクでは有効化しない。
Firewall以外のsystem defaultは変更しない。

nix/nix-darwin/system.nixには、左上Hot Cornerを画面ロックへ変える既存の未コミット差分がある。
そのhunkはユーザー所有として保全し、このタスクの変更やstageへ混ぜない。

## 対象ファイル

- 変更: nix/nix-darwin/system.nix

## 未チェックの実施手順

- [ ] system.nixの既存差分を保存し、Hot Corner hunkを識別する。
- [ ] 変更前のFirewall実効値と許可済みapplicationを記録する。
- [ ] Application FirewallのenableとblockAllIncomingだけを追加する。
- [ ] stealth modeや全着信拒否を追加しない。
- [ ] system.nixへnixfmtを実行する。
- [ ] just checkとjust buildを実行する。
- [ ] 適用を許可された場合だけ、T19単独の変更としてjust switchする。
- [ ] Firewallの実効値、LAN、開発server、container、画面共有を確認する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] HunkでHot Corner hunkが変更されず、Firewall hunkと分離していることを確認する。

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
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall
/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode
~~~

global stateはenabled、block allはdisabled、stealth modeはdisabledになること。
別のLAN端末から許可した開発serverへ接続でき、OrbStackなどの公開port、Screen Sharing、AirDropに想定外の遮断がないこと。

## 完了条件

- Application Firewallが有効になる。
- blockAllIncomingとstealth modeは無効のままである。
- LAN、開発server、container、共有機能の確認結果が記録される。
- Hot Cornerの既存差分を変更していない。
- just checkとjust buildが成功する。

## ロールバック

Firewall optionをfalseへ戻してjust buildとjust switchを行い、global stateがdisabledになることを確認する。
適用に失敗した場合は前のdarwin generationへ戻す。
Hot Corner hunkはロールバック対象に含めない。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
