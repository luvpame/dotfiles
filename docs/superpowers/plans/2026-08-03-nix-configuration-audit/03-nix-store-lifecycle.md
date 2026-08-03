# T03 Nix storeの保持とGC方針を統一する

- Status: 未着手
- Audit IDs: `CORE-05`, `CORE-07`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし

## Goal

手動cleanupだけに依存しているstore運用を、週次GCとdisk-pressure閾値を持つ宣言的な運用へ変える。

rollbackに必要な期間を残しながら、明確なoffline buildまたはdebug要件がない`keep-outputs`を外し、GCが回収できる範囲を広げる。
測定だけでは終えず、選んだ保持期間と閾値をNix設定と`just clean`へ反映する。

## Architecture

保持期間は30日を初期候補とする。
`nix.gc.automatic = true`と`nix.gc.options = "--delete-older-than 30d"`を設定し、nix-darwinの既定intervalを使って週次実行する。
実行時刻を変える運用上の理由がある場合だけ`nix.gc.interval`を追加する。

disk-pressure GCは、作業前にvolume容量、store使用量、空き容量の推移を測る。
初期候補は`min-free = 10 GiB`と`max-free = 20 GiB`とし、空き容量が小さいhostではvolumeの5%と10%を目安に下げる。
`max-free`は必ず`min-free`より大きくし、通常のbuildで頻繁に閾値を跨がない値を選ぶ。
全hostで同じ値が不適切ならhost registryのmetadataから値を渡す。

`keep-outputs`は削除する。
削除後にcache missやdebug用途で再buildが許容できないと実測で判明した場合だけ、根拠をcommentに残して戻す。

`just clean`は自動GCと同じ30日を基準にし、手動cleanup時だけ直近3世代を最低限残す。
自動と手動で4日対30日の異なるpolicyを持たせない。

## 対象ファイル

- `nix/nix-darwin/nix-core.nix`
- `justfile`
- この計画ファイル（測定値と最終選択を記録する場合）

## 未チェックの実施手順

- [ ] `git status --short`で作業開始時の差分を記録する。
- [ ] `df -h /nix/store`と`du -sh /nix/store`でvolumeの空き容量とstore使用量を測る。
- [ ] `nix-env --list-generations --profile /nix/var/nix/profiles/system`でsystem generationの数と最古日を確認する。
- [ ] 30日より古いgenerationへrollbackした実績またはoffline rebuild要件がないか、利用者の運用記録で確認する。
- [ ] 測定値から`min-free`と`max-free`を選び、選定値、単位、選定理由をこの計画の作業記録へ追記する。
- [ ] `nix.gc.automatic = true`と30日の削除optionを追加する。
- [ ] 選定した`min-free`と`max-free`を`nix.settings`へbyte単位の整数として追加する。
- [ ] `keep-outputs = true`を削除する。
- [ ] `just clean`の`--keep-since`を30日に揃え、直近3世代を保つ指定を維持する。
- [ ] `nix.optimise.automatic`には触れず、buildごとの`auto-optimise-store`を追加しない。
- [ ] GCを手動実行する前に`nix store gc`の候補を確認し、利用者の許可なしにgenerationやstore pathを削除しない。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
df -h /nix/store
du -sh /nix/store
nix-env --list-generations --profile /nix/var/nix/profiles/system
```

期待結果: retentionとfree-space閾値を選べる測定値が残り、機密情報や`nix/local.nix`の内容を記録していない。

```sh
nixfmt nix/nix-darwin/nix-core.nix
just check
just build
```

期待結果: GC optionとNix settingsを評価でき、darwin system buildが成功する。

switchを別途許可された場合だけ、適用後に次を確認する。

```sh
nix show-config | rg '^(keep-outputs|min-free|max-free) ='
launchctl print system/org.nixos.nix-gc
```

期待結果: `keep-outputs`が既定の無効値になり、選定した`min-free`と`max-free`が表示される。
週次GCのlaunchd jobが読み込まれている。

```sh
just --dry-run clean
git diff --check
```

期待結果: 手動cleanupが30日と3世代のpolicyを示し、whitespace errorがない。

## 完了条件

- 容量測定とrollback要件から保持期間とfree-space閾値を決め、その値が設定へ反映されている。
- 自動GCと`just clean`が30日を共通基準にしている。
- `keep-outputs`が削除されているか、維持が必要と判明した具体的な根拠が記録されている。
- 実際のGCによる削除を、この設定変更へ無断で含めていない。
- `just check`と`just build`が成功している。

## ロールバック

`nix.gc`と`min-free`、`max-free`の追加を戻し、`just clean`を直前の値へ戻す。
cache missによる再buildが許容できなければ`keep-outputs = true`を復元する。
すでにGCで削除されたstore pathやgenerationは設定差分だけでは復元できないため、このタスク内では許可なくGCを実行しない。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
