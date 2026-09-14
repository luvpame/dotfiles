# Herdr 0.9.0 でできるようになったこと

調査日：2026-09-10。
対象は 2026-09-07 公開の v0.9.0 と、直前の安定版 v0.8.2 との差分。
新機能の判定には [v0.9.0 の CHANGELOG](https://github.com/herdrdev/herdr/blob/v0.9.0/CHANGELOG.md) を使い、操作条件は同じタグのドキュメントで確認した。
実機での動作確認や設定変更は行っていない。

## 新しくできる操作

| 機能 | できるようになったこと | 条件や制約 |
| --- | --- | --- |
| 複数マシンの統合 | Local と保存した SSH 接続先を一つの画面で切り替え、エージェント一覧と通知をまとめて確認できる | 各マシンのサーバーとプロセスは独立。1 接続先の切断で他は止まらない |
| 複数クライアントの独立表示 | 同じサーバーに接続した別ウィンドウで、それぞれ異なる workspace や tab を見られる | 同じ tab を共有すると、最後に操作したクライアントのサイズが使われる |
| サイドバーの条件付き書式 | トークンの文字列や数値に応じて色、太字、薄い表示を切り替えられる | 最初に一致したルールを採用。正規表現やスクリプトは非対応 |
| テーマの明暗別設定 | 自動テーマ切替で light と dark に別々のカスタム色を指定できる | 自動切替の有効化が必要 |
| 単一 pane の枠線 | `ui.pane_borders = "always"` で分割していない pane も囲める | 外側の枠線も有効にする。`"auto"` は分割時のみ、`"off"` は非表示。従来の boolean も有効 |

さらに、Muse の idle、working、承認待ち、質問待ちの検出が追加された。
画像表示と graphics API は対応端末で既定有効になったが、画像機能自体は以前から存在する。
無効にする設定は `terminal.kitty_graphics = false` で、旧 `experimental.kitty_graphics` も受理される。
出典：[v0.9.0 CHANGELOG の Added / Changed](https://github.com/herdrdev/herdr/blob/v0.9.0/CHANGELOG.md)。

## SSH 接続先をまとめる

公式の追加コマンド例は次のとおり。
`workbox` は利用者の SSH 接続先に置き換える。

```bash
herdr machine add workbox --label "Build machine"
herdr machine list
```

接続先の名前付きセッションを使う場合は、追加時に `--remote-session agents` などを付ける。
一つのプロファイルが扱うのは一つのリモートセッションであり、そのホスト上の全セッションではない。

対応するのは Linux/macOS クライアントから Linux/macOS サーバーへの接続で、x86_64 と aarch64 が対象。
Windows では複数マシン接続は未対応だが、従来の単独 `herdr --remote` は対応する。
切断後は自動で再接続する。
切断中の一覧は古い情報を薄く表示し、その pane への入力を無効にする。

`machine disable` と `machine remove` はクライアントの接続を切るだけで、リモートのエージェントを止めない。
画面で別マシンを選んでも、既存 pane 内の CLI の接続先は変わらない。
リモートへの設定、プラグイン、実行ファイルの自動コピーも行われない。
出典：[v0.9.0 Connecting machines](https://github.com/herdrdev/herdr/blob/v0.9.0/docs/next/website/src/content/docs/connecting-machines.mdx)。

## 現在の dotfiles との関係

調査時点の [config.toml](../../config/herdr/config.toml) では、Claude と Codex の行に `$context`、`$git_branch`、PR 状態のトークンを表示している。
0.9.0 では、これらの値に応じた書式を設定できる。

条件は `equals`、`contains`、`starts_with`、`gt`、`lt` のいずれか。
たとえば数値トークンなら、80 超を赤、50 超を黄にできる。
ただし `"90%"` は数値として判定されず、`"90"` のような値が必要になる。
現在の `$context` に適用する前には、実際に報告している値の形式を確認する必要がある。
出典：[サイドバーの条件付き書式](https://herdr.dev/docs/configuration/#sidebar-row-layouts)。

現在のカスタム行には `machine` がない。
複数マシン接続を使う場合は、Claude と Codex の行にも `machine` を足すと実行先を区別できる。
既存のカスタム行には自動追加されない。
出典：[v0.9.0 の Settings and automation](https://github.com/herdrdev/herdr/blob/v0.9.0/docs/next/website/src/content/docs/connecting-machines.mdx#settings-and-automation)。

現在は `theme.auto_switch = false` なので、明暗別の上書き設定だけを追加しても自動切替は起こらない。
また、現在使っている `prefix+|` は、macOS Option や独自キーボード配列で生成した文字の認識が改善された対象に含まれる。
出典：[現行設定](../../config/herdr/config.toml)、[v0.9.0 CHANGELOG](https://github.com/herdrdev/herdr/blob/v0.9.0/CHANGELOG.md)。

## 既存操作の改善

| 対象 | 改善内容 |
| --- | --- |
| エージェントへの送信 | `agent prompt` は本文と Enter の送信後に成功を返す。非稼働状態からの `--wait` は working または blocked の観測を要求し、無関係な状態変化で待機を終えない |
| 出力の取得 | recent pane read で、まだ画面外へスクロールしていない出力も取得できる |
| Claude Code | バックグラウンド MCP 処理中や承認待ちの状態判定を改善。背景 shell だけが残った idle 状態の誤判定も修正 |
| Codex | 過去の出力に引用された確認文で blocked になる誤検出を修正。明示的に再開したセッションを最初のプロンプトより前に保存 |
| コピー | 出力中も選択範囲を保持し、マウスボタンを離すイベントが遅れても Ctrl+C/Cmd+C でコピーできる。コピー失敗でエージェントを中断しない |

ほかに、idle 端末の履歴を減らさずメモリ使用量を削減し、ホスト終了時に保存セッションが空になる問題を修正した。
Nix では crate の取得先を静的 CDN に変え、従来のエンドポイントによるダウンロード失敗を回避する。
WSL のリモートセッションでは Windows クリップボードから画像を貼り付けられるようになった。
出典：[v0.9.0 CHANGELOG の Changed / Fixed](https://github.com/herdrdev/herdr/blob/v0.9.0/CHANGELOG.md)。

## 更新時に変わる挙動

1. クライアント更新時に、互換性があるサーバーと実行中エージェントをそのまま使える。古い endpoint generation 1 未満のサーバーには一度更新が必要。完全なバージョン一致は要求しないが、複数マシン接続には追加の能力が必要。
2. テーマやコピー設定などの表示設定はクライアント側で扱う。pane の既定値、カスタムコマンドなどは実行先サーバーに属する。
3. 子 worktree workspace が開いている親 workspace の終了には `workspace close --group` が必要。指定しなければグループ全体を開いたままにする。
4. lifecycle event の購読開始時に過去イベントを再送しない。API 利用側は先に購読し、その後に初期スナップショットを取得する。
5. `--no-session` が削除された。すべてバックグラウンドサーバーに接続し、detach では pane が動き続け、`server stop` で終了する。

リモートサーバーの置換は実行中の pane プロセスを停止するため、確認が入り、既定の回答は No。
live handoff は引き続き実験機能で、明示的な有効化が必要。
出典：[v0.9.0 CHANGELOG](https://github.com/herdrdev/herdr/blob/v0.9.0/CHANGELOG.md)、[接続互換性と更新](https://github.com/herdrdev/herdr/blob/v0.9.0/docs/next/website/src/content/docs/connecting-machines.mdx#updates-and-saved-data)。
