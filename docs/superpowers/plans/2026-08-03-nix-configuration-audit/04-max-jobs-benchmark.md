# T04 `max-jobs`を実測して決める

- Status: 未着手
- Audit IDs: `CORE-08`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: `T01 マルチホスト構成を tracked host registry へ移行する`

## Goal

固定値`max-jobs = 8`とNixの`auto`を同じhost、同じderivation集合で比較する。

測定結果から値を選び、理由のない固定値なら削除する。
固定値に実測上の利点がある場合は8を維持し、判断条件を設定commentへ残す。

## Architecture

`max-jobs`は同時にbuildするderivation数を制御し、単一derivation内の並列度を決める`cores`とは分けて評価する。
このタスクでは`cores`を変更しない。

benchmarkは同じsystem closureを対象に、8と`auto`を交互に3回ずつ実行する。
各runでwall time、最大resident set size、swap使用量の前後、memory pressure、操作中の体感停止を記録する。
binary cacheだけで完了したrunは並列buildの比較にならないため無効とし、`--rebuild`で複数derivationが実際にbuildされたrunを採用する。

既定判断は`auto`とする。
ただし、`auto`でswapが増える、memory pressure warningが出る、通常操作が継続できない、またはwall timeが改善しないのに最大RSSが8より20%以上増える場合は固定8を維持する。

測定後は必ず`nix/nix-darwin/nix-core.nix`へ結果を反映する。
`auto`を選んだ場合は属性を削除し、8を選んだ場合はhost条件と測定日をcommentに残す。

## 対象ファイル

- `nix/nix-darwin/nix-core.nix`
- この計画ファイル（benchmark結果を記録する）

## 未チェックの実施手順

- [ ] `git status --short`で作業開始時の差分を記録する。
- [ ] T01のtracked registryから対象の構成名を選び、`nix/local.nix`を開かずにbenchmark対象を確定する。
- [ ] AC電源、thermal状態、foreground application、Nix daemonのほかのjobを揃える。
- [ ] 比較対象のsystem closureを一度評価し、build対象に複数のderivationがあることを確認する。
- [ ] 8と`auto`を交互に3回ずつ`--rebuild`し、順序によるthermal biasを減らす。
- [ ] 各runのwall time、最大RSS、swap前後、memory pressure、失敗、操作性を表に記録する。
- [ ] cache取得だけで終わったrunと、別processの高負荷が重なったrunを無効として理由を残す。
- [ ] median wall timeと最大RSSを比較し、Architectureの判断基準で8または`auto`を選ぶ。
- [ ] `auto`を選んだ場合は`max-jobs = 8`を削除する。
- [ ] 8を選んだ場合は値を維持し、対象host、測定日、制約を簡潔なcommentにする。
- [ ] 選択後の設定でも代表buildをもう一度実行する。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## benchmark記録

| Run | `max-jobs` | Wall time | Max RSS | Swap delta | Memory pressure | 操作性 | 採否 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 8 | 未測定 | 未測定 | 未測定 | 未測定 | 未測定 | 未判定 |
| 2 | auto | 未測定 | 未測定 | 未測定 | 未測定 | 未測定 | 未判定 |
| 3 | auto | 未測定 | 未測定 | 未測定 | 未測定 | 未測定 | 未判定 |
| 4 | 8 | 未測定 | 未測定 | 未測定 | 未測定 | 未測定 | 未判定 |
| 5 | 8 | 未測定 | 未測定 | 未測定 | 未測定 | 未測定 | 未判定 |
| 6 | auto | 未測定 | 未測定 | 未測定 | 未測定 | 未測定 | 未判定 |

## 検証コマンドと期待結果

構成名はT01のtracked registryにある非機密の名前へ置き換える。

```sh
cd nix
/usr/bin/time -lp nix build --no-link --rebuild --max-jobs 8 '.#darwinConfigurations.<configuration>.system'
/usr/bin/time -lp nix build --no-link --rebuild --max-jobs auto '.#darwinConfigurations.<configuration>.system'
```

期待結果: 両条件で同じclosureをbuildでき、wall timeと最大RSSを採取できる。
この二つを交互に合計6回実行する。

```sh
memory_pressure
sysctl vm.swapusage
```

期待結果: 各run前後のmemory pressureとswap使用量を比較できる。

```sh
nixfmt nix/nix-darwin/nix-core.nix
just check
just build
```

期待結果: 選んだ設定でflake checkとdarwin buildが成功する。

switchを別途許可された場合だけ、適用後に次を確認する。

```sh
nix show-config | rg '^max-jobs ='
```

期待結果: `auto`を選んだ場合は`max-jobs = auto`、固定値を選んだ場合は`max-jobs = 8`と表示される。

## 完了条件

- 有効なrunが各条件3件あり、測定条件と除外runの理由が残っている。
- wall timeだけでなくmemory、swap、操作性も比較している。
- 選んだ結果がNix設定へ反映されている。
- 固定8を維持する場合は、なぜ`auto`を使わないかがcommentから分かる。
- `just check`と`just build`が成功している。

## ロールバック

選択後に通常運用で問題が出た場合は`max-jobs = 8`を復元する。
固定8でbuild時間が悪化した場合は属性を削除して`auto`へ戻す。
benchmarkはstore pathを削除しないため、設定差分以外のrollbackは不要である。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
