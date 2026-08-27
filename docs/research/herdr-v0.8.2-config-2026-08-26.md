# Herdr v0.8.2 の設定差分

調査日時は 2026-08-26（Asia/Tokyo）である。

## 比較基準

公式の [タグ一覧](https://github.com/herdrdev/herdr/tags) には v0.8.2 と v0.8.0 が表示され、v0.8.1 のタグは現在表示されない。

一方、公式の [version manifest](https://github.com/herdrdev/herdr/blob/38d1819862346f26ea826a278fc4402643bce58a/docs/versions/manifest.json#L1-L16) は v0.8.1 のタグを commit `09b2554dedc06e1b4fb3f74a00b907b3101ebff7` に対応づけている。

そのため、v0.8.1 の比較基準には、公式の [v0.8.1 release commit](https://github.com/herdrdev/herdr/commit/09b2554dedc06e1b4fb3f74a00b907b3101ebff7) を使った。

設定キーの比較対象は、v0.8.1 commit の [config-reference.json](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json) と v0.8.2 の [config-reference.json](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json) である。

## 結論

v0.8.1 と v0.8.2 の config reference は、キー数がともに 167 件で、キー名、型、既定値、列挙値に差がない。

v0.8.1 commit と v0.8.2 tag の [src/config](https://github.com/herdrdev/herdr/compare/09b2554dedc06e1b4fb3f74a00b907b3101ebff7...v0.8.2) にも差分がないため、**v0.8.2 で v0.8.1 から新設された設定キーは 0 件である**。

v0.8.2 のリリースノートに追加項目として列挙された設定群は、実際には v0.8.1 の [CHANGELOG.md](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/CHANGELOG.md#L5-L28) にも同じ形で記載されている。

次の表は、混同を避けるために、v0.8.0 から v0.8.1 release commit までに追加され、v0.8.2 でも使える 17 件を記録する。

## v0.8.0 から v0.8.1 までに追加された 17 件

以下のキーは v0.8.2 固有の追加ではなく、v0.8.1 から v0.8.2 へ移行する際の構文変更を必要としない。

| キー | 型と既定値 | 用途 | v0.8.1 から v0.8.2 の移行要否 | 現行設定への適用候補 |
| --- | --- | --- | --- | --- |
| [`server.headless_cols`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L19-L24) | `integer`, `120` | クライアント未接続時のレイアウトと新規ペインの仮想端末幅で、0 より大きい値を指定する。 | 不要。v0.8.0 の 80 列を維持する場合だけ `80` を明示する。 | 現行ファイルに `[server]` はないため、ヘッドレス動作を固定するなら `120` を追加する。 |
| [`server.headless_rows`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L25-L30) | `integer`, `40` | クライアント未接続時のレイアウトと新規ペインの仮想端末の高さで、0 より大きい値を指定する。 | 不要。v0.8.0 の 24 行を維持する場合だけ `24` を明示する。 | `server.headless_cols` と組にして `40` を追加する。 |
| [`theme.custom.sidebar_bg`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L73-L77) | `color`, `unset` | 他のパネル面を変えずにデスクトップ sidebar の背景色を指定する。 | 不要。未指定時は既定の表示を使う。 | 現行の `catppuccin-latte` で sidebar の背景を分けたい場合だけ `[theme.custom]` に追加する。 |
| [`theme.custom.active_row_bg`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L79-L83) | `color`, `unset` | active Space と focus 中の Agent row の背景色を指定し、separator と scrollbar track は変えない。 | 不要。未指定時は theme の既定色を使う。 | sidebar の active row が背景に埋もれる場合だけ `sidebar_bg` と一緒に追加する。 |
| [`theme.custom.selection_bg`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L85-L89) | `color`, `unset` | Navigate mode で cursor がある sidebar row の背景色を指定する。 | 不要。未指定時は theme ごとの cursor 色を使う。 | Navigate cursor と active row の区別が必要になった場合だけ追加する。 |
| [`keys.move_tab_previous`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L424-L428) | `keybinding`, `unset` | active tab を一つ前へ移動し、先頭からさらに移動すると末尾へ wrap する。 | 不要。unset のままなら既存 keymap に影響しない。 | 既存の `prefix+shift+h/j/k/l`（pane swap）と衝突しない `prefix+shift+left` を候補にする。 |
| [`keys.move_tab_next`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L430-L434) | `keybinding`, `unset` | active tab を一つ後ろへ移動し、末尾からさらに移動すると先頭へ wrap する。 | 不要。unset のままなら既存 keymap に影響しない。 | `prefix+shift+right` を候補にし、WezTerm が modifier を保持することを実機で確認する。 |
| [`keys.resize_pane_left`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L568-L572) | `keybinding`, `unset` | resize mode に入らず focus 中の pane を左方向へリサイズする。 | 不要。unset のままなら既存の `prefix+r` resize mode を保持する。 | 公式例の `ctrl+shift+alt+left` を候補にする。 |
| [`keys.resize_pane_down`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L574-L578) | `keybinding`, `unset` | resize mode に入らず focus 中の pane を下方向へリサイズする。 | 不要。unset のままなら既存の `prefix+r` resize mode を保持する。 | 公式例の `ctrl+shift+alt+down` を候補にする。 |
| [`keys.resize_pane_up`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L580-L584) | `keybinding`, `unset` | resize mode に入らず focus 中の pane を上方向へリサイズする。 | 不要。unset のままなら既存の `prefix+r` resize mode を保持する。 | 公式例の `ctrl+shift+alt+up` を候補にする。 |
| [`keys.resize_pane_right`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L586-L590) | `keybinding`, `unset` | resize mode に入らず focus 中の pane を右方向へリサイズする。 | 不要。unset のままなら既存の `prefix+r` resize mode を保持する。 | 公式例の `ctrl+shift+alt+right` を候補にする。 |
| [`ui.pane_outer_borders`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L728-L732) | `boolean`, `true` | split pane の外周 border を内部 divider から独立して表示または非表示にする。 | 不要。既定値 `true` は従来の外観を保つ。 | tmux 風の内部 divider だけにする場合に `pane_gaps = false` とともに `false` を試す。 |
| [`ui.tab_bar_right`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L768-L778) | `array`, `[]` | desktop tab bar 右端に順序付きの status entry を表示し、`zoom`、`hostname`、`datetime`、`text`、`command` を受け付ける。 | 不要。空配列のままなら tab bar に追加表示しない。 | 現行の下配置 tab bar で host と時刻を見たい場合に追加するが、sidebar metadata との重複を確認する。 |
| [`ui.tab_bar_right_separator`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L781-L784) | `string`, `" "` | visible な右側 status entry の間に挿入する文字列を指定する。 | 不要。`ui.tab_bar_right` が空なら表示へ影響しない。 | `tab_bar_right` を追加する場合だけ `"  "` などへ調整する。 |
| [`ui.window_title`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L787-L790) | `string`, `"{hostname}: {workspace}"` | Herdr が実行される外側 terminal の title を session 情報から生成する。 | 不要。v0.8.1 から既定値は変わらない。外側 title を Herdr に変更させたくない場合だけ `""` を明示する。 | 現行の WezTerm title に tab 名も出す場合に `"{hostname}: {workspace} / {tab}"` を候補にする。 |
| [`ui.status_indicators`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L803-L810) | `enum`, `"dots"`; `dots` または `symbols` | Agent の blocked、working、done、idle、unknown を compact な色付き dot または静的 symbol で表示する。 | 不要。既定値 `dots` は従来の compact 表示を保つ。 | 現行 row が `state_icon` を使うため、色だけに依存したくない場合に `"symbols"` を試す。 |
| [`ui.sound.agents.qwen`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L1133-L1141) | `enum`, `"default"`; `default`、`on`、`off` | 検出した Qwen Code Agent に対する通知音の個別設定を指定する。 | 不要。Qwen を使わず、または `default` のままなら既存 sound 設定に影響しない。 | Qwen を導入して通知音を抑える場合だけ `[ui.sound.agents]` に `qwen = "off"` を追加する。 |

### `ui.tab_bar_right` の entry 型

`ui.tab_bar_right` は `type` を判別子にする配列で、`zoom` と `hostname` には追加フィールドがなく、`datetime` は `format` を持ち、`text` は `text` を持ち、`command` は `command`、`interval_seconds`、`timeout_seconds` を持つ。

`datetime.format` の既定値は %H:%M で、`command.interval_seconds` の既定値は 5 秒、`command.timeout_seconds` の既定値は 2 秒である。

command entry は Herdr server 上で実行され、interval は 1 秒から 31,536,000 秒、timeout は 1 秒から 3,600 秒の範囲で、配列全体は最大 16 entry である。

command entry は描画をブロックせず、成功した出力の最終行を表示し、失敗、空出力、timeout では値を消す。

これらの entry 型、既定値、検証範囲は [src/config/tab_bar.rs](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/tab_bar.rs#L1-L108) と [configuration ドキュメント](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx#L286-L304) にある。

### `ui.window_title` の token

`ui.window_title` は `{hostname}`、`{workspace}`、`{tab}`、`{pane}`、`{terminal_title}` を token として使い、`{{` と `}}` は literal brace になる。

空文字列を指定すると outer terminal title を変更せず、生成された title は制御文字を除去したうえで 200 文字に制限される。

token の定義と空文字列の動作は [src/config/window_title.rs](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/window_title.rs#L1-L106) と [configuration ドキュメント](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx#L306-L319) にある。

### 色設定の値

三つの `theme.custom` 色キーは hex、名前付き色、`rgb(r,g,b)`、`reset` 系 alias を受け付ける。

現行設定は `catppuccin-latte` を使い、`theme.custom` を指定していないため、色の候補は実機の contrast を確認してから追加する。

色の構文と三つの役割は [configuration ドキュメント](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx#L261-L278) と [src/config/theme.rs](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/theme.rs#L101-L107) にある。

## 現行 `config.toml` への適用候補

現行の [config/herdr/config.toml](../../config/herdr/config.toml#L1-L120) は、`prefix = "ctrl+j"`、下配置 tab bar、`state_icon` を含む Claude と Codex の Agent row、pane history を指定し、新設キーはまだ明示していない。

### ヘッドレス寸法を固定する候補

v0.8.2 の既定値を設定ファイルにも残す場合は、次を追加する。

```toml
[server]
headless_cols = 120
headless_rows = 40
```

v0.8.0 の 80×24 を意図的に維持する場合は、`120` と `40` を `80` と `24` に置き換える。

クライアント接続中は client の terminal size が優先され、detach 後も既存 PTY は最後の接続時サイズを保ち、新規の headless layout だけがこの fallback を使う。

この挙動は [configuration ドキュメント](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx#L53-L63) にある。

### keymap を拡張する候補

現行の `[keys]` へ追加する場合の候補は次のとおりである。

```toml
[keys]
move_tab_previous = "prefix+shift+left"
move_tab_next = "prefix+shift+right"
resize_pane_left = "ctrl+shift+alt+left"
resize_pane_down = "ctrl+shift+alt+down"
resize_pane_up = "ctrl+shift+alt+up"
resize_pane_right = "ctrl+shift+alt+right"
```

resize の四つの chord は [公式 configuration 例](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx#L152-L160) に合わせたが、WezTerm、macOS keyboard layout、tmux の modifier 処理を実機で確認してから固定する。

tab 移動は現行の `prefix+shift+h/j/k/l` による pane swap と役割を分けている。

### status、title、pane 外周を調整する候補

現行の sidebar metadata を残しながら状態を形でも区別する場合は、次の一行が最小の候補になる。

```toml
[ui]
status_indicators = "symbols"
```

tab bar 右端へ host と時刻を加える場合は、次のようにする。

```toml
[ui]
tab_bar_right = [
  { type = "hostname" },
  { type = "datetime", format = "%H:%M" },
]
tab_bar_right_separator = "  "
```

現行は sidebar に branch、Git change、PR、dev server、review request を表示するため、tab bar status は重複を確認してから追加する。

外側の terminal title に tab 名まで含める場合は、次を候補にする。

```toml
[ui]
window_title = "{hostname}: {workspace} / {tab}"
```

既存の host terminal title を維持する場合は `window_title = ""` を指定する。

pane の外周だけを消して内部 divider を残す場合は、次を組み合わせる。

```toml
[ui]
pane_gaps = false
pane_outer_borders = false
```

現行 config は pane border と gap を既定値に任せているため、見た目の確認なしにこの候補を追加しない。

### Qwen を導入する場合の候補

v0.8.2 は Qwen Code の検出と native session restore を追加したが、既存の [`session.resume_agents_on_restore`](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L1161-L1165) を使うため、新しい session 設定キーは追加していない。

Qwen を実際に使い、通知音を止める場合だけ次を追加する。

```toml
[ui.sound.agents]
qwen = "off"
```

現行の [Nix package](../../nix/nix-darwin/home-manager/packages.nix#L68-L77) と config には Qwen binary、Qwen hook、Qwen row override がないため、先に Qwen Code 自体の導入を決める。

## v0.8.2 の変更だが新設キーではないもの

`ui.right_click_passthrough_modifier` は v0.8.1 の config reference にすでにあり、v0.8.2 は pane menu、CLI、socket API からの right-click passthrough 動作を追加しただけである。

`session.resume_agents_on_restore` は v0.8.1 から存在し、Qwen の native restore はこの既存設定の対象へ加わる。

`experimental.cjk_ime_agents` は既存キーのままで、v0.8.2 は許可される agent 名へ `qwen` と `qwen-code` を加えた。

`update.channel` は既存キーのままで、v0.8.1 で整理された Windows の stable または preview build に応じた既定 channel を v0.8.2 も引き継ぐ。

copy mode の `B`、`E`、`W`、plugin marketplace の探索、Windows remote、pane graphics、agent automation の修正は、今回の 17 件の設定キーには含めない。

既存キーであることは [v0.8.1 config reference](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L686-L690)、[v0.8.1 session reference](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json#L1161-L1165)、[v0.8.2 config reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json#L686-L690)、および [v0.8.2 release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2#L168-L187) で確認できる。

## 参照した一次資料

- [Herdr v0.8.2 release](https://github.com/herdrdev/herdr/releases/tag/v0.8.2)
- [Herdr v0.8.1 release commit `09b2554`](https://github.com/herdrdev/herdr/commit/09b2554dedc06e1b4fb3f74a00b907b3101ebff7)
- [v0.8.1 version manifest snapshot](https://github.com/herdrdev/herdr/blob/38d1819862346f26ea826a278fc4402643bce58a/docs/versions/manifest.json#L1-L16)
- [v0.8.0 config reference](https://github.com/herdrdev/herdr/blob/v0.8.0/docs/next/website/src/data/config-reference.json)
- [v0.8.1 config reference at the release commit](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/docs/next/website/src/data/config-reference.json)
- [v0.8.2 config reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json)
- [v0.8.1 CHANGELOG](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/CHANGELOG.md#L5-L28)
- [v0.8.2 CHANGELOG](https://github.com/herdrdev/herdr/blob/v0.8.2/CHANGELOG.md#L5-L28)
- [v0.8.1 source config model](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/model.rs)
- [v0.8.1 tab bar config source](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/tab_bar.rs)
- [v0.8.1 window title config source](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/window_title.rs)
- [v0.8.1 theme config source](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/theme.rs)
- [v0.8.1 sound config source](https://github.com/herdrdev/herdr/blob/09b2554dedc06e1b4fb3f74a00b907b3101ebff7/src/config/sound.rs)
- [v0.8.0 to v0.8.1 source comparison](https://github.com/herdrdev/herdr/compare/v0.8.0...09b2554dedc06e1b4fb3f74a00b907b3101ebff7)
- [v0.8.1 to v0.8.2 source comparison](https://github.com/herdrdev/herdr/compare/09b2554dedc06e1b4fb3f74a00b907b3101ebff7...v0.8.2)
