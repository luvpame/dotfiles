---
name: pr-review-assist
description: PRの変更を依存層順のStepに分け、crit で差分を確認しながら、全Step終了後にまとめてGraphQLでコメントを投稿する。
argument-hint: "[PR番号 または PR URL（省略時は現在ブランチのPR）]"
disable-model-invocation: true
---

# pr-review-assist

## 1. 入力収集

引数 `{n}`（PR番号 or URL）があればそれを対象にする。無ければ現在ブランチの PR を対象にする。

1. `gh pr view [{n}] --json number,title,body,headRefName,baseRefName,baseRefOid,headRefOid,additions,deletions,changedFiles,files` を実行する。
2. `git fetch origin {headRefName}` に続けて `git log --oneline {baseRefOid}..origin/{headRefName}` を実行する（1 の結果を使う）。

`gh pr view` が失敗する（PR がまだ無い）場合は、PR を作成してから再実行するよう伝えて終了する。

ファイル一覧は `files[*].path` で得る。差分本文は `gh pr diff {n}` で読む（層への分類にもサマリにも使う）。base は必ず `baseRefOid` の SHA を使う（`origin/{baseRefName}` はスタック PR で差分が膨張するため使わない）。`headRefOid` は §6 の投稿でコミットを固定するために使うので控えておく。

完了条件: `gh pr view` の JSON（`headRefOid` を含む）、`git log` の出力、`gh pr diff` の出力を取得済みである。

## 2. 作業ツリーの準備

crit のファイル絞り込みは、PR ブランチを checkout した状態で `crit --base-branch {baseRefOid} <files...>` を実行したときだけ効く（`crit --range` や `crit --pr` にファイルを渡すと全ファイルが表示される。実測済み）。

`git rev-parse --abbrev-ref HEAD` が `headRefName` に一致し、かつ `git rev-parse HEAD` が `headRefOid` に一致することを確認する。どちらか一方でも不一致なら、`gh pr checkout {n}` で同期してから再実行するよう伝えて終了する（スキル側で checkout はしない）。投稿を全 Step 終了後の1回にまとめているため、レビュー中に head が動くと行番号が解決できず投稿全体が失敗する。開始時点での完全一致をここで確定させる。

完了条件: 現在ブランチが `headRefName` に一致し、`git rev-parse HEAD` が `headRefOid` に一致している。

## 3. Step の構成

ファイルを依存層に分類する。

| 層 | 含むもの |
|---|---|
| 1. 計画 / 設計 | `docs/`, `plans/`, `*.md`, `openapi/` |
| 2. 純粋ロジック | hooks, utils, models, pure services, server actions |
| 3. 純粋ビジュアル | presentational components, `*.module.css`, stories |
| 4. 配置・状態制御 | containers, orchestrators, providers, stateful components |
| 5. 呼び出し側 | pages, route handlers, feature integrations |
| 6. 末尾の調整コミット | fix/style/refactor の小コミット、`*/generated/` や `*-schema.d.ts` などの自動生成物 |

`spec/` や `*.test.*` は対象実装ファイルと同じ Step に含める。複数ファイルへの同型変更は「1つ精読 + 残り{N-1}つは差分同型確認」として1件に数える。

層1〜5がそれぞれ Step になる。層内のファイル数（同型変更を1件に数えた後）が10を超える層は、機能ディレクトリ単位（`frontend/apps/{app}/src/features/{Feature}`、`backend/app/{type}/{namespace}` など）で Sub-step に分割する。3件未満の Sub-step は隣の Sub-step へ寄せる。空の層は飛ばす。

層6は crit を開かない。ターミナルで案内するだけにする: 生成物は生成元の変更と対応しているか、調整コミットは直前 Step の差分に含まれているかの2点。

完了条件: Step 一覧表（Step | 対象 | 目的）が確定している。

## 4. サマリ Artifact（Step 1 の前に1回）

Skill ツールで `eli33`（題材: この PR が何をするか、前提知識なし向け）と `show-me`（変更の構造図: ファイルツリーか依存図）を呼び、その出力と Step 一覧表を1つの HTML にまとめてスクラッチパッドディレクトリ（セッションのシステムプロンプト記載のパス）に書き、`open` で開く。claude.ai への publish はしない。

