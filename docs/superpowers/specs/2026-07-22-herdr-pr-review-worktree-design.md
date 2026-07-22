# Herdr PR レビュー worktree 設計

## 目的

現在の GitHub リポジトリで自分が reviewer に指定されている PR を Herdr の popup から選び、レビュー専用 worktree と Herdr workspace を作成する。
作成した workspace の root pane 全域に Hunk で PR の差分を表示する。

## 起動方法

`prefix+shift+g` に `popup` 型のカスタムコマンドを割り当てる。
popup は Fish のレビュー専用関数 `review-pr` を実行する。
既存の `wt` 関数は変更せず、`review-pr` からも呼び出さない。

## PR の選択

`review-pr` は現在のリポジトリで `gh pr list --search 'review-requested:@me'` を実行する。
PR 番号、base branch、タイトルを JSON から TSV へ変換し、番号とタイトルを `fzf` に表示する。
対象 PR がなければメッセージを表示して終了する。
`fzf` がキャンセルされた場合は正常終了し、worktree や workspace を作成しない。

## worktree の作成

選択した PR 番号からレビュー専用のローカル branch 名 `review-pr-<番号>` を作る。
`git fetch origin` で PR の head ref と base branch を取得し、`git gtr new review-pr-<番号> --no-fetch` で worktree を作成する。
`git gtr go review-pr-<番号>` で作成先を取得し、そのパスを新しい Herdr workspace の cwd にする。
同名の branch または worktree がすでに存在する場合は自動削除や再利用を行わず、`git gtr` のエラーで処理を止める。

## Herdr workspace と Hunk

`git gtr go` が返した worktree のパスを `herdr workspace create --cwd` に渡す。
Herdr が返す JSON から新しい workspace ID と root pane ID を取得する。
workspace や tab の名前は変更せず、Herdr の既定名を使う。
root pane に `hunk diff origin/<base branch>...HEAD` を送信し、PR の差分を pane 全域に表示する。
Hunk の起動に成功した後、`herdr workspace focus` で新しい workspace にフォーカスする。
追加の split pane は作成しない。

## エラー処理

`gh`、`git fetch`、`git gtr`、`herdr workspace create` のいずれかが失敗した場合は、その時点で後続処理を止める。
popup は失敗内容を確認できる状態を保ち、利用者の入力後に閉じる。
Hunk の起動に失敗した場合は新しい workspace にフォーカスせず、作成済みの workspace と worktree も削除しない。

## 確認

Fish のテストでは外部コマンドを置き換え、選択した PR の番号と base branch が fetch、`git gtr`、Herdr workspace、Hunk の各引数へ渡ることを確認する。
Hunk の起動後に新しい workspace ID を指定した focus が実行されることも確認する。
対象 PR がない場合と `fzf` をキャンセルした場合に、変更を伴うコマンドが実行されないことも確認する。
設定は `herdr config check` で検証し、リポジトリ全体は `just check` で確認する。
