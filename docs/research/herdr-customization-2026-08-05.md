# Herdr カスタマイズ調査

調査日は 2026-08-05 である。
手元の `herdr --version` は 0.8.0 であり、公式の latest release も 2026-08-03 公開の v0.8.0 だった。
このリポジトリの `flake.lock` はリビジョン `15442a27d058a398e791b4880af1d9048b17fe26` を固定している。

現行の `config/herdr/config.toml`、`herdr --default-config`、`herdr --skill`、リポジトリ内の使用箇所を、公式 release notes・ドキュメント・CLI と照合した。
手動のキー操作までは記録されないため、「未試用」は設定やリポジトリに利用記録がなく、今回の作業でも試していないものを指す。

## 結論

最新版への更新は不要である。
すでに v0.8.0 を使っているため、次に試す価値があるのは、導入済みだが未活用の機能である。

| 優先度 | 機能 | 版 | 試し方 | 判断 |
| --- | --- | --- | --- | --- |
| P0 | キーヘルプのライブ検索 | 0.8.0 | `Ctrl+j ?`、続けて `/`、検索語 | 設定変更なしで試す |
| P0 | idle Agent の長い履歴の自動読取 | 0.8.0 | `herdr agent read <agent> --source recent-unwrapped --lines 200` | Agent の成果回収で試す |
| P1 | pane scrollbar の非表示 | 0.8.0 | `[ui]` に `pane_scrollbars = false` | 数日だけ試す価値あり |
| P1 | Agent automation facade | 0.7.5 | `agent start`、`prompt --wait`、`read` | 定型レビューの委譲で試す |
| P1 | copy mode の検索 | 0.7.4 | `Ctrl+j [`、`/` または `?`、`n` / `N` | 設定変更なしで試す |
| P3 | tab bar の下配置 | 0.8.0 | `[ui]` に `tab_bar_position = "bottom"` | 見た目の好みだけなので後回し |

## v0.8.0 で試す候補

### キーヘルプのライブ検索

v0.8.0 では、キーヘルプを `/`、Backspace、`Ctrl+U` で絞り込める。
現行設定は標準キーに加えて popup、Hunk、Ziggity のカスタムコマンドを持つため、一覧を目で探すより検索の効果が出やすい。
設定変更は不要であり、現在の prefix が `Ctrl+j` なので、`Ctrl+j ?` の後に `/` を押して `popup` や `pane` を検索すれば試せる。

### idle Agent の長い履歴の自動読取

v0.8.0 では、Claude Code や OpenCode など alternate screen を使う認識済み Agent が idle で最下部にいるとき、`agent read` と `pane read` が画面外の履歴を自動収集する。
読み終えると application viewport は最下部へ戻る。
表示中の一画面だけでなく、長い調査結果やレビュー結果を別 Agent から回収する用途に向く。

この機能に設定は要らない。
対象 Agent が `working`、`blocked`、`unknown` のときや、手動で上へスクロールしているときは履歴取得を行わないため、`agent wait` と組み合わせる。

```sh
herdr agent wait reviewer --until idle --until done --timeout 120000
herdr agent read reviewer --source recent-unwrapped --lines 200
```

### pane scrollbar の非表示

`ui.pane_scrollbars = false` は v0.8.0 の新しい設定である。
各 pane の scrollbar 用に予約される一列を端末へ戻し、端末内のドラッグ選択に scrollbar を巻き込みにくくする。
現行設定は `sidebar_width = 72` でサイドバーを広く使うため、複数 pane を並べたときに一列を回収する効果が相対的に大きい。

```toml
[ui]
pane_scrollbars = false
```

スクロール位置を視覚的に確認する頻度が高ければ元に戻せるため、永続採用を決めずに数日試すのがよい。

### tab bar の下配置

`ui.tab_bar_position = "bottom"` も v0.8.0 の新機能である。
機能差はなく、tab row の位置だけが変わる。
現在の操作上の問題を解かないため、試用の優先度は低い。

## 直近版で未活用の候補

### Agent automation facade

v0.7.5 では、既存の shell pane に Agent を起動し、名前を付け、prompt を送り、状態を待ち、結果を読む一連の CLI が追加された。
今回同期したローカル Herdr skill は、この `agent start`、`agent prompt`、`agent wait`、`agent read` を正式な操作として説明している。

最初の試用は、独立したレビューのように失敗しても本体作業を壊さない仕事がよい。
pane ID を推測せず、作成結果から取得する。

```sh
split=$(herdr pane split --current --direction right --no-focus)
review_pane=$(printf '%s\n' "$split" | jq -r '.result.pane.pane_id')
herdr agent start reviewer --kind codex --pane "$review_pane"
herdr agent prompt reviewer "現在の差分をレビューしてください" --wait --timeout 120000
herdr agent read reviewer --source recent-unwrapped --lines 200
```

### copy mode の smart-case 検索

v0.7.4 以降の copy mode は、`/` と `?` による smart-case 検索、`n` と `N` による一致箇所の移動、複数行をまたぐ word motion を使える。
現行設定は `copy_mode` を上書きしていないため、`Ctrl+j [` で入り、そのまま試せる。
長いログや stack trace を端末内だけで調べるときに有効である。

`ui.copy_on_select = false` も同じ版で追加されたが、これは選択しただけで clipboard を上書きしたくない場合の条件付き候補である。
現在の mouse copy に不満がなければ変更しない。

## 今回すでに使った機能

v0.8.0 の `herdr --skill` は今回使い、`config/agents/skills/herdr/SKILL.md` を実行中 binary の同梱 skill と同期した。
Fish completion も `config/fish/config.d/plugins.fish` ですでに読み込んでいる。
`experimental.switch_ascii_input_source_in_prefix`、popup command、カスタム sidebar rows、pane history も現行設定で利用済みである。

## 今回は採用しない判断

ユーザー判断により、Goto の代替キーは追加しない。
同じく、`next_agent`、`previous_agent`、`focus_agent`、`last_pane` など Agent 巡回用キーも追加しない。
今後の推奨候補にも含めない。

Grok CLI と Antigravity CLI の session restore、Windows 向け IME・ConPTY 改善は v0.8.0 の新機能だが、現在の macOS と Claude/Codex/ Cursor 中心の構成には該当しない。
plugin は未導入だが、既存の worktree picker、Hunk pane、Ziggity と役割が重なるものが多く、最新版の試用候補として急いで追加する理由はない。

## 推奨する試用順

1. `Ctrl+j ?` からキーヘルプ検索を使う。
2. `Ctrl+j [` から copy mode 検索を使う。
3. 次に別 Agent へレビューを頼むとき、`agent prompt --wait` と長い履歴の自動読取を一連で試す。
4. 画面幅が窮屈なら `pane_scrollbars = false` だけを追加し、数日評価する。
5. tab bar の下配置は、見た目を変えたいときだけ試す。

## 一次情報

- [Herdr v0.8.0 release](https://github.com/herdrdev/herdr/releases/tag/v0.8.0)
- [Herdr changelog](https://github.com/herdrdev/herdr/blob/master/CHANGELOG.md)
- [Agent automation](https://herdr.dev/docs/agent-automation/)
- [Configuration](https://herdr.dev/docs/configuration/)
- [Config reference](https://herdr.dev/docs/config-reference/)
- [CLI reference](https://herdr.dev/docs/cli-reference/)
- [同梱 Agent skill](https://github.com/herdrdev/herdr/blob/15442a27d058a398e791b4880af1d9048b17fe26/skills/herdr/SKILL.md)
