## 書き分けの原則

コードには How
テストコードには What
コミットログには Why
コードコメントには Why not

## Git の部分ステージ

同じファイルに複数の変更が混在するときは `git-surgeon` スキルを読み、hunk・行単位でステージする。ファイル全体をステージする場合は `git add` を使う。

## レビューコメント

Claude が GitHub にレビューコメントを投稿するときは、各コメントの1行目に次のバッジを付け、空行の後に本文を書く。インラインコメントとレビュー全体のサマリーの両方に適用する。本文の見出しや重要度など、既存のレビュー形式はバッジの後に保つ。

```markdown
![reviewed by Claude](https://img.shields.io/badge/reviewed_by-Claude-D97757?logo=claude&logoColor=white)
```

## Agent Memory Repo

セッションをまたいで残す記憶は agent-memory-repo スキルで `~/agent-memory` に保存する。auto memory は使わない。

- リポジトリ固有の記憶は `<リポジトリ名>/` 配下のファイルに置き、`MEMORY.md` の `## Index` からリンクする。`MEMORY.md` 本体には全セッションに要るものだけ書き、4KB 以内に保つ。
- 保存する: 好み、訂正とそこから得たルール、決定とその理由、ハマりどころ。保存しない: セッションの要約、タスクの状態（PR 番号・進捗）、すぐ調べ直せること、秘密情報。
- エントリには `added` を必ず付け、PR・Notion などの URL があれば `source` に入れる。

@~/agent-memory/MEMORY.md
@RTK.md
@pstack-models.md
