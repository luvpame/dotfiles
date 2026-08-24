# Neovim から現在ブランチの GitHub PR をレビューする候補

調査日は 2026-08-21 である。

対象は、現在の dotfiles が利用している `diffview.nvim` と、GitHub PR レビュー機能を持つ `octo.nvim` である。
GitHub の Files changed 画面が持つ「変更ファイルの一覧、差分の確認、ファイル単位の Viewed 状態更新」を Neovim から再現できるかを、各プロジェクトの公式 README、公式ソース、GitHub 公式 API ドキュメントで確認した。

## 結論

第一候補は `pwntester/octo.nvim` である。
現行の master commit `205f024d3ea4a3d81aac751b6bf8e2d01e0c204f` は、現在ブランチに対応する PR を `gh pr view` から解決し、changed files のパネルと左右の差分を開き、ファイルごとの Viewed 状態を GitHub へ反映できる。
[PR review の公式説明](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/README.md#L771-L788) と [PR review の help](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/doc/octo.txt#L487-L515) が、changed files panel、差分、未 Viewed ファイル移動、レビュー送信を説明している。

閲覧だけなら `:Octo review browse` を使う。
これは「review を開始せずに表示する」モードであり、GitHub に保留レビューを作らない。
[公式 help](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/doc/octo.txt#L407-L419) が `browse` と `start` を分けて定義している。

コメントを付けてレビューを送信する場合だけ `:Octo review start` または `:Octo review resume` を使う。
したがって、今回の「見終わったら Viewed にする」用途では、保留レビューを作らない `browse` が適している。

自作は不要である。
既存の `diffview.nvim` は補助的に残せるが、GitHub PR の Viewed 状態を扱わないため、Viewed まで含めた体験を組み立てる基盤には `octo.nvim` を選ぶ。

## 要件との対応

| 要件 | `octo.nvim` | `diffview.nvim` |
| --- | --- | --- |
| 現在ブランチに紐づく PR の解決 | 対応する。Neovim の Octo バッファでない場合は `gh pr view` を現在ブランチに対して実行する。 | 対応しない。PR 番号や GitHub API を解決せず、Git の rev を受け取る。 |
| changed files の一覧 | 対応する。PR review の file panel と `:Octo pr changes` がある。 | 対応する。ただしローカル Git の rev 差分に含まれるファイルの一覧である。 |
| PR の差分 | 対応する。GitHub の PR API から patch と raw diff を取得し、左右の差分を表示する。 | 条件付きで対応する。PR ブランチをローカルへ checkout し、`origin/HEAD...HEAD` などの rev を指定する。 |
| GitHub の Viewed 更新 | 対応する。GraphQL の `markFileAsViewed` と `unmarkFileAsViewed` を呼ぶ。 | 対応しない。公式 README とソースが扱うのは Git と Mercurial のローカル差分であり、GitHub の Viewed API 呼び出しがない。 |
| 未 Viewed ファイルへの移動 | 対応する。`[u` と `]u` がある。 | 対応しない。 |

## `octo.nvim` の確認結果

### 現在ブランチから PR を解決する

Octo の review 実装は、現在のバッファが PR バッファでなければ `utils.get_pull_request_for_current_branch` へフォールバックする。
この関係は [`get_pr_from_buffer_or_current_branch`](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/init.lua#L629-L645) にある。

その関数は `gh pr view --json id,number,headRepositoryOwner,headRepository,isCrossRepository,url` を実行し、得られた PR の Node ID、番号、head repository などから Octo の PR オブジェクトを構築する。
実装は [`get_pull_request_for_current_branch`](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/utils.lua#L1672-L1724) にある。

GitHub CLI も、`gh pr view` に引数を渡さなければ現在ブランチに属する PR を表示し、`--json` で指定フィールドを JSON 出力できると定義している。
[GitHub CLI の公式マニュアル](https://cli.github.com/manual/gh_pr_view#gh-pr-view) がこの挙動を定義する。

現在ブランチに PR がない場合は、Octo が `No pr found for current branch` を通知する。

### changed files と差分を表示する

PR オブジェクトは、GitHub REST API の `GET /repos/{owner}/{repo}/pulls/{pull_number}/files` を `--paginate` 相当で取得する。
各ファイルの `filename`、`previous_filename`、`patch`、`status`、`additions`、`deletions`、`changes` を `FileEntry` に変換する。
実装は [`PullRequest:get_changed_files`](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/model/pull-request.lua#L125-L168) にある。

同じ PR オブジェクトは `Accept: application/vnd.github.diff` を付けて PR エンドポイントを取得し、raw diff も保持する。
実装は [`PullRequest:get_diff`](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/model/pull-request.lua#L107-L123) にある。

GitHub REST API は changed files の一覧をページングでき、1 回のレスポンスは最大 100 件、全体のレスポンスは最大 3000 ファイルである。
[REST API の公式ドキュメント](https://docs.github.com/en/rest/pulls/pulls#list-pull-request-files) がこの上限と `filename`、`patch`、差分統計の形式を定義する。

Octo の PR review layout は file panel と左右の diff window を開く。
file panel には status、diffstat、Viewed 状態のアイコン、パスが表示される。
[file panel の描画実装](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/file-panel.lua#L264-L325) と [review の開始処理](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/init.lua#L208-L230) がその経路を示す。

### Viewed 状態を GitHub へ反映する

GitHub GraphQL の `PullRequestChangedFile` は、ファイルパス、追加行数、削除行数、変更種別、および viewer ごとの `viewerViewedState` を持つ。
`FileViewedState` は `DISMISSED`、`UNVIEWED`、`VIEWED` の三値であり、`DISMISSED` は最後に Viewed にした後で新しい変更が入った状態である。
[GraphQL の公式 Pull requests リファレンス](https://docs.github.com/en/graphql/reference/pulls#pullrequestchangedfile) と [FileViewedState の定義](https://docs.github.com/en/graphql/reference/pulls#fileviewedstate) がこの契約を定義する。

Octo は PR の GraphQL query で `files { path viewerViewedState }` を取得し、各 `FileEntry` に状態を保持する。
[PR query](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/gh/queries.lua#L155-L184) と [FileEntry の初期化](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/file-entry.lua#L90-L120) がその処理を示す。

差分 window または file panel で既定の `<localleader><space>` を押すと、現在のファイルに対する toggle が実行される。
既定 mapping は [`toggle_viewed`](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/README.md#L512-L550) に記載され、mapping の実装は [review mapping](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/mappings.lua#L546-L551) にある。

状態が `UNVIEWED` または `DISMISSED` なら `markFileAsViewed`、`VIEWED` なら `unmarkFileAsViewed` を呼ぶ。
mutation には GitHub の PR Node ID とファイルパスを渡し、成功後に file panel を再描画する。
実装は [`FileEntry:toggle_viewed`](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/file-entry.lua#L123-L155) と [GraphQL mutation](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/gh/mutations.lua#L133-L163) にある。

GitHub の mutation リファレンスも、`markFileAsViewed` を「pull request file を Viewed にする mutation」、`unmarkFileAsViewed` をその逆と定義し、入力として `path` と `pullRequestId` を要求する。
[markFileAsViewed](https://docs.github.com/en/graphql/reference/pulls#markfileasviewed)、[unmarkFileAsViewed](https://docs.github.com/en/graphql/reference/pulls#unmarkfileasviewed)、および [入力型](https://docs.github.com/en/graphql/reference/pulls#markfileasviewedinput) が根拠である。

未 Viewed ファイルへの移動は `[u` と `]u` で行う。
全ファイルが Viewed の場合は通常の前後移動へフォールバックする。
[未 Viewed 移動の実装](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/layout.lua#L198-L248) がこの挙動を定義する。

### 閲覧だけのモードとレビュー送信を分ける

`:Octo review browse` は `Review:browse` を呼び、既存の review thread を読み込んで差分 layout を初期化する。
この経路は review ID を作らないため、Viewed 更新はできるが、コメントを pending review として追加できない。
[browse と start の分岐](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/init.lua#L648-L681) と [browse 中のコメント制限](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/commands.lua#L847-L861) がこの境界を示す。

`:Octo review start` は `addPullRequestReview` を呼んで pending review を作る。
コメントと最終的な Approve、Comment、Request changes が必要な場合はこちらを使う。

### 依存と現行構成との関係

Octo の公式要件は Neovim 0.10 以上、GitHub CLI、`plenary.nvim`、picker（Telescope、fzf-lua、Snacks、または既定の `vim.ui.select`）、および任意の `nvim-web-devicons` である。
[公式 README の要件と lazy.nvim 設定例](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/README.md#L112-L145) を参照する。

現行の Neovim 設定には `diffview.nvim`、Snacks、Telescope、`plenary.nvim` がすでにあるが、Octo の宣言はない。
そのため、導入時には Octo の lazy.nvim spec を追加して既存の `plenary.nvim` を依存として宣言し、`gh auth status` と `:checkhealth octo` を確認することになる。

Octo の `use_local_fs` 既定値は `false` である。
既定値では GitHub から取得した差分を表示し、ローカル checkout を要求しない。
ローカルファイルを右側に表示したい場合だけ `use_local_fs = true` を検討し、PR ブランチにいない場合の checkout 確認を受け入れる。
[既定設定](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/config.lua#L254-L266) と [checkout 確認](https://github.com/pwntester/octo.nvim/blob/205f024d3ea4a3d81aac751b6bf8e2d01e0c204f/lua/octo/reviews/init.lua#L208-L219) が根拠である。

## `diffview.nvim` の位置づけ

`diffview.nvim` は「任意の Git rev の変更ファイルを一つの tabpage で巡回する」プラグインである。
公式 README の説明は Git の変更ファイル、merge tool、file history、`DiffviewOpen` と `DiffviewFileHistory` に限られる。
[公式 README](https://github.com/sindrets/diffview.nvim/blob/4516612fe98ff56ae0415a259ff6361a89419b0a/README.md#L1-L14) と [コマンド説明](https://github.com/sindrets/diffview.nvim/blob/4516612fe98ff56ae0415a259ff6361a89419b0a/README.md#L81-L115) がその範囲を示す。

公式の PR review guide も、まず `gh pr checkout {PR_ID}` でブランチをローカルへ checkout し、その後 `:DiffviewOpen origin/HEAD...HEAD --imply-local` を実行する手順を案内する。
これは PR の Git 差分を読む用途には使えるが、PR の Node ID、changed files の GitHub 側 `viewerViewedState`、GraphQL mutation には接続しない。
[公式 PR review guide](https://github.com/sindrets/diffview.nvim/blob/4516612fe98ff56ae0415a259ff6361a89419b0a/USAGE.md#L6-L33) が根拠である。

したがって、現行 `diffview.nvim` は通常の Git 差分レビューに残し、GitHub PR の一覧、コメント、Viewed 状態には `octo.nvim` を使う組み合わせが自然である。
ただし、同じ PR を `diffview.nvim` と Octo の両方で開くと、差分の基準が Git の merge-base と GitHub API の PR patch で分かれるため、Viewed 状態を更新するレビュー画面は Octo に統一する。

## 自作へ切り替える場合の最小 API 境界

現時点では自作の必要はない。
将来、Octo の画面構成を採用できない事情が出た場合でも、次の API 境界だけで要件を満たせる。

1. **現在ブランチの PR 解決**：`gh pr view --json id,number,url,headRepositoryOwner,headRepository,isCrossRepository` を引数なしで実行し、PR Node ID、owner、repo、number を得る。
2. **変更ファイル一覧**：`GET /repos/{owner}/{repo}/pulls/{number}/files` をページングし、`filename`、`previous_filename`、`status`、`patch`、`additions`、`deletions`、`changes` を file entry に保存する。
3. **差分表示**：同じ PR に `Accept: application/vnd.github.diff` を付けて raw diff を取得するか、file entry の `patch` を左右の diff buffer へ描画する。
4. **Viewed 状態の取得**：GraphQL の `pullRequest(number) { files(first: 100, after: $cursor) { nodes { path viewerViewedState } pageInfo { hasNextPage endCursor } } }` をページングし、パスから状態を引く。
5. **Viewed 更新**：`markFileAsViewed(input: { path, pullRequestId })` と `unmarkFileAsViewed(input: { path, pullRequestId })` を呼び、成功時にローカルの file entry と一覧表示を更新する。
6. **レビュー操作**：一覧から選択、前後移動、未 Viewed 移動、Viewed toggle、再読み込みを UI の最小操作として公開する。

Octo の実装はこの境界をすでに満たしている。
自作する場合に追加で必要になるのは、GitHub CLI 認証を使うプロセス管理、GraphQL のページング、エラー時の再表示、および差分 window のライフサイクルである。

## 導入判断

まず `octo.nvim` を追加し、`<leader>` の PR 用キーから `:Octo review browse` を呼び出す構成を試す。
レビューを始める前に現在ブランチの PR を取得し、file panel で対象ファイルを選び、差分を確認したら `<localleader><space>` で Viewed にする。
`[u` と `]u` を未 Viewed ファイル巡回用の標準操作として使う。

Octo の更新時には、PR review の `browse`、changed files の取得、Viewed toggle、100 ファイルを超える PR の挙動を確認する。
100 ファイルを超える PR では、現在の Octo query が `files(first:100)` であるため、REST 側の一覧取得上限とは別に Viewed 状態の初期値が 100 件までになる可能性がある。
このケースを常用するなら、upstream のページング対応状況を確認してから導入する。
