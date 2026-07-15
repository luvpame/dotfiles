# delta から hunk への移行設計

## 目的

Git の差分表示に使っている delta を hunk に置き換える。
Git、Lazygit、Neovim のすべての利用箇所を移行し、delta への依存を削除する。

## 変更方針

- Homebrew の `git-delta` を `hunk` に置き換える。
- Git のページャーを `hunk pager` に変更し、delta 専用設定を削除する。
- Lazygit のカスタムページャーを `hunk pager` に変更する。
- Neovim の Telescope と PR プレビューで使う差分整形コマンドを `hunk pager` に変更する。
- delta 専用のオプションと実行可能判定を残さない。

## エラー処理

Neovim の差分プレビューは、現在と同様にページャーが利用できる場合だけ外部コマンドを使う。
hunk がない場合は各プラグインの標準表示へ戻す。

## 検証

- リポジトリ内に有効な delta 参照が残っていないことを確認する。
- Nix のフォーマットと flake check を実行する。
- 変更した Lua ファイルを Neovim のヘッドレス起動で読み込む。
- Git と Lazygit の設定が `hunk pager` を参照することを確認する。
