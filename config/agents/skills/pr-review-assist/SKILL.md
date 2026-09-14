---
name: pr-review-assist
description: PRのレビューを始めるとき、変更をどの順で読めばいいか整理したいときに使う。
argument-hint: "[PR番号 または PR URL（省略時は現在ブランチのPR）]"
disable-model-invocation: true
---

# pr-review-assist

## 1. 入力収集

対象リポジトリの作業ツリー内で実行する（ブランチは問わない）。

引数 `{n}`（PR番号 or URL）があればそれを対象にする。無ければ現在ブランチの PR を対象にする。

1. `gh pr view [{n}] --json number,title,body,headRefName,baseRefName,baseRefOid,url,additions,deletions,changedFiles,files` を実行する。
2. `git fetch origin {headRefName} --no-write-fetch-head` に続けて `git log --oneline {baseRefOid}..origin/{headRefName}` を実行する（1 の結果を使う）。

`gh pr view` が失敗する（PR がまだ無い）場合は、PR を作成してから再実行するよう伝えて終了する。

ファイル一覧は `files[*].path` で得る。差分本文は `gh pr diff {n}` で読む（層への分類にも HTML の内容にも使う）。base は必ず `baseRefOid` の SHA を使う（`origin/{baseRefName}` はスタック PR で差分が膨張するため使わない）。

完了条件: `gh pr view` の JSON、`git log` の出力、`gh pr diff` の出力を取得済みである。

## 2. 変更の分類

ファイルを依存層に分類する。

| 層 | 含むもの |
|---|---|
| 1. 計画 / 設計 | `docs/`, `plans/`, `*.md`, `openapi/` |
| 2. 純粋ロジック | hooks, utils, models, pure services, server actions |
| 3. 純粋ビジュアル | presentational components, `*.module.css`, stories |
| 4. 配置・状態制御 | containers, orchestrators, providers, stateful components |
| 5. 呼び出し側 | pages, route handlers, feature integrations |
| 6. 末尾の調整コミット | fix/style/refactor の小コミット、`*/generated/` や `*-schema.d.ts` などの自動生成物 |

層6はコミットの時系列ではなく性質で判定する。この PR の主目的から独立した小さな fix/style/refactor と自動生成物が層6で、時系列上の最後のコミットであっても主目的に関わるものは該当する層に入れる。

`spec/` や `*.test.*` は対象実装ファイルと同じ層に含める。複数ファイルへの同型変更は「1つ精読 + 残り{N-1}つは差分同型確認」として1件に数える。この数え方は層を小見出しに分けるかどうかの判定にだけ使う。HTML には同型変更のファイルも1ファイル1項目・1リンクで全て出し、「差分同型確認」のラベルをつける。

層内が10件を超えたら機能ディレクトリ単位の小見出しに分ける。空の層は飛ばす。

層6はファイルリンクを出さず、HTML 末尾の注意書き（生成物は生成元の変更と対応しているか、調整コミットは直前の層の差分に含まれているか）だけにする。

完了条件: 層ごとのファイル一覧（層 | 目的1文 | ファイル | 精読/同型確認の別）が確定している。

## 3. HTML を書く

`template.html`（このスキルと同じディレクトリ）の構造に沿って HTML を書く。差分を羅列するのではなく判断を書く。

まず次の2つを手順として実行する。

1. Skill ツールで `eli33` を呼ぶ。題材は「この PR が何をするか」。得られた説明を要約セクションの本文にする。図解は SVG かテキスト図としてそのまま HTML 本体に埋める（別ファイルにしない）。
2. Skill ツールで `show-me` を呼ぶ。題材は「この PR の変更の構造」。得られたテキスト図（ファイルツリーか依存図）を構造図セクションに `<pre>` で埋める。

注意:
- どちらも claude.ai への publish はしない。出力は HTML 本体に取り込む。
- show-me の mermaid 記法はローカル HTML では描画されないため使わない。ファイルツリー・コールツリー・コンポーネントツリーなどのテキスト図にする。

- 差分本文そのものは HTML に貼らない。リンクが差分である。引用するとしても要点の数行まで。
- 説明は短く書く。背景・経緯・言い換えを足さない。リンク先の差分で分かることは書かない。
- PR 全体の要約: 何をするか・なぜ必要かを前提知識なしで**3文以内**で書く。「なぜ」は PR body から取る。
- 各層に目的を1文つける。何をする層かだけを書く。
- 各ファイルに必ず次の3つを書く。
  1. 変更の要点。「何を」「どうした」だけの1文。
  2. 確認ポイント 1〜3個。各1行、「〜か」で終える疑問形。（呼び出し元への影響 / 境界値・エラー時 / 振る舞いが変わるか / テストの有無 のいずれかに該当するもの。思いつかない場合は「確認ポイントなし（自明な変更）」と明記して省略してよい）
  3. 精読 か 差分同型確認 のラベル
- 横断の注意点セクション（冒頭）: 振る舞いが変わるのにテストが無い箇所 / 削除された処理 / 設定・環境変数・マイグレーション / 公開シグネチャの変更。各項目1行。該当が無ければセクションごと省く。

悪い例はどれも、リンク先の差分を見れば分かることを書いている。

書き方の例

| 項目 | 良い例 | 悪い例 |
|---|---|---|
| 変更の要点 | `並び替えの enum 参照を定数に集約した。` | `並び替えの選択肢を扱う enum の参照先がコンポーネント側に散っていたため、constants に集約する設計に変更した（PR本文の意図どおり）。` |
| 確認ポイント | `page.tsx からの参照漏れが無いか` | `page.tsx から移設した REVIEW_LIST_MAX_PAGE について、他の箇所からの参照が残っていて壊れていないか確認する必要があるか` |
| 層の目的 | `URL と API 条件の変換を担う層。` | `並び替え・絞り込みの型・定数、URL の searchParams と条件・API クエリ間の変換、件数/一覧取得のロジックを提供する層。` |
| 横断の注意点 | `ReviewList.spec.tsx が無いまま分岐が増えている` | `ReviewList.tsx に追加された「絞り込み中の0件は専用メッセージ、そうでなければ従来の投稿導線」という分岐と、並び替えセレクトの表示に対応する ReviewList.spec.tsx が存在しない。` |
- GitHub の差分アンカーリンクは次の手順で作る。

  ```bash
  printf '%s' '{path}' | shasum -a 256 | cut -d' ' -f1
  ```

  リンクは `{url}/files#diff-{sha256}`（`{url}` は §1 の `gh pr view --json url` の値）。

完了条件: template.html の構造を満たした HTML 文字列ができている。

## 4. 出力

1. スクラッチパッドディレクトリ（セッションのシステムプロンプト記載のパス）に `pr-{n}-review.html` として書き出す。
2. `open` で開く。
3. claude.ai への publish はしない。
4. ターミナルには次の3行だけを出す。

   ```
   PRタイトル: {title}
   ファイル数: {changedFiles}
   HTML: {path}
   ```

GitHub 上の Approve / Request changes は行わない（ユーザーが GitHub 上で行う）。

完了条件: HTML ファイルが書き出され `open` で開かれ、ターミナルに上記3行が出ている。
