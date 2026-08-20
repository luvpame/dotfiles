# Herdr v0.8.2 の導入候補

調査日は 2026-08-20 である。

対象は [Herdr v0.8.2 のリリース](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) と、そのタグのコードおよびドキュメントである。

このメモは、既存の [Herdr カスタマイズ調査](./herdr-customization-2026-08-05.md) が扱った v0.8.0 までの候補を前提に、v0.8.2 で増えた機能と修正を現行構成へ対応づける。

## 現行構成の前提

現行の Herdr は、Nix の `herdr` input を Home Manager の共通パッケージへ追加し、`config/herdr/config.toml` とスクリプトを out-of-store symlink で配置している。
[Nix の Herdr package 宣言](../../nix/nix-darwin/home-manager/packages/common.nix) と [Herdr ファイルの配置宣言](../../nix/nix-darwin/home-manager/files/common.nix) がその経路を定義する。

設定は `ctrl+j` prefix、下配置の tab bar、Claude と Codex の Agent 行、Hunk の diff pane、Ziggity、Worktrunk worktree picker、および三つの launchd metadata updater を使う。
[現行の Herdr 設定](../../config/herdr/config.toml) と [Herdr launchd service](../../nix/nix-darwin/home-manager/services/herdr.nix) にその内容がある。

