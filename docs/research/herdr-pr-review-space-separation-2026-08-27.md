# Herdr の PR review workspace を別の親 space に分けられるか

調査日：2026-08-27（Asia/Tokyo）

対象：ローカルで稼働している `herdr 0.8.2` と、公式リポジトリの v0.8.2 release commit `9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c`。

## 結論

同じ Herdr セッション内で、同じ Git リポジトリから作った PR worktree だけを、通常 workspace とは別の native worktree group の親へ分けることは、v0.8.2 の公開 CLI と socket API ではできない。

Herdr はラベルではなく、Git の common directory から作る `repo_key` を worktree group の識別子に使う。
同じ `repo_key` の workspace は一つの group に集約され、非リンク worktree workspace が親として表示される。
[Git メタデータの生成](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/workspace/git/discovery.rs#L42-L98) [sidebar の group 化](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/ui/sidebar.rs#L338-L435)

今回の目的に最も近い実現方法は、PR review 用に名前付き Herdr セッション（例：`pr-review`）を分けることである。
セッションは別 socket と別 workspace 状態を持つため、同じ Git repository を使っても通常セッションの group と混ざらない。
これはソースの group 集計が一つの `AppState.workspaces` を対象にし、名前付きセッションが別データディレクトリと socket を使うことから導ける推論である。
[名前付きセッションの socket](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/socket-api.mdx#L666-L684) [セッションの実装](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/session.rs#L157-L180)

## Herdr の階層モデル

`workspace` は Herdr の最上位の project または work context であり、作成時に最初の tab と root pane も作られる。
`tab` は workspace 内の別 terminal layout、`pane` はその layout 内の端末単位である。
[CLI reference](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/cli-reference.mdx#L115-L146)

Git worktree は Herdr では独立した workspace として扱われる。
workspace に付く `WorktreeSpaceMembership` は、次の情報を保持する。

- `key`：Git common directory を正規化した group 識別子
- `label`：表示用の repository 名
- `repo_root`：Git repository の root
- `checkout_path`：その workspace が開く checkout
- `is_linked_worktree`：リンクされた worktree かどうか

[WorktreeSpaceMembership](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/workspace.rs#L30-L37) [workspace の公開 worktree 情報](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/api/schema/workspaces.rs#L51-L75)

Herdr は `git_dir` と `git_common_dir` が異なるときに linked worktree と判定し、`git_common_dir` の canonical path を `GitSpaceMetadata.key` にする。
したがって、checkout の配置先や workspace label を変えても、同じ Git common directory を共有する限り `repo_key` は変わらない。
[GitSpaceMetadata の生成](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/workspace/git/discovery.rs#L42-L98)

sidebar は同じ `key` の membership を集め、二件以上かつ非リンク member が一件以上ある場合に group を表示する。
親はその group 内で最初に見つかった非リンク member であり、残りがインデントされた child になる。
[sidebar の親選択](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/ui/sidebar.rs#L348-L410)

公式設定ドキュメントも、worktree を source workspace の下に group 化し、parent row は original workspace だと説明している。
[Worktrees の公式説明](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/configuration.mdx#L94-L109)

## `herdr worktree open` が親を決める方法

v0.8.2 の CLI 構文は次の通りである。

```text
herdr worktree open [--workspace ID | --cwd PATH] \
  (--path PATH | --branch NAME) [--label TEXT] [--focus] [--no-focus]
```

`--workspace` と `--cwd` は source の選択であり、`--path` または `--branch` は開く checkout の選択である。
`--parent`、`--group`、`--visible-parent-workspace`、任意の group key に相当する引数は存在しない。
[v0.8.2 CLI source](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/cli/worktree.rs#L159-L246) [公開 CLI reference](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/cli-reference.mdx#L135-L146)

`--cwd` を使う経路では、Herdr がその path の Git metadata を読み、linked worktree を source に指定すると `linked_worktree_source` エラーを返す。
非リンクの repository root を `source_checkout_path` と `source_repo_root` に使い、同じ `repo_key` の既存非リンク workspace を source parent として探す。
[`--cwd` の source 解決](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/worktrees.rs#L174-L217)

`--workspace` を使う経路でも、linked worktree workspace は source にできない。
非リンク workspace なら、その workspace の membership または Git metadata から source を組み立てる。
[workspace source の解決](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/worktrees.rs#L282-L328)

既存の parent が見つからない場合だけ、Herdr は source checkout path に workspace を作り、`is_linked_worktree = false` の membership を付ける。
その後、対象 checkout の workspace に同じ key で `is_linked_worktree = true` の membership を付ける。
[parent membership の確保](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/worktrees.rs#L380-L435) [membership の作成](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/worktrees.rs#L666-L716)

このため、現在の post-start hook は `primary_worktree_path` を source として使い、その repository の既存 parent に PR workspace を追加する。
[現行 post-start hook](../../config/worktrunk/config.toml#L1-L6)

## 親を指定または変更する CLI と API

socket API の `WorktreeOpenParams` にあるのは `workspace_id`、`cwd`、`path`、`branch`、`label`、`focus` だけである。
親 workspace や group 識別子を指定するフィールドはない。
[WorktreeOpenParams](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/api/schema/worktrees.rs#L29-L43)

`workspace.move` と `workspace.move_block` は socket API に存在するが、引数は workspace の挿入位置だけである。
サーバー実装も workspace 配列を並べ替え、membership を変更しない。
[workspace move の schema](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/api/schema/workspaces.rs#L19-L36) [workspace move の実装](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/workspaces.rs#L121-L225)

v0.8.2 の CLI には `workspace.move` 自体がなく、`workspace` サブコマンドは list、create、get、focus、rename、report-metadata、close だけを受け付ける。
[CLI workspace parser](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/cli/workspace.rs#L7-L29)

TUI の workspace 移動も linked child を単独では動かせず、worktree group に属する parent を移動すると同じ key の member 全体を block として並べ替える。
これは表示順の変更であり、別 parent への再所属ではない。
[TUI の workspace 移動パラメータ](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/input/sidebar.rs#L383-L465)

membership を書き換える `set_worktree_membership` は Rust 内部 API（`pub(crate)`）であり、socket API の mutation として公開されていない。
[内部 membership 更新](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/worktrees.rs#L437-L471)

公式の Discussion #553 も、linked checkout を visible parent にするための `--visible-parent-workspace` 形式を提案している。
これは現行機能の説明ではなく、既存仕様では解決できない要望として登録された一次情報である。
[Discussion #553](https://github.com/herdrdev/herdr/discussions/553)

## 代替案

### 1. 名前付き Herdr セッションを PR review 専用にする

推奨案である。

```text
通常セッション                 pr-review セッション
shogun                         review-#123 group
通常 workspace 群              review-#456 group
                               ...
```

Herdr は `herdr --session <name>` で名前付きセッションを起動または attach でき、セッションごとに `~/.config/herdr/sessions/<name>/herdr.sock` を使う。
[CLI の named session](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/cli-reference.mdx#L10-L26) [session socket](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/socket-api.mdx#L666-L684)

PR review 用セッション内では従来通り `worktree.open` を使えるため、worktree provenance、`checkout_path`、group parent、既存 cleanup 方針を維持できる。
通常セッションの workspace は別サーバーの状態なので、同じ `repo_key` でも sidebar group は混ざらない。
後半は実装から導く推論である。

注意点は、`herdr --session pr-review worktree open ...` が未起動の session server を自動起動するわけではないことである。
CLI の自動起動は subcommand なしの `herdr --session pr-review` で server daemon を起動してから client を attach する経路であり、CLI API client は指定 socket に接続するだけである。
[自動起動の実装](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/server/autodetect.rs#L280-L305) [API client の接続](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/api/client.rs#L31-L98)

したがって、名前付きセッションを一度起動し、そのセッション内でオーケストレーターを起動する運用が必要になる。

### 2. `workspace create` で PR workspace を単独の top-level にする

`herdr workspace create --cwd <worktree> --label review-#123` に切り替えると、worktree group membership を付けずに top-level workspace を作れる。
これは通常 workspace と PR workspace を視覚的に分けるが、親 space の下に PR worktree をまとめる方法ではない。
[workspace.create の生成経路](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/app/api/workspaces.rs#L39-L70) [通常 workspace の初期 membership](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/src/workspace.rs#L452-L464)

この方式では `workspace.list` に Git worktree provenance が出ず、`worktree remove` の linked child 経路も使えない。
そのため、hook の戻り値または作成時の workspace ID を保存し、cleanup は Herdr workspace close と `wt remove` を別々に行う変更が必要になる。
現行オーケストレーターが `worktree.checkout_path` を残骸回収に使う設計であることにも影響する。
[workspace 作成の公開仕様](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/docs/next/website/src/content/docs/cli-reference.mdx#L115-L133) [現行 cleanup 設計](../../config/agents/skills/pr-review-orchestrator/SKILL.md#L338-L348)

### 3. PR review 用に別の Git common directory を使う

別 clone または別 bare repository から worktree を作れば、canonical `git_common_dir` が変わり、Herdr の `repo_key` も変わる。
同じ Herdr セッション内でも別 group として表示できる。

ただし `wt switch pr:<番号>`、fetch、branch、cleanup の全経路を別 clone に向ける必要がある。
現行の `wt switch` と post-start hook の前提を大きく変えるため、最小変更ではない。

## 推奨案の変更箇所

### `config/worktrunk/config.toml`

現行 hook は次を実行する。

```bash
herdr worktree open --cwd {{ primary_worktree_path }} --path {{ worktree_path }} --focus
```

PR review 用の経路では、これを名前付きセッションへ向ける。

```bash
herdr --session pr-review worktree open \
  --cwd {{ primary_worktree_path }} \
  --path {{ worktree_path }} \
  --focus
```

ただし、この hook が通常の `wt switch` にも共通適用されるなら、無条件に変更してはならない。
通常作業は default セッションへ残し、PR review だけが `pr-review` セッションを使う分岐または専用の Worktrunk entrypoint を設ける必要がある。

### `pr-review-orchestrator` skill

現在の skill は、オーケストレーターを同じセッション内の workspace へ `pane move --new-workspace` し、その後の全 `herdr` 呼び出しを default socket に送る前提である。
[専用 workspace への移動](../../config/agents/skills/pr-review-orchestrator/SKILL.md#L28-L42) [worktree open の起動](../../config/agents/skills/pr-review-orchestrator/SKILL.md#L118-L160)

名前付きセッション案では、次のいずれかに揃える必要がある。

- オーケストレーター自体を `herdr --session pr-review` に attach した pane から起動し、既存の `herdr` 呼び出しをそのセッションの context で実行する。
- オーケストレーターを default セッションに残すなら、`workspace list`、`worktree open`、`tab list/create`、`pane list/read/run`、`agent start/get/prompt/wait`、cleanup など、PR review に関わる全 Herdr CLI を `--session pr-review` 付きにする。

前者のほうが、`HERDR_WORKSPACE_ID`、`HERDR_TAB_ID`、`HERDR_PANE_ID` と workspace ID の取り違えを減らせる。
後者では session 間の pane move はできないため、現行 step 2 の `pane move --new-workspace` をそのまま使えない。

state ファイルは session ごとに分け、`reviewed-sha-pr<番号>`、`worktree-pr<番号>`、monitor task ID が review session の workspace と対応することを確認する。
既存の default session にある review workspace を移す場合、pane を session 間で移動する API はないため、レビュー agent を新しい session で再起動する必要がある。

### upstream で本当に親を指定可能にする場合

同一 session、同一 Git common directory のまま二つの native group を作るには、`repo_key` だけに依存する現行 membership model を拡張する必要がある。
最小の設計候補は、source repository の識別子と表示 group または visible parent の識別子を分離し、`WorktreeOpenParams` に visible parent を追加することである。

変更対象は少なくとも次である。

- `src/api/schema/worktrees.rs`：visible parent または group ID の wire schema と CLI parser
- `src/app/api/worktrees.rs`：source resolution と membership assignment
- `src/workspace.rs` と `src/persist/`：membership の保存と復元
- `src/ui/sidebar.rs`：`repo_key` ではなく表示 group 単位での親選択
- workspace close、move、worktree remove：parent と group のライフサイクル規則

この変更は現行設定の変更ではなく、Herdr 本体の機能追加である。
Discussion #553 が提案する `source_repo_root` と `visible-parent-workspace` の分離は、この必要なモデル変更を具体化している。
[Discussion #553](https://github.com/herdrdev/herdr/discussions/553)

## 調査結果の要約

| 問い | v0.8.2 の答え |
| --- | --- |
| 親は何で決まるか | 同じ canonical Git common directory の `repo_key` と、非リンク membership の存在で決まる。 |
| `--label` で分けられるか | 分けられない。label は表示名であり group key ではない。 |
| `--cwd` の path で分けられるか | 分けられない。同じ Git common directory なら同じ key になる。 |
| 任意の parent を指定できるか | `worktree.open` の CLI、schema、socket API に指定欄がない。 |
| `workspace.move` で reparent できるか | できない。表示順の並べ替えだけである。 |
| 最小の実用案 | `pr-review` という名前付き Herdr セッションを用意し、hook と orchestrator をそこへ向ける。 |
