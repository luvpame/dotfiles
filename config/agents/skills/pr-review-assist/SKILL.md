---
name: pr-review-assist
description: PRの変更を依存層順のStepに分け、Stepごとに該当ファイルへのGitHubリンクを提示して順に読ませる。
argument-hint: "[PR番号 または PR URL（省略時は現在ブランチのPR）]"
disable-model-invocation: true
---

# pr-review-assist

## 1. 入力収集

対象リポジトリの作業ツリー内で実行する（ブランチは問わない）。

引数 `{n}`（PR番号 or URL）があればそれを対象にする。無ければ現在ブランチの PR を対象にする。

1. `gh pr view [{n}] --json number,title,body,headRefName,baseRefName,baseRefOid,url,additions,deletions,changedFiles,files` を実行する。
2. `git fetch origin {headRefName}` に続けて `git log --oneline {baseRefOid}..origin/{headRefName}` を実行する（1 の結果を使う）。

`gh pr view` が失敗する（PR がまだ無い）場合は、PR を作成してから再実行するよう伝えて終了する。

ファイル一覧は `files[*].path` で得る。差分本文は `gh pr diff {n}` で読む（層への分類にもサマリにも使う）。base は必ず `baseRefOid` の SHA を使う（`origin/{baseRefName}` はスタック PR で差分が膨張するため使わない）。

完了条件: `gh pr view` の JSON、`git log` の出力、`gh pr diff` の出力を取得済みである。

## 2. Step の構成

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

層6はリンクを出さず、次の2点の案内だけにする: 生成物は生成元の変更と対応しているか、調整コミットは直前 Step の差分に含まれているかの2点。

完了条件: Step 一覧表（Step | 対象 | 目的）が確定している。

## 3. サマリ Artifact（Step 1 の前に1回）

Skill ツールで `eli33`（題材: この PR が何をするか、前提知識なし向け）と `show-me`（変更の構造図: ファイルツリーか依存図）を呼び、その出力と Step 一覧表を1つの HTML にまとめてスクラッチパッドディレクトリ（セッションのシステムプロンプト記載のパス）に書き、`open` で開く。claude.ai への publish はしない。

完了条件: HTML が開かれ、ターミナルにも Step 一覧表（`Step | 対象 | 目的`）が出ている。

## 4. Step の進行（Step ごとに繰り返す）

1. その Step の各ファイルについて GitHub PR の差分アンカー付きリンクを組み立てる。アンカーはファイルパスの sha256 hex:
   ```bash
   printf '%s' '{path}' | shasum -a 256 | cut -d' ' -f1
   ```
   リンクは `{url}/files#diff-{sha256}` （`{url}` は §1 の `gh pr view --json url` の値 = `https://github.com/{owner}/{repo}/pull/{n}`）。
2. 次のテンプレート通りにターミナル出力する（項目の省略・順序変更・追加をしない）:

   ```
   Step {k}: {層名}

   対象: {Nファイル}
   目的: {1文}

   - {path}
     {link}
   ...

   読み終えたら「次」と言ってください。
   ```
   - ファイルは同型変更グループも含めて1ファイル1リンクで全て列挙する。同型変更がある場合は、精読する1ファイルの行に「精読」、残りに「差分同型確認」と注記する。
3. 出力したらそのターンを終了し、ユーザーが「次」と言うまで待つ。AskUserQuestion は使わない。全 Step のリンクを一度にまとめて出すこともしない。
4. ユーザーが次へ進むと言ったら次の Step を同じ手順で出す。

完了条件: その Step の全ファイルのリンクを出力し、ユーザーの次の指示を待っている。

## 5. 中断

ユーザーが途中でレビューを中断するよう指示したときにこの節を使う。残りの Step 一覧を出す。`/pr-review-assist {n}` を打ち直せば Step 一覧が再表示される（再開引数は無い）と伝えて終わる。

完了条件: 残 Step 一覧をユーザーに伝えた。

## 6. 完了

通った Step の一覧を出し、層6の案内を添えて「レビュー完了」と伝える。GitHub 上の Approve / Request changes は行わない（ユーザーが GitHub 上で行う）。

完了条件: 通った Step の一覧と層6の案内をユーザーに伝えた。