調査時点のアクティブ binary は 0.8.1 である。
一方、未コミットの [flake.lock](../../nix/flake.lock) は Herdr の rev `7d35ebe7c4d8eec960b30216829e7247d628f423` を指し、その [Cargo.toml](https://github.com/herdrdev/herdr/blob/7d35ebe7c4d8eec960b30216829e7247d628f423/Cargo.toml) の package version は 0.8.2 である。
v0.8.2 タグの release commit は `9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c` であり、lock の rev はタグ後の master にあるため、**lock を build または switch すれば 0.8.2 相当になる可能性はあるが、未コミットの lock だけから active binary の切替済みとは判断しない**。
[v0.8.2 の release commit](https://github.com/herdrdev/herdr/commit/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c) と [現在 lock が指す commit](https://github.com/herdrdev/herdr/commit/7d35ebe7c4d8eec960b30216829e7247d628f423) を分けて扱う。

`flake.nix` の input URL は `github:ogulcancelik/herdr` のままで、v0.8.2 の exact tag を指定していない。
[現行の input 宣言](../../nix/flake.nix) を exact release の再現性まで求める変更と、最新 master を取り込む変更とで分けて判断する必要がある。

既存メモが v0.8.0 の `tab_bar_position = "bottom"`、pane history、key help 検索、alternate-screen の履歴読取、copy mode 検索、および Agent automation facade を記録している。
このメモでは、それらを v0.8.2 の新機能として重複して数えない。

## 優先度の一覧

| 優先度 | 候補 | 現行構成への判断 |
| --- | --- | --- |
| P0 | blocked 中の `agent prompt` 手順を見直す | `pr-review-orchestrator` の復帰手順が v0.8.2 の拒否仕様と衝突するため、最初に互換性を確認する。 |
| P0 | 同梱 Herdr skill を v0.8.2 相当に更新する | 現行 skill は `agent_not_ready` と blocked prompt 拒否を説明していない。 |
| P1 | v0.8.2 相当 binary の build と switch を検証する | 既存の prefix、Claude、Codex、pane history、CJK 入力に複数の修正が効く。lock 変更だけでは反映済みと判断しない。 |
| P1 | Agent 状態表示を `symbols` で試す | 現在の Agent 行は `state_icon` を使うため、blocked と working の識別を形でも補える。 |
| P2 | Qwen Code の検出と session restore | Qwen を実際に使う場合だけ integration を追加する。現行 Nix 構成には Qwen がない。 |
| P2 | tab bar 右側の status と outer window title | 現在の sidebar metadata と役割が重なるため、表示を一つに絞ってから追加する。 |
| P2 | tab 移動および一打鍵 pane resize | 現在の resize mode と prefix 設計を残したまま、既定 binding と衝突しない key を試す。 |
| P2 | right-click passthrough | Hunk、Ziggity、Neovim の mouse 操作で必要性が出た場合に限定する。 |
| P3 | pane 外周 border、sidebar 色、selection 色、copy mode の `B/E/W` | 見た目と操作感の候補であり、現行の動作上の問題を解決しない。 |
| P3 | headless terminal size、plugin marketplace 探索 | headless 運用または plugin 導入が必要になったときに再評価する。 |

## blocked 中の Agent automation 互換性

### v0.8.2 の事実

v0.8.2 は、blocked 状態（承認または質問 UI）にある Agent へ `agent prompt` を送ると、文字列や Enter を送らず `agent_blocked` を返すようにした。
通常の prompt は bracketed paste と遅延後の Enter を扱い、blocked UI の誤送信を防ぐ設計である。
[v0.8.2 の agent automation ドキュメント](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/agent-automation.mdx) と [CLI reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/cli-reference.mdx) がこの契約を定義する。

同じ版で `agent start` は、新しい pane shell と初回 prompt の準備を待つようになった。
起動時に blocked を検出した場合は `agent_not_ready` を返すが、Agent 名は保持し、idle になった後に prompt を受け付ける。
[v0.8.2 の `agent start` 実装ガイド](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/agent-automation.mdx) にその状態遷移がある。

### 現行構成との接点

[pr-review-orchestrator](../../config/agents/skills/pr-review-orchestrator/SKILL.md) の blocked 分岐は、画面を確認した後に `herdr agent prompt` でユーザーの回答を送る手順を定義している。
これは v0.8.2 では `agent_blocked` で拒否されるため、レビュー再開の最重要な互換性リスクである。

同 skill は `agent start` を最大 10 回再試行し、初回 `agent wait` を最大 5 回やり直す。
v0.8.2 の起動待機改善で再試行回数を減らせる可能性はあるが、direnv や devenv が foreground の場合まで解消するとはリリースノートは主張していない。

### 採用優先度

P0 である。
既存のレビュー監視を自動化したままにするなら、binary の切替前後で blocked 復帰を確認しなければならない。

### 導入時の具体的な変更候補

blocked 分岐を次のように分ける。

1. `herdr agent read <target> --source visible` で質問または承認 UI を読む。
2. ユーザーの回答が自由文なら、`herdr agent get <target>` から解決した pane ID を得て、`herdr pane send-text <pane_id> <answer>` と `herdr pane send-keys <pane_id> enter` を使う。
3. 選択式の確認なら、`herdr agent send-keys <target> up|down|enter` など、UI に合わせた論理 key を使う。
4. 送信後に `herdr agent get <target>` を読み、必要なら `herdr agent wait <target> --timeout 3600000` を再アームする。

`pane send-text` は低レベル入力であり、`agent prompt` の bracketed paste 保護を代替しないため、質問への明示的な回答にだけ使う。

### 見送り理由または注意点

blocked UI の種類を確認せずに `pane send-text` を自動送信すると、承認画面へ意図しない文字列を入力する。
まず `visible` の出力を確認し、ユーザーの回答を得る現在の安全境界を残す。

## 同梱 Herdr skill と CLI help の同期

### v0.8.2 の事実

v0.8.2 は CLI help から plain-text guide、documentation index、および built-in control skill へ coding agent を案内する。
同梱および installable な Herdr skill も、同 release の CLI と Agent lifecycle に揃えられた。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) と [v0.8.2 の同梱 skill](https://github.com/herdrdev/herdr/blob/v0.8.2/skills/herdr/SKILL.md) が根拠である。

### 現行構成との接点

[現行の Herdr skill](../../config/agents/skills/herdr/SKILL.md) は v0.8.0 相当の説明を残しており、v0.8.2 の同梱 skill と比べると `agent_not_ready` の説明と blocked 中の `agent prompt` 拒否の説明がない。
この skill は Home Manager を通じて `.agents`、`.claude/skills`、`.cursor/skills` へ配布されるため、古い記述が複数の Agent から参照される。

### 採用優先度

P0 である。
操作を実行するコードではないが、Agent が v0.8.2 の失敗コードを誤解し、blocked 中に prompt を繰り返す原因になる。

### 導入時の具体的な変更候補

`config/agents/skills/herdr/SKILL.md` を [v0.8.2 の skill](https://github.com/herdrdev/herdr/blob/v0.8.2/skills/herdr/SKILL.md) と同期する。
差分は現行ファイルでは `agent start` の `agent_not_ready` 説明と `agent prompt` の `agent_blocked` 説明が中心であり、既存の local safety rule を残したまま適用できる。

### 見送り理由または注意点

Herdr binary を 0.8.2 相当に切り替える前に skill だけ更新すると、まだ存在しない失敗コードを説明することになる。
binary の build または switch と skill 更新を同じ変更単位で検証する。

## Qwen Code の検出と native session restore

### v0.8.2 の事実

v0.8.2 は Qwen Code の idle、working、user-confirmation 状態を検出し、native session restore を追加した。
Qwen の integration は session identity だけを報告し、lifecycle state は screen manifest が判定する。
[Qwen manifest](https://github.com/herdrdev/herdr/blob/v0.8.2/src/detect/manifests/qwen.toml)、[Qwen integration ドキュメント](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/integrations.mdx)、および [v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) が根拠である。

`herdr integration install qwen` は `~/.qwen`（または `QWEN_HOME`）へ SessionStart hook を配置し、保存した session ID を `qwen --resume <id>` で復元する。
integration が復元するのは session identity であり、Qwen の lifecycle hook が Herdr の state authority になるわけではない。
[Qwen integration asset](https://github.com/herdrdev/herdr/blob/v0.8.2/src/integration/assets/qwen/herdr-agent-session.sh) にもその境界がある。

### 現行構成との接点

リポジトリ内に Qwen の binary、設定、hook、`rows_by_agent.qwen` の宣言はない。
現在の [Nix work package](../../nix/nix-darwin/home-manager/packages/work.nix) は Claude Code を追加し、[Herdr 設定](../../config/herdr/config.toml) は Claude と Codex の行だけを上書きしている。

### 採用優先度

P2 である。
Qwen Code を常用する予定が生じた場合には P1 へ上げるが、現在の Claude と Codex 中心の構成へ先回りして追加する理由はない。

### 導入時の具体的な変更候補

Qwen を導入する場合は、次の順で試す。

1. Qwen Code 本体を PATH に置く。
2. `herdr integration install qwen` を実行し、`herdr integration status` で integration version 1 を確認する。
3. `herdr agent start qwen-agent --kind qwen --pane <pane_id>` で新規起動を試す。
4. Herdr server の再起動後に `qwen --resume <id>` が使われることを確認する。
5. 必要なら `rows_by_agent.qwen` を追加し、既存の Claude および Codex 行と表示密度を揃える。

### 見送り理由または注意点

Qwen の hook は Herdr 管理下の `~/.qwen/settings.json` を変更するため、将来 Nix または別の dotfiles で Qwen 設定を管理する場合は所有権を分ける。
screen manifest が状態を判定するため、確認画面の表示形式を Qwen 側で変更したときは `herdr agent explain` で idle、working、blocked の判定を検証する。

## Agent 状態を symbols で表示する設定

### v0.8.2 の事実

`ui.status_indicators = "symbols"` は blocked、working、done、idle、unknown を色だけでなく異なる静的記号でも表示する。
この設定は spinner animation を有効にせず、状態ごとの形を固定する。
[v0.8.2 の configuration](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx) と [config reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json) が仕様を示す。

### 現行構成との接点

現行の Agent 行は `state_icon` を先頭に置き、Claude と Codex へ context、branch、PR 状態を表示する。
広い `sidebar_width = 72` を持つため、記号を追加しても行幅の余裕がある。
[現行の Agent rows](../../config/herdr/config.toml) を参照する。

### 採用優先度

P1 である。
レビュー待ちの blocked と作業中の working を色覚に依存せず区別できるため、現在の複数 Agent 構成に直接効く。

### 導入時の具体的な変更候補

まず次の一行を試す。

```toml
[ui]
status_indicators = "symbols"
```

Claude、Codex、worktree の各行を確認し、表示記号が Nerd Font と現行 Catppuccin Latte theme で読めることを確認する。

### 見送り理由または注意点

記号の意味は Herdr の state と色に依存し、独自の `state_icon` 画像を設定する機能ではない。
記号が細い端末フォントで読めなければ `dots` に戻す。

## Outer terminal window title

### v0.8.2 の事実

Herdr は `ui.window_title` を通じて、Herdr が動作する外側の terminal title を session と同期する。
`{hostname}`、`{workspace}`、`{tab}`、`{pane}`、`{terminal_title}` を使え、既定値は `{hostname}: {workspace}` である。
[v0.8.2 の configuration](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx) と [window title source](https://github.com/herdrdev/herdr/blob/v0.8.2/src/config/window_title.rs) が根拠である。

### 現行構成との接点

現行の [WezTerm 設定](../../config/wezterm/wezterm.lua) は window frame と tab bar の見た目を設定するが、Herdr の workspace と tab を外側 title に組み込む設定は持たない。
Herdr の `config.toml` にも `window_title` はない。
v0.8.2 相当 binary の既定値だけで host と workspace が表示される可能性があるため、現時点で必須の設定変更ではない。

### 採用優先度

P2 である。
workspace だけでなく tab 名まで外側の tab bar で判別したい場合に追加する。

### 導入時の具体的な変更候補

tab 名を含める場合は、次のように明示する。

```toml
[ui]
window_title = "{hostname}: {workspace} / {tab}"
```

まず default title の表示を確認し、WezTerm の tab title と Herdr の inner pane title が重複するときだけ token を調整する。

### 見送り理由または注意点

title は Herdr server が動作する host を表示するため、`herdr --remote` では接続元ではなく pane が走る host が表示される。
空文字なら外側 title を変更せず、描画結果は 200 文字に制限される。

## tab bar 右側の status entries

### v0.8.2 の事実

`ui.tab_bar_right` は、zoom、hostname、datetime、literal text、非同期 command output を tab bar 右端へ順序付きで表示する。
command は server 上で実行され、前回成功した最終行を表示し、失敗、空出力、timeout では値を消す。
[v0.8.2 の configuration](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx) と [tab bar source](https://github.com/herdrdev/herdr/blob/v0.8.2/src/config/tab_bar.rs) が interval および timeout の制約を定義する。

### 現行構成との接点

現行は下配置 tab bar を使い、Agent 行と Space 行へ branch、git diff、PR、dev server、review request を表示している。
これらの値は既存スクリプトが `report-metadata` で Herdr へ報告しており、tab bar 右側へそのまま流用できる stdout script はない。
[現行の metadata updater](../../nix/nix-darwin/home-manager/services/herdr.nix) と [current Herdr config](../../config/herdr/config.toml) が接点である。

### 採用優先度

P2 である。
sidebar を閉じた状態でも host や時刻を見たい場合には有効だが、既存の sidebar metadata と同じ情報を二重表示しやすい。

### 導入時の具体的な変更候補

まず Herdr 内蔵値だけを追加し、表示密度を確認する。

```toml
[ui]
tab_bar_right = [
  { type = "hostname" },
  { type = "datetime", format = "%H:%M" },
]
tab_bar_right_separator = "  "
```

branch や dev server を追加する場合は、現在の metadata reporter とは別に、現在の Herdr context で一行だけを stdout へ出す短い script を作り、`interval_seconds` と `timeout_seconds` を設定する。

### 見送り理由または注意点

command は Herdr server host の環境と active workspace、tab、pane context で実行される。
`gh` や Git のような遅い command を短い interval で呼ぶと、表示の更新失敗が増えるため、既存 launchd updater の周期をそのまま tab bar command に移さない。
狭い tab bar では status area が tab と controls に譲るため、現在の下配置と `hide_tab_bar_when_single_tab` の組み合わせで確認する。

## tab 移動と一打鍵 pane resize

### v0.8.2 の事実

`keys.move_tab_previous` と `keys.move_tab_next` は active tab を前後へ移動し、端まで行くと反対端へ wrap する。
`keys.resize_pane_left`、`down`、`up`、`right` は resize mode に入らず focused pane を一打鍵で調整する。
いずれも既定では unset である。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) と [config reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json) が根拠である。

### 現行構成との接点

現行は `prefix+r` の resize mode、`prefix+tab` の pane cycle、および custom command 用の `prefix+d`、`g`、`p`、`t` を使う。
v0.8.2 の既定 key map では `prefix+shift+h/j/k/l` が pane swap に割り当てられるため、resize 用の未使用キーとはみなせない。
tab の並び替え binding と、resize mode を使わずに pane を調整する binding は現行設定にない。
[現行 key 設定](../../config/herdr/config.toml) で衝突を確認できる。

### 採用優先度

P2 である。
worktree ごとに agent、editor、diff の tab を作る現行運用では tab 並び替えに用途があるが、既存 resize mode でも目的は達成できる。

### 導入時の具体的な変更候補

pane swap の既定 binding と衝突しない modifier を仮割当して、`herdr config check` と terminal 実機で確認する。

```toml
[keys]
move_tab_previous = "prefix+shift+left"
move_tab_next = "prefix+shift+right"
resize_pane_left = "prefix+alt+h"
resize_pane_down = "prefix+alt+j"
resize_pane_up = "prefix+alt+k"
resize_pane_right = "prefix+alt+l"
```

これは候補であり、WezTerm が送る key sequence と現在の resize mode の操作感を確認してから固定する。

### 見送り理由または注意点

`prefix+shift+h/j/k/l` は v0.8.2 の pane swap 既定値であり、resize を同じキーへ割り当てると swap 操作を失う。
候補の `prefix+alt+h/j/k/l` は WezTerm、macOS の keyboard layout、tmux 外側の binding によって Alt が失われる可能性があるため、実機で確認する。
既存の `prefix+r` と pane swap の既定値を残し、直接 binding は必要な方向だけ導入する。

## right-click passthrough

### v0.8.2 の事実

通常の right-click を pane 内の mouse-reporting application へ渡す機能が追加された。
`ui.right_click_passthrough_modifier` で `ctrl`、`alt`、`cmd` などの modifier を指定でき、pane 単位では `herdr pane input --right-click pane` または `pane split --right-click pane` を使える。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2)、[config reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json)、および [CLI reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/cli-reference.mdx) が仕様を示す。

### 現行構成との接点

現行は Hunk の diff pane、Ziggity、Neovim、および popup terminal を使うが、right-click を Herdr menu から pane application へ渡す設定はない。
worktree picker は popup 内で fzf を使い、mouse-reporting application の right-click が必要だという記録はない。
[現行 custom commands](../../config/herdr/config.toml) と [worktree picker](../../config/herdr/scripts/worktree-fzf.fish) が接点である。

### 採用優先度

P2 である。
Hunk または Neovim の context menu を Herdr の pane menu より優先したいという実例が出たときだけ導入する。

### 導入時の具体的な変更候補

macOS の modifier として Command を使う場合は、次を試す。

```toml
[ui]
right_click_passthrough_modifier = "cmd"
```

全 pane ではなく Hunk 用 split だけに適用したい場合は、diff pane 作成 command の `pane split` に `--right-click pane` を追加する。

### 見送り理由または注意点

right-click を pane へ渡すと Herdr の pane menu を開く操作と役割が変わる。
modifier の選択は outer terminal と macOS の mouse binding に依存し、`shift` は端末が予約するため受け付けられない。

## pane 外周 border

### v0.8.2 の事実

`ui.pane_outer_borders` は split pane の外周を内部 divider とは独立して表示または非表示にする。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) と [config model](https://github.com/herdrdev/herdr/blob/v0.8.2/src/config/model.rs) が既定値と役割を示す。

### 現行構成との接点

現行は pane border、pane gap、scrollbar を明示せず、v0.8.0 で追加された `pane_scrollbars` と tab bar 下配置だけを既存メモで候補化している。
複数 pane を使う Hunk、Agent、editor の画面には外周 frame がある。
[現行 UI 設定](../../config/herdr/config.toml) に `pane_outer_borders` はない。

### 採用優先度

P3 である。
見た目の調整だけであり、現行の pane 操作や metadata 表示を改善しない。

### 導入時の具体的な変更候補

tmux に近い内側 divider を試す場合に、次を `pane_gaps = false` と組み合わせて試す。

```toml
[ui]
pane_gaps = false
pane_outer_borders = false
```

### 見送り理由または注意点

外周だけを先に消すと pane gap や divider の見え方が期待とずれる。
既存の `pane_scrollbars` 候補と同時に変えず、二つの視覚変更を分離して評価する。

## sidebar と Navigate cursor の色

### v0.8.2 の事実

`theme.custom.sidebar_bg` は desktop sidebar の背景だけを変え、`theme.custom.selection_bg` は Navigate mode の cursor row の背景を変える。
built-in theme の他の panel surface を変更せずに個別の色を指定できる。
[v0.8.2 の configuration](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx) と [config reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json) が根拠である。

### 現行構成との接点

現行は `catppuccin-latte` を固定し、sidebar を 72 桁に広げているが、`theme.custom` は指定していない。
Agent 行と Space 行の highlight を custom color で上書きする必要は、現在の設定や既存メモには記録されていない。
[現行 theme 設定](../../config/herdr/config.toml) を参照する。

### 採用優先度

P3 である。
Navigate cursor が active Space または Agent row と見分けにくい場合に限って試す。

### 導入時の具体的な変更候補

Catppuccin Latte の palette と端末背景を確認してから、次のように個別指定する。

```toml
[theme.custom]
sidebar_bg = "#e6e9ef"
selection_bg = "#ccd0da"
```

色値は例であり、実際には現行 theme の base、surface、overlay のコントラストを測って決める。

### 見送り理由または注意点

`auto_switch = false` なので現在は light/dark の自動切替を使わないが、将来 `auto_switch` を有効にすると固定色が別 theme と合わなくなる可能性がある。
色を変えても collapsed sidebar と mobile view の layout は変わらない。

## copy mode の big-word motion

### v0.8.2 の事実

copy mode に whitespace-delimited big word を移動する `B`、`E`、`W` が追加された。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) と [copy mode を含む keyboard docs](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/keyboard.mdx) が根拠である。

### 現行構成との接点

現行は copy mode の key map を上書きしていない。
既存メモが v0.7.4 の smart-case search と `n/N` を候補にしているため、`B/E/W` はその操作の補足になる。
[既存調査メモ](./herdr-customization-2026-08-05.md) を参照する。

### 採用優先度

P3 である。
設定変更なしで試せるが、長い Herdr log や alternate-screen transcript を常に copy mode で調べる運用ではない。

### 導入時の具体的な変更候補

`Ctrl+j`、`[` で copy mode に入り、`W`、`B`、`E` を日本語を含むログと英語の識別子で試す。
key map の宣言は追加しない。

### 見送り理由または注意点

big-word の境界は whitespace 基準であり、CamelCase、URL、パスを一つの識別子として扱う機能ではない。
日本語ログでは期待する単語境界と一致しない場合がある。

## headless terminal size

### v0.8.2 の事実

client が接続していない headless server は、layout と新規 pane に使う virtual terminal の既定値を 80x24 から 120x40 へ変更した。
`server.headless_cols` と `server.headless_rows` で変更できる。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) と [configuration](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx) が根拠である。

### 現行構成との接点

現行の launchd agents は Herdr CLI を呼び出して workspace の dev server、git change、review request metadata を定期更新する。
ただし headless の新規 pane を作る宣言や、80x24 が狭いという既知問題はない。
[Herdr launchd service](../../nix/nix-darwin/home-manager/services/herdr.nix) を参照する。

### 採用優先度

P3 である。
v0.8.2 相当 binary の既定値で足りるため、明示設定は headless automation の寸法を固定したい場合だけにする。

### 導入時の具体的な変更候補

headless layout を再現可能に固定する必要が出たときだけ、次を追加する。

```toml
[server]
headless_cols = 120
headless_rows = 40
```

### 見送り理由または注意点

client が attach 中は client の terminal size が authoritative であり、既存 pane の PTY size を遡って変更しない。
この設定を追加しても active binary が 0.8.1 のままなら認識されないため、先に binary の切替を確認する。

## plugin marketplace の探索改善

### v0.8.2 の事実

plugin marketplace は repository root と subdirectory の valid manifest を探索し、同じ repository の複数 plugin をまとめ、version と default-branch の exact commit を公開する。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) がこの変更を記載する。

### 現行構成との接点

現行の [`.plugins.lock`](../../config/herdr/.plugins.lock) は存在するが、Herdr custom plugin を宣言する設定や、marketplace plugin を運用する手順はリポジトリにない。
既存の worktree picker、Hunk、Ziggity、metadata updater は local config と script で実装している。

### 採用優先度

P3 である。
新しい plugin を探す必要が出るまで、marketplace の探索改善だけを理由に構成を変えない。

### 導入時の具体的な変更候補

plugin を導入するときに marketplace の manifest、version、commit を確認し、既存 script と重複しない plugin だけを選ぶ。
導入後は `.plugins.lock` を runtime state として扱うか、再現性のために追跡するかを先に決める。

### 見送り理由または注意点

marketplace の発見性が上がっても、plugin が Herdr の workspace、pane、metadata と競合しない保証にはならない。
現行の `.plugins.lock` は既存の runtime 管理方針と結び付いているため、今回の調査では変更しない。

## 設定を変えずに受けられる修正

### v0.8.2 の事実

v0.8.2 は、Unix CLI が downstream pipe の close で exit 101 を出さないこと、busy な multi-pane session で隠し pane の wakeup と全 terminal formatting を減らすこと、macOS の Chinese IME commit を pane へ届けることを修正した。
Claude Code の半円 spinner frame、alternate-screen read の不要な ANSI formatting、prefix の shifted punctuation、root-repository workspace label、hidden tab の foreground typing も修正対象である。
[v0.8.2 の changelog](https://github.com/herdrdev/herdr/blob/v0.8.2/CHANGELOG.md) の Fixed 節が一次情報である。

### 現行構成との接点

現行の diff command は `herdr ... | jq` の pipe を使い、metadata updater は Herdr CLI の JSON を読み、pane history を有効にし、Claude と Codex を並列に配置する。
`split_vertical = "prefix+|"` は shifted punctuation の修正対象に直接対応し、CJK 入力と Claude の状態表示も現行の利用方法に含まれる。
[現行設定](../../config/herdr/config.toml)、[Claude hook](../../config/claude/hooks/herdr-agent-state.sh)、および [Herdr scripts](../../config/herdr/scripts) が接点である。

### 採用優先度

P1 である。
設定を追加する機能ではないが、binary を 0.8.2 相当へ切り替えた後に、現行の prefix、CJK 入力、Claude state detection、長い read、pipe 経由の metadata updater を確認する価値がある。

### 導入時の具体的な変更候補

まず `herdr --version` が 0.8.2 相当を報告する状態を作り、次を確認する。

1. `prefix+|` が `prefix+\\` と誤認されず、現在の `split_vertical` を起動する。
2. prefix 中の IME 切替と日本語入力が pane へ届く。
3. Claude の working、blocked、idle が半円 spinner の表示中も崩れない。
4. `agent read` と `pane read` が alternate-screen transcript を読むとき、旧版より遅くならない。
5. `herdr ... | jq` を使う既存 script が pipe close で異常終了しない。

### 見送り理由または注意点

これらは release binary の修正であり、`config.toml` へ設定を足して再現する機能ではない。
アクティブ binary が 0.8.1 のままなら効果は出ず、未コミット lock の rev だけを見て反映済みと判断しない。

## Windows および graphics 関連の変更

### v0.8.2 の事実

Windows client から Linux または macOS の Herdr server へ `herdr --remote` で接続できるようになり、Windows で Cursor Agent CLI、MastraCode、Hermes Agent、Grok CLI の native integration が使えるようになった。
pane graphics も named layer、RGBA frame、pixel mouse input などの拡張を受けた。
[v0.8.2 の release notes](https://github.com/herdrdev/herdr/releases/tag/v0.8.2) が一次情報である。

### 現行構成との接点

この dotfiles は macOS の Nix-Darwin を対象とし、WezTerm、Claude、Codex、Hunk、Ziggity を中心に構成している。
Windows client や対象 integration、pane graphics API を管理する設定はない。
[Nix の system 定義](../../nix/flake.nix) と [現行 package](../../nix/nix-darwin/home-manager/packages/common.nix) を参照する。

### 採用優先度

対象外である。

### 導入時の具体的な変更候補

Windows からこの macOS server へ接続する運用を始める場合に限り、remote client の認証、socket、端末サイズを別途設計する。
今回の macOS local session には設定変更を提案しない。

### 見送り理由または注意点

release notes の Windows 安定化を macOS の Herdr 構成へ移植する必要はない。
remote を使う場合も `ui.window_title`、tab bar command、headless size は server 側の host と runtime を基準に動くため、local session と同じ表示になるとは限らない。

## 推奨する導入順序

v0.8.2 の導入で最初に確認する対象は機能追加ではなく、既存の review automation と Agent skill が新しい blocked prompt 契約に追随できるかである。

次に、Herdr の active binary を 0.8.2 相当へ build または switch し、`prefix+|`、CJK input、Claude state、alternate-screen read、pipe command を確認する。

設定追加の候補では `status_indicators = "symbols"` が最も現行の sidebar rows に近く、tab bar status、window title、tab 移動、pane resize、right-click passthrough は個別の不便が確認できたものだけを試す。

Qwen、plugin marketplace、Windows remote、pane graphics は現行構成に前提がないため、利用対象が増えた時点で別の設計として扱う。

## 参照した一次情報

- [Herdr v0.8.2 release](https://github.com/herdrdev/herdr/releases/tag/v0.8.2)
- [v0.8.2 CHANGELOG.md](https://github.com/herdrdev/herdr/blob/v0.8.2/CHANGELOG.md)
- [v0.8.2 configuration](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/configuration.mdx)
- [v0.8.2 config reference data](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/data/config-reference.json)
- [v0.8.2 agent automation](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/agent-automation.mdx)
- [v0.8.2 CLI reference](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/cli-reference.mdx)
- [v0.8.2 agents](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/agents.mdx)
- [v0.8.2 integrations](https://github.com/herdrdev/herdr/blob/v0.8.2/docs/next/website/src/content/docs/integrations.mdx)
- [v0.8.2 bundled Herdr skill](https://github.com/herdrdev/herdr/blob/v0.8.2/skills/herdr/SKILL.md)
- [v0.8.2 config model](https://github.com/herdrdev/herdr/blob/v0.8.2/src/config/model.rs)
- [v0.8.2 tab bar config](https://github.com/herdrdev/herdr/blob/v0.8.2/src/config/tab_bar.rs)
- [v0.8.2 window title config](https://github.com/herdrdev/herdr/blob/v0.8.2/src/config/window_title.rs)
- [v0.8.2 Qwen manifest](https://github.com/herdrdev/herdr/blob/v0.8.2/src/detect/manifests/qwen.toml)
- [v0.8.2 Qwen integration asset](https://github.com/herdrdev/herdr/blob/v0.8.2/src/integration/assets/qwen/herdr-agent-session.sh)
