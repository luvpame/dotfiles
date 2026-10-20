## 遵守事項

- 応答は常に「日本語」で行ってください。

## 書き分けの原則

コードには How
テストコードには What
コミットログには Why
コードコメントには Why not

## Git の部分ステージ

同じファイルに複数の変更が混在するときは `git-surgeon` スキルを読み、hunk・行単位でステージする。ファイル全体をステージする場合は `git add` を使う。

## pstack モデル設定

pstack の役割別モデルと推論強度には、以下の設定を使う。

feature, refactoring: gpt-6.1-sol
bug-fix: gpt-6.1-sol
perf-issue: gpt-6.1-sol
hillclimb: gpt-6.1-sol
judgment and prose: gpt-6.1-sol
strongest judgment: gpt-6-astra
how explorer: gpt-6.1-sol
how explainer: gpt-6.1-sol
why investigators: gpt-6.1-sol
why synthesizer: gpt-6.1-sol
reflect tooling: gpt-6.1-sol
reflect judgment, divergent, synthesizer: gpt-6.1-sol
arena runners: gpt-6-astra, gpt-6.1-sol, gpt-6-luna
arena cross-judge pool: gpt-6-astra, gpt-6.1-sol, gpt-6-luna
swarm workers: gpt-6.1-sol
architect runners: gpt-6-astra, gpt-6.1-sol, gpt-6-luna
interrogate reviewers: gpt-6-astra, gpt-6.1-sol, gpt-6-luna

default effort: session
