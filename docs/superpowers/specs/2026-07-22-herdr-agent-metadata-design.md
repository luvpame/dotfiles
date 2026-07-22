# Herdr Agent メタデータ表示設計

## 目的

Herdr サイドバーの Claude と Codex の Agent 行から 5 時間、7 日間の usage limit を外し、現在のセッションで使われているモデル名と effort を表示する。
Codex では fast mode が有効な場合も表示する。
context 使用率は残す。

## 表示

既存の3行目を次の形式にする。

```text
ctx: …  󰚩 Opus 4.7  󰓅 xhigh
ctx: …  󰚩 gpt-5.6-sol  󰓅 low  󱐋 fast
```

- `󰚩`：モデル
- `󰓅`：effort
- `󱐋`：Codex の fast mode

取得できない値と、無効な fast mode は空文字として表示しない。

## データ取得

Claude は既存の status line JSON から `model.display_name` と `effort.level` を読み、既存の Herdr metadata 報告へ追加する。

Codex は既存の rollout JSONL の末尾200行を1回だけ読み、最新の `turn_context` から `model` と `effort`、最新の `thread_settings_applied.thread_settings.service_tier` から fast mode を判定する。
`service_tier` が `fast` または `priority` の場合に fast mode を有効とする。

Herdr の行定義では `five_hour` と `seven_day` を、新しい `model`、`effort`、Codex 専用の `fast_mode` token に置き換える。

## エラー処理

入力項目が欠けていても status line と hook を失敗させない。
Herdr CLI の不在や失敗も、現在と同様に表示処理へ影響させない。

## テスト

既存の `unittest` を変更し、Claude と Codex が期待する metadata token を報告することを確認する。
Codex では fast mode の有効時と無効時を検証し、Claude では effort を持たないモデルで空文字になることを検証する。
