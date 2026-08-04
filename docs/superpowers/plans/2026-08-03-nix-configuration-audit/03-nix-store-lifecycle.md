# T03 Nix storeの保持とGC方針を統一する

- Status: 実装済み（未適用）
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

## 作業記録

2026-08-04時点で、`/nix` volumeは926 GiB中38 GiBを使用し、445 GiBが空いていた。
`/nix/store`の使用量は38 GiBだった。

system profileには9世代が残っており、最古は2026-07-30、最新は2026-08-04だった。
現在残っている世代より長い30日を保持期間として採用する。

disk-pressure GCの閾値には、空き容量に対して十分小さく、通常のbuildで頻繁に跨がない10 GiBと20 GiBを採用する。
Nix設定には、それぞれ10737418240 bytesと21474836480 bytesを指定する。

棚卸しでは`CORE-05`と`CORE-07`の両方を実施すると回答済みで、repository内に30日より古いrollbackやoffline buildを必要とする運用記録はなかった。
`nixfmt --check`、`just check`、`just build`、`just --dry-run clean`は成功した。
実際のGCと`just switch`は実行していない。

## 未チェックの実施手順

- [x] `git status --short`で作業開始時の差分を記録する。
- [x] `df -h /nix/store`と`du -sh /nix/store`でvolumeの空き容量とstore使用量を測る。
- [x] system profileのsymlinkからsystem generationの数と最古日を確認する。
- [x] 30日より古いgenerationへrollbackした実績またはoffline rebuild要件がないか、利用者の運用記録で確認する。
- [x] 測定値から`min-free`と`max-free`を選び、選定値、単位、選定理由をこの計画の作業記録へ追記する。
- [x] `nix.gc.automatic = true`と30日の削除optionを追加する。
- [x] 選定した`min-free`と`max-free`を`nix.settings`へbyte単位の整数として追加する。
- [x] `keep-outputs = true`を削除する。
- [x] `just clean`の`--keep-since`を30日に揃え、直近3世代を保つ指定を維持する。
- [x] `nix.optimise.automatic`には触れず、buildごとの`auto-optimise-store`を追加しない。
- [x] 実際のGCを実行せず、generationやstore pathを削除しない。
- [x] 変更したコードへ`code-simplifier`スキルを適用する。
- [x] 変更したNixファイルを`nixfmt`で整形する。

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
