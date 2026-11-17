## 遵守事項

- 応答は常に「日本語」で行ってください。

## ドキュメントと既存コードの不整合

リポジトリのドキュメントと既存のコードが食い違う場合は、既存のコードで使われている慣習に従い、見つけたドキュメントとコードの食い違いを最終返答ですべて挙げること。

## 書き分けの原則

コードには How
テストコードには What
コミットログには Why
コードコメントには Why not

## Git の部分ステージ

同じファイルに複数の変更が混在するときは `git-surgeon` スキルを読み、hunk・行単位でステージする。ファイル全体をステージする場合は `git add` を使う。

## pstack のモデル設定

pstack の役割別モデルは以下を使い、各スキルの既定値より優先する。各行は「モデル名 推論強度」の形で書く。モデルと推論強度を指定できる呼び出し（Workflow の `agent` など）では、モデル名を `model`、推論強度を `effort` に分けて渡す。指定できない呼び出しでは、モデル指定を省いて親セッションのモデルで実行し、その旨を伝える。`inherit-parent` または `auto` も同じ扱いとする。

```text
# defaults: 3
# budget: medium (high)
feature, refactoring: muse-wonder-1.0 high
bug-fix: muse-wonder-1.0 high
perf-issue: muse-wonder-1.0 high
hillclimb: muse-wonder-1.0 high
judgment and prose: muse-wonder-1.0 high
arena runners: muse-wonder-1.0 medium, muse-spark-1.3 medium
arena cross-judge pool: muse-wonder-1.0 medium, muse-spark-1.3 medium
swarm workers: muse-spark-1.3 medium
interrogate reviewers: muse-wonder-1.0 medium, muse-spark-1.3 medium
```
