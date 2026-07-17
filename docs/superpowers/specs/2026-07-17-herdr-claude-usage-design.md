# Herdr の Claude 使用量表示

## 目的

Herdr の展開済み Agent 行に、Claude Code のコンテキスト使用率、5 時間使用率、7 日間使用率を表示する。

## 設計

Claude Code が既存の status line スクリプトへ渡す `context_window` と `rate_limits` を再利用する。status line スクリプトは、Herdr 内で動作している場合だけ `herdr pane report-metadata` を呼び、現在の pane に三つの token を報告する。Herdr の Claude 専用行レイアウトは、その token を一行に表示する。

値が未提供または `null` の場合は token を空にして、以前の値を残さない。Herdr 外では metadata 報告を行わず、現在の status line 出力は変えない。Herdr CLI の失敗も status line の描画を妨げない。

## 変更範囲

- `config/claude/statusline.py`：使用率の抽出と pane metadata 報告
- `config/herdr/config.toml`：Claude 専用の Agent 行レイアウト
- status line スクリプトの最小回帰テスト

新しい依存関係、独自の使用量 API、Herdr 管理下の integration hook 変更は追加しない。

## 検証

モック JSON と偽の `herdr` コマンドを使い、三つの token、欠損値のクリア、Herdr 外で未実行になること、従来の標準出力が保たれることを確認する。最後にリポジトリの既定チェックを実行する。
