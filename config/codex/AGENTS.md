## 遵守事項

- 応答は常に「日本語」で行ってください。

## 書き分けの原則

コードには How
テストコードには What
コミットログには Why
コードコメントには Why not

## Git の部分ステージ

同じファイルに複数の変更が混在するときは `git-surgeon` スキルを読み、hunk・行単位でステージする。ファイル全体をステージする場合は `git add` を使う。

## pstack のモデル設定

pstack の役割別モデルは以下を使い、各スキルの既定値より優先する。推論強度は予算行の値を全役割の初期値とし、モデル名を `model`、推論強度を `reasoning_effort` に分けて渡す。モデルを明示する `spawn_agent` 呼び出しは `fork_turns: "none"` とし、必要な文脈を `message` に渡す。

```text
# budget: medium (high)
feature, refactoring: gpt-6.1-sol
bug-fix: gpt-6.1-sol
perf-issue: gpt-6.1-sol
hillclimb: gpt-6.1-sol
judgment and prose: gpt-6-astra
hardest tasks: gpt-6-astra
how explorer: gpt-6.1-sol
how explainer: gpt-6-astra
why investigators: gpt-6.1-sol
why synthesizer: gpt-6-astra
reflect tooling: gpt-6.1-sol
reflect judgment, divergent, synthesizer: gpt-6-astra
arena runners: gpt-6-astra, gpt-6.1-sol
arena cross-judge pool: gpt-6-astra, gpt-6.1-sol
swarm workers: gpt-6.1-sol
architect runners: gpt-6-astra, gpt-6.1-sol
interrogate reviewers: gpt-6-astra, gpt-6.1-sol
```