完了条件: HTML が開かれ、ターミナルにも Step 一覧表（`Step | 対象 | 目的`）が出ている。

## 5. Step の進行（Step ごとに繰り返す）

1. `crit --base-branch {baseRefOid} <その Step のファイル...>` を Bash の `run_in_background: true` で起動する。起動行 `Started crit daemon at http://localhost:<port> (session <id>, PID ...)` から URL とセッション id を控える。
2. 起動を確認したら、次のテンプレート通りにターミナル出力する（項目の省略・順序変更・追加をしない）。同型変更があれば「対象」の内訳に注記する。

   ```
   Step {k} の crit セッションを起動しました。ブラウザで開いてレビューしてください。

   crit URL: {url} ( session {id} )
   対象: {層名} {Nファイル}（{内訳}）
   目的: {1文}

   Finish Review を押したら自動で検知して次に進みます。
   ```

   ユーザーに入力は求めず、Finish Review が押されるまで待つ。
3. 終了後、stderr の `approved: true|false` を Step の記録として控える。
4. `crit comments --session <id> --json` の出力を、コメントの有無にかかわらずスクラッチパッドへ `step-{k}-comments.json` として書き出す。**これは次の `crit stop` より必ず先に行う**: `--session` は stop 後には使えなくなり、`--session` を省略した呼び出しはセッションキーが `cwd + 現在のブランチ` のハッシュになるため、ブランチが変わっていると静かに空配列を返す。
5. `crit stop <そのStepで起動したファイル引数...>`（2 で起動したときと同じファイル引数）を実行する。同じディレクトリ・ブランチで次の `crit` を打つと前のセッションへ再接続されるため必須（実測済み）。`crit stop` に `--session <id>` は無く、ファイル引数でしか対象セッションを指定できない（実測済み）。
6. 次の Step へ進む。

Step ごとに記録する: セッション id、approved、書き出した JSON のパス、コメント件数。

完了条件: その Step の JSON ファイルがスクラッチパッドに書き出され、crit セッションが停止している。

## 6. 投稿（全 Step 終了後に1回）

1. §5 で書き出した全 JSON ファイルを集める。
2. `~/.claude/skills/pr-review-assist/post-review.sh --pr {n} --commit {headRefOid} --dry-run <集めたJSONファイル...>` を実行し、出力（LINE/FILE/review-level の件数とスキップ数、各コメントの内容）をそのままユーザーに見せる。写像規則（crit の JSON フィールドから GraphQL の各フィールドへの変換）は `post-review.sh` 内の実装を正とする。
3. AskUserQuestion で「投稿する／投稿しない」を聞く。
   - 投稿する: 同じ引数から `--dry-run` を外して実行する。
   - 投稿しない: §5 の JSON パス一覧を伝えて §8 へ進む。
4. スクリプトが非ゼロ終了した場合、stderr に出る pending レビューの `id` と破棄用コマンドをそのままユーザーに伝える（スクリプトは pending レビューを自動破棄しない。投稿を続けるか破棄するかはユーザーが選ぶ）。

完了条件: `--dry-run` の内容をユーザーに見せたうえで投稿する/しないの回答を得て、選んだ通りに実行し終えている。

## 7. 中断

ユーザーが途中でレビューを中断するよう指示したときにこの節を使う。残りの Step 一覧と、§5 で書き出し済みのコメント件数（Step ごとの内訳）を出す。AskUserQuestion で「ここまでの分を投稿する／投稿しない」を聞く。

- 投稿する: §6 の手順（`--dry-run` → 確認 → 本実行）をここまでの JSON で行う。
- 投稿しない: 書き出し済みの JSON のパス一覧を伝えて終了する。

再開引数は無い。`/pr-review-assist {n}` を打ち直せば Step 一覧が再表示される、と伝える。

完了条件: 残 Step 一覧とコメント件数をユーザーに伝え、投稿する/しないの回答に応じた処理を終えている。

## 8. 完了

全 Step の結果表（Step | approved | コメント件数）と、§6（または §7）の投稿結果（投稿したかどうか、投稿した場合は成功したスレッド数）を出し、層6の案内を添えて「レビュー完了」と伝える。GitHub 上の Approve / Request changes は行わない（ユーザーが GitHub 上で行う）。

完了条件: 全 Step の結果表と投稿結果、層6の案内をユーザーに伝えた。
