# Herdr diff pane トグル設計

## 目的

`prefix+d` で Hunk の差分 pane を開閉できるようにする。

## 挙動

キー入力時に現在のタブの pane だけを調べる。
`diff view` というラベル、または `hunk diff` を含む端末タイトルを持つ pane があれば、該当する pane をすべて閉じる。
該当する pane がなければ、現在の pane の右側に pane を作成し、`diff view` と名付けて `hunk diff` を実行する。

## 実装

既存の `[[keys.command]]` にあるシェルコマンドだけを変更する。
`herdr pane list` の JSON を `jq` で絞り込み、`HERDR_ACTIVE_PANE_ID` から特定した現在のタブにある pane のうち、ラベルまたは端末タイトルが条件に合う ID を取得する。

対象 ID がある場合は `herdr pane close` を実行し、作成処理には進まない。
対象 ID がない場合の作成処理は現状を維持する。

## 確認

設定ファイルの構文を Herdr の設定検証手段で確認する。
シェル条件式について、対象 pane がある場合はその ID を選び、ない場合は作成側へ進むことを最小のコマンドで確認する。
