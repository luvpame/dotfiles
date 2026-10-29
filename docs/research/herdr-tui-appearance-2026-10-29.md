# Herdr 本体の見た目設定

調査日: 2026-10-29。対象は実行中の Herdr 0.9.5 のターミナル画面。herdr-gpui の固有設定は対象外。公式の [v0.9.5 設定ガイド](https://github.com/herdrdev/herdr/blob/v0.9.5/docs/next/website/src/content/docs/configuration.mdx) と [設定リファレンス](https://github.com/herdrdev/herdr/blob/v0.9.5/docs/next/website/src/data/config-reference.json)、実行中の `herdr --default-config`、`~/.config/herdr/config.toml` を照合した。調査時には設定変更や画面の実地確認は行っていない。

## 現在の構成

Herdr 本体は `catppuccin-latte` 固定。サイドバー幅は 72、状態アイコンは `symbols`、ペイン枠は `always`、外枠はオン。タブバーはローカル設定では上、リポジトリ版では下。右側の追加表示は空。Claude と Codex の1行目は状態・`$agent_icon`・マシン・workspace、2行目はブランチ名と PR 番号、3行目は作業文の `$activity`。PR は公開中・Draft・マージ済み・クローズ済みを色分けする。エージェント行にはタブ名を表示しない。Space は PR・レビュー・開発サーバーなどの独自トークンを表示している。ローカル設定にはテキスト選択時コピーと Space の agent 数の表示もある。

作業文は共通の [agent-activity.py](../../config/herdr/scripts/agent-activity.py) が生成する。Codex と Claude の `UserPromptSubmit` で今回の依頼、`Stop` で最終返信を受け取り、非同期で Haiku を呼ぶ。要約は日本語1文。設定された幅と最大幅の小さい方から、区切り線・スクロールバー・継続行の字下げの5桁を引いた範囲に収める。現在の72桁設定では本文は67桁以内。生成時にも短い文を指定し、超過した文字列は表示幅に合わせて省略する。通常は依頼開始時と最終返信後の2回更新し、途中の commentary やツール呼び出しごとには更新しない。要約用 Claude は safe mode、ツール無効、会話保存なしで起動する。以前のタブ自動命名フックはこの処理に置き換えた。

新しい更新では、要約前に Herdr の同じ metadata source にシーケンス番号を予約して旧作業文を消す。要約後はその次の番号で報告する。古い非同期結果は新しい予約より小さい番号になるため、Herdr が反映しない。要約が失敗した場合は作業文を表示しない。

## 追加できる設定

| 項目 | 設定 | 用途・制約 |
| --- | --- | --- |
| サイドバーの色 | `[theme.custom]` の `sidebar_bg`、`active_row_bg`、`selection_bg`、`accent` | サイドバー全体、選択中の Space / Agent、Navigate モードの選択行、強調色をそれぞれ調整できる。色は `#RRGGBB` などで指定。未指定の `sidebar_bg` はホスト端末の背景を使う。 |
| 明暗切替 | `theme.auto_switch`、`light_name`、`dark_name` | ホスト端末が通知する明暗に合わせてテーマを切り替える。現在はオフ。`[theme.custom.light]` と `[theme.custom.dark]` で明暗別の上書きもできる。 |
| ペイン周辺 | `ui.pane_borders`、`ui.pane_outer_borders`、`ui.pane_gaps`、`ui.pane_scrollbars` | 枠線を分割時だけの `auto` や `off` にしたり、ペイン間の隙間やスクロールバーを消したりできる。隙間と外枠をともにオフにすると内側の区切りだけになる。 |
| サイドバーの密度 | `ui.sidebar.agents.row_gap`、`ui.sidebar.spaces.row_gap`、`ui.sidebar_width`、`ui.sidebar_max_width` | Agent / Space の項目間に空行を追加したり、幅を変更したりできる。Agent は既定で空行なし。Space の worktree 親子は `row_gap` を設定しても詰めて表示される。 |
| 折りたたみ | `ui.sidebar_collapsed_mode`、`ui.sidebar_start_collapsed` | 折りたたみ時を `compact` または `hidden` にできる。`sidebar_start_collapsed` の変更は次回起動時から。 |
| タブと端末タイトル | `ui.hide_tab_bar_when_single_tab`、`ui.tab_bar_position`、`ui.window_title` | タブが一つのときだけタブバーを隠す、上下に置く、外側の端末タイトルに `{workspace}` / `{tab}` 等を入れることができる。 |
| 個別の行と色 | `[ui.sidebar.agents]` / `[ui.sidebar.spaces]` の `rows`、`rows_by_agent`、`rules` | トークンの並び、行数、色、太字、条件付き表示を変えられる。`rows_by_agent` は該当 Agent の行全体を置き換える。テキスト条件は `equals`、`contains`、`starts_with`、数値条件は `gt`、`lt`。先に一致したルールが優先される。 |

各行の書式と条件は [サイドバー行の公式説明](https://herdr.dev/docs/configuration/#sidebar-row-layouts) を参照。トークンが報告されていなければ表示は消える。`$context` の値は `90%` のように `%` が付くため、そのままでは `gt` / `lt` の数値条件に一致しない。文字色の条件は `state_icon` と `git_status` の内部には適用できない。

右側の追加表示は現在設定していない。テーマやトークンの変更は、状況を識別できる色のコントラストと、ターミナル幅での読みやすさを見て決める。

## 過去資料との差

[2026-08-20 の調査](herdr-v0.8.2-2026-08-20.md) と [2026-09-10 の調査](herdr-v0.9.0-2026-09-10.md) は、調査当時の Claude / Codex 行に context・ブランチ・PR を表示すると記録している。現在の両行は `$agent_icon` の表示に変更されている。[2026-08-26 の調査](herdr-v0.8.2-config-2026-08-26.md) は当時の新設設定を未明示としているが、現在は `status_indicators = "symbols"` を明示している。これらは日付付き調査時点の記録であり、現行設定を説明するものではない。
