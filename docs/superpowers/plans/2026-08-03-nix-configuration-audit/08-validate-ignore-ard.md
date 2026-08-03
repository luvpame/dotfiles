# T08 `ignoreArd`の効力を実機で検証する

- Status: 未着手
- Audit IDs: `SYS-05`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし

## Goal

現在の`com.apple.security.authorization`と`ignoreArd`の宣言が、画面共有または画面録画中のTouch ID sudoへ実際に効くかを確認する。

回答は「確認後に維持」である。
期待どおり効く場合は確認記録を残して設定を維持する。
効かない場合は表記や実装方式を勝手に直さず、その時点で停止する。

## Architecture

設定値の存在確認だけでは機能を証明できないため、Touch ID sudoの動作を主判定にする。
画面を監視していない状態と、macOS Screen Recording、Screen Sharing、DisplayLinkなど実際に使う状態を分け、`sudo -k`後の認証方法を人が確認する。

`defaults read`は補助資料として、現在のdomain/keyとNISTがdirect defaults向けに示す`com.apple.Authorization`と`ignoreARD`の両方を読む。
値が見えなくても機能試験が通れば維持し、機能試験が落ちた場合は修正候補の調査を別タスクにする。

このタスクでは`nix/nix-darwin/system.nix`を編集しない。
同ファイルにある未コミットHot Corner差分を保全し、差分の作成者や意図を変更しない。

## 対象ファイル

- `nix/nix-darwin/system.nix`（読み取りと差分保全のみ）
- この計画ファイル（機能試験の結果を記録する）

## 未チェックの実施手順

- [ ] `git diff -- nix/nix-darwin/system.nix`を保存し、既存Hot Corner差分のhunkとhashを記録する。
- [ ] 現在のdarwin generationに対象設定が含まれることを、tracked設定とgeneration metadataから確認する。
- [ ] 画面共有や録画を停止した状態で`sudo -k`後のTouch ID sudoを確認する。
- [ ] 実際に使うScreen Recording、Screen Sharing、DisplayLinkの各状態を一つずつ有効にする。
- [ ] 各状態で`sudo -k`してから`sudo -v`を実行し、Touch ID promptの有無と成功可否を人が記録する。
- [ ] system domainとdirect-defaults候補domainの値をread-onlyで確認する。
- [ ] すべての必要な状態でTouch ID sudoが使えた場合、現在の設定を変更せず「確認後に維持」と記録する。
- [ ] 一つでも必要な状態で使えなかった場合、設定ファイルを編集せず停止する。
- [ ] 無効時は観測結果、macOS version、使用した共有または録画方式だけを後続タスクへ渡し、別domain/keyやconfiguration profileを適用しない。
- [ ] 終了時に`system.nix`のdiffを開始時と比較する。

## 機能試験記録

| 状態 | Touch ID prompt | 認証成功 | 判定 |
| --- | --- | --- | --- |
| 画面監視なし | 未確認 | 未確認 | 未判定 |
| Screen Recording | 未確認 | 未確認 | 未判定 |
| Screen Sharing | 未確認 | 未確認 | 未判定 |
| DisplayLink | 未確認 | 未確認 | 未判定 |

使わない方式は「対象外」と記録する。

## 検証コマンドと期待結果

```sh
sudo -k
sudo -v
```

期待結果: 画面監視なしではTouch ID sudoが成功する。
必要な共有または録画状態でも成功する場合だけ、現在の`ignoreArd`を有効と判定する。

```sh
sudo defaults read /Library/Preferences/com.apple.security.authorization ignoreArd
sudo defaults read /Library/Preferences/com.apple.Authorization ignoreARD
```

期待結果: 値の有無を補助資料として記録できる。
どちらも読めない場合でも、推測でwriteしない。

```sh
git diff -- nix/nix-darwin/system.nix
git status --short
```

期待結果: `system.nix`のHot Corner差分が作業開始時と同一で、このタスクによるコード差分がない。

## 完了条件

- 利用する画面共有または録画方式で機能試験を実施している。
- 有効なら現在の宣言を変更せず、試験条件と結果を記録している。
- 無効なら修正を加えず停止し、後続判断に必要な観測結果だけを残している。
- 既存のHot Corner差分が完全に保全されている。

## ロールバック

read-only検証のため設定rollbackはない。
認証cacheを残さないよう、試験後に`sudo -k`を実行する。
誤って`system.nix`を編集した場合は、自分が追加したhunkだけを取り除き、既存Hot Corner差分を戻さない。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
このタスクでコードを編集してはならない。
後続タスクでコードを変更する場合は`code-simplifier`スキルを適用し、Nix変更を`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
