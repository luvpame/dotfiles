## 書き分けの原則

コードには How
テストコードには What
コミットログには Why
コードコメントには Why not

## Agent Memory Repo

セッションをまたいで残す記憶は agent-memory-repo スキルで `~/agent-memory` に保存する。auto memory は使わない。

- リポジトリ固有の記憶は `<リポジトリ名>/` 配下のファイルに置き、`MEMORY.md` の `## Index` からリンクする。`MEMORY.md` 本体には全セッションに要るものだけ書き、4KB 以内に保つ。
- 保存する: 好み、訂正とそこから得たルール、決定とその理由、ハマりどころ。保存しない: セッションの要約、タスクの状態（PR 番号・進捗）、すぐ調べ直せること、秘密情報。
- エントリには `added` を必ず付け、PR・Notion などの URL があれば `source` に入れる。

@~/agent-memory/MEMORY.md
@RTK.md
