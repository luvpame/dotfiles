# Fish プロンプト候補調査

調査日：2026-08-31

対象：Fish 4.8.1、Git 2.55.0、tracked files 424 件のこの dotfiles リポジトリ

## 結論

Git 表示の遅さは、一つの問題ではない。
Git の状態を計算する時間、計算結果を表示へ反映する時間、外部プロセスがリポジトリを変更してから再計算が始まるまでの時間が重なっている。

更新前の Pure は、Git の dirty 判定だけでも staged、unstaged、untracked を別々の Git 呼び出しで調べ、branch、stash、upstream の ahead/behind も別に調べていた。
その `_pure_prompt_git` を常駐 Fish から 8 回測ると 116–146 ms だった。
一方で `git status --porcelain=v2 --branch --show-stash` だけなら 20 回の hyperfine 測定で 30.0 ± 3.2 ms だった。
この差は、現在の不満が非同期表示だけでなく、Git 呼び出しの組み合わせにもあることを示す参考値になる。

既存の表示を最小の変更で保つため、Pure を upstream の v4.18.0 へ更新した。
Pure は 2026-02-24 の修正で dirty 判定を `git status --porcelain` 1 回にまとめ、`status.showUntrackedFiles` を尊重するようになった。
この修正の説明では、Pure のリポジトリで dirty 判定が 9.3 秒から 0.8 秒になったと報告されている。[Pure の修正コミット](https://github.com/pure-fish/pure/commit/9ffc53ed9fd8e0bbd484977956bf64a2efe6ad54)
この環境で更新後の `_pure_prompt_git` を測ると 71.27–84.25 ms、平均 76.38 ms、中央値 74.92 ms になり、更新前の 116–146 ms から短縮した。

計算中も入力可能にする現在の性質は、`fish-async-prompt` を保つ限り変わらない。
ただし、計算中は前回の Git 結果が残り、ファイル変更を監視する仕組みはない。
Git クエリを短くし、古いジョブを打ち切り、最新の結果だけを再描画する中期案が、表示の鮮度まで含めた根本対応になる。

「Pure 互換の二行表示、終了ステータス、Nix 開発シェル表示」をすべて保ったまま非同期性も得たいなら Tide が次点になる。
Hydro は小さく移行しやすいが、Nix 表示を追加実装する必要がある。
Starship は Git 機能が豊富で保守も強いが、Fish の初期化コードは prompt 呼び出しを同期実行するため、今回の stale 表示対策としては順位を下げた。
組み込み `fish_git_prompt` は依存が増えず、今回の warm 測定では 71–75 ms だったが、同期実行なので Git が遅い瞬間に入力を待たせる。

## 現行構成と遅延の分解

### 現在の設定

Fisher の追跡対象には `pure-fish/pure` と `acomagu/fish-async-prompt` が並び、設定では `async_prompt_functions` を `_pure_prompt_git` に限定している。[fish_plugins](../../config/fish/fish_plugins#L9-L10) [現行設定](../../config/fish/config.d/plugins.fish#L2-L8)

現在の Pure 設定は `pure_separate_prompt_on_error=true`、`pure_show_exit_status=true`、`pure_enable_nixdevshell=true`、Nix 記号 ` ` である。[現行設定](../../config/fish/config.d/plugins.fish#L3-L8)
`pure_enable_single_line_prompt` は既定値の `false` なので、二行表示を使っている。[Pure v4.18.0 の既定値](https://github.com/pure-fish/pure/blob/v4.18.0/conf.d/pure.fish) [Pure v4.18.0 の二行判定](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_is_single_line_prompt.fish)

調査開始時のローカル展開物は `pure_version=4.15.1-docs-fossdem-review` だったが、調査後に v4.18.0 へ更新した。[Pure v4.18.0](https://github.com/pure-fish/pure/releases/tag/v4.18.0)

### (a) Git 状態の計算時間

`_pure_prompt_git` は、リポジトリ内かを `git rev-parse` で判定した後、branch、dirty、stash、upstream の pending commits を組み合わせる。[Pure v4.18.0 の `_pure_prompt_git`](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_git.fish)

更新前の dirty 判定は `git rev-list`、`git diff-index` または `git diff --staged`、`git diff`、`git ls-files --others` を順に試していた。[Pure v4.15.1 の dirty 判定](https://github.com/pure-fish/pure/blob/v4.15.1/functions/_pure_prompt_git_dirty.fish)
更新後は `git status --porcelain --ignore-submodules` 1 回で dirty を判定する。[Pure v4.18.0 の dirty 判定](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_git_dirty.fish)
stash は `git rev-list --walk-reflogs --count refs/stash`、upstream は `git rev-parse @{upstream}` の後に `git rev-list --left-right --count` を実行する。[Pure v4.18.0 の stash 判定](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_git_stash.fish) [Pure v4.18.0 の upstream 判定](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_git_pending_commits.fish)

この構成では、untracked の探索と Git プロセスの起動回数が遅延要因になると推定できる。
Git 公式ドキュメントも、untracked ファイルを探す処理は大きな worktree で時間がかかると説明し、`status.showUntrackedFiles=no`、untracked cache、FSMonitor を選択肢として挙げている。[git-status の untracked 性能説明](https://git-scm.com/docs/git-status#_untracked_files_and_performance)

Pure upstream はこの問題に対して、dirty 判定を `git status --porcelain --ignore-submodules` 1 回にまとめ、`status.showUntrackedFiles=false` のとき untracked 探索を省けるようにした。[Pure の dirty 判定修正](https://github.com/pure-fish/pure/commit/9ffc53ed9fd8e0bbd484977956bf64a2efe6ad54)
Pure のトラブルシューティングも、大きなリポジトリでは `git config status.showUntrackedFiles false` が dirty 判定を数秒から 1 秒未満へ下げる場合があると説明している。[Pure の大規模リポジトリ向け設定](https://github.com/pure-fish/pure/blob/master/docs/components/troubleshooting.md#slowness-try-disabling-statusshowuntrackedfiles)

ただし、この設定は untracked ファイルを表示しなくするため、常用するかどうかは表示要件との交換になる。
Git 公式も `--untracked-files=no` が最速だが、新規ファイルの見落としに注意が必要だと説明している。[git-status の untracked オプション](https://git-scm.com/docs/git-status#Documentation/git-status.txt---untracked-filesltmodegt)

### (b) 非同期計算の表示反映タイミング

`fish-async-prompt` は、指定した prompt 関数を別 Fish プロセスで実行し、結果を一時ファイルへ書く。[fish-async-prompt の説明](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/README.md#description) [非同期実装](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L136-L176)

現行設定の `_pure_prompt_git` は、`fish_prompt` 自体ではなく、その一部だけを非同期対象にしている。
初期化後の `fish_prompt` は一時ファイルを読むラッパーになり、Pure の prompt がそこから `_pure_prompt_git` を呼ぶため、Git 部分だけが後から差し替わる。[ラッパーの生成](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L31-L64) [Pure v4.15.1 の prompt 呼び出し](https://github.com/pure-fish/pure/blob/v4.15.1/functions/fish_prompt.fish)

非同期処理が終わると既定の `SIGUSR1` で親 Fish に通知し、ハンドラが `commandline -f repaint` を実行する。[完了通知](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L168-L176) [再描画ハンドラ](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L348-L357)

loading indicator 関数が定義されている場合だけ計算中にその出力へ置き換える。[loading indicator の条件](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L103-L121)
現行構成には `_pure_prompt_git_loading_indicator` がないため、計算中は一時ファイルの前回結果が残ると推定できる。
初回の一時ファイルがまだない場合は Git 部分が空になり、完了後の再描画で現れる。

この仕組みは prompt の入力応答を守るが、Git 計算の完了までの時間を短縮しない。
更新前のローカル実測 116–146 ms と、更新後の 71.27–84.25 ms は、計算完了後に表示が更新されるまでの下限に近い参考値である。
さらに計算中に別の prompt が発火すると、現行ソースは前の非同期ジョブを打ち切らず、同じ一時ファイルへ各ジョブが結果を書く。[非同期ジョブの起動](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L123-L131) [一時ファイルへの書き込み](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L254-L256)
完了順によって古い計算結果が後から書かれる可能性は、ソースからの推定であり、このリポジトリでの再現確認はまだ行っていない。

### (c) 外部変更時の再描画と再計算

Fish は `fish_prompt` を新しい prompt の直前に発火し、変数更新、シグナル、ジョブ終了もイベントとして扱う。[Fish のイベントハンドラ](https://fishshell.com/docs/current/language.html#event-handlers)
`commandline -f repaint` は prompt 関数をもう一度実行するための入力関数である。[commandline の再描画機能](https://fishshell.com/docs/current/cmds/commandline.html#cmdoption-commandline-f)

`fish-async-prompt` は `fish_prompt` に加えて、既定では `fish_bind_mode` と `PWD` の更新を再計算トリガーにする。[既定の変数トリガー](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L75-L98)
Git の index、worktree、別プロセスの checkout を監視するイベントは登録していないため、別ターミナルやエディタが Git を変更して Fish が idle のままなら、表示は次の `fish_prompt` か明示的な再描画まで古いままと推定できる。
これは「Git の計算が遅い」問題とは別の更新鮮度の問題である。

### ローカル実測

起動時間は除外し、常駐する対話 Fish 内で warm-up 後に測定した。

| 対象 | 条件 | 結果 | 読み方 |
| --- | --- | --- | --- |
| `_pure_prompt_git` | 8 回、更新前の Pure | 116–146 ms/回 | dirty を複数 Git 呼び出しで判定 |
| `_pure_prompt_git` | warm-up 後 8 回、Pure v4.18.0 | 71.27–84.25 ms/回。平均 76.38 ms、中央値 74.92 ms | dirty を一つの `git status --porcelain` で判定 |
| `git status --porcelain=v2 --branch --show-stash` | hyperfine 20 回 | 30.0 ± 3.2 ms | 一つの統合クエリの参考値で、解析処理は含まない |
| 組み込み `fish_git_prompt` | dirty、untracked、stash、upstream の informative を有効化 | 71–75 ms/回 | 同期 prompt の計算時間で、非同期反映遅延は含まない |

この値はこのリポジトリ、Git 2.55.0、Fish 4.8.1、tracked files 424 件に限った測定である。
大規模な untracked tree、submodule、ネットワークファイルシステムでは順位が変わり得る。

## 候補の比較

以下の順位は「Pure の現在の表示要件を残しながら、Git 表示の stale 時間と入力待ちを減らす」軸で付けた。
各候補の Git 計算と表示反映を分け、宣伝文句ではなくソースを基準にした。

| 順位 | 候補 | Git 状態の計算 | 非同期性とキャッシュ | 更新鮮度 | 表示機能と既存要件 | 移行量と保守 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Pure 継続で更新と調整 | v4.18.0 へ更新し、dirty 判定を `git status --porcelain` 1 回へ統合済み。[upstream 修正](https://github.com/pure-fish/pure/commit/9ffc53ed9fd8e0bbd484977956bf64a2efe6ad54) | 既存の `fish-async-prompt`。一時ファイルの前回値を表示し、TTL や Git キャッシュはない。[実装](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L80-L131) | `fish_prompt`、PWD、fish_bind_mode の後に再計算。idle 中の外部変更は検知しない。 | Nix、終了ステータス、二行、Pure の色と記号をそのまま維持。[Nix](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_nixdevshell.fish) [終了ステータス](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_exit_status.fish) | 更新後の実測は平均 76.38 ms。Pure は v4.18.0 をリリース済み。[リリース](https://github.com/pure-fish/pure/releases/tag/v4.18.0) |
| 2 | Tide v6 | `_tide_item_git` が branch、operation、`git status --porcelain`、stash、ahead/behind を計算し、staged、dirty、untracked、conflicted などを数える。[Git item](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/_tide_item_git.fish#L1-L72) | `fish_prompt` 内で別 Fish を background 実行し、PID を保存して前のジョブを kill。PID ごとの universal variable に最後の結果を置くが、Git の TTL キャッシュではない。[prompt 実装](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/fish_prompt.fish#L10-L20) [background 実装](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/fish_prompt.fish#L66-L88) | 結果変数の更新で即時 repaint。PWD や Git の外部変更を監視する watcher はソース上ない。 | `nix_shell`、status、二行 `newline`、多数の Git カウントを標準 item で持つ。[Nix item](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/_tide_item_nix_shell.fish#L1-L2) [status item](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/_tide_item_status.fish#L1-L14) [二行 lean 設定](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/tide/configure/configs/lean.fish#L54-L61) | Pure の外観を wizard と item 設定で再構成するため中から大。v6.2.0 の安定タグはある。[README](https://github.com/IlanCosman/tide/blob/v6.2.0/README.md#asynchronous-rendering) [リリース](https://github.com/IlanCosman/tide/releases/tag/v6.2.0) |
| 3 | Hydro | branch、`git diff-index`、untracked 用 `git ls-files`、upstream の `git rev-list` を background Fish で実行。[Hydro source](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L60-L103) | `_hydro_git_$fish_pid` を universal variable として更新し、変数イベントで repaint。新しい prompt のたびに前の PID を kill する。TTL やファイル変更キャッシュはない。[variable repaint](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L3-L7) [前ジョブの停止](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L60-L68) | `fish_prompt` ごとに再計算し、結果変数の更新後に反映。idle 中の外部変更は検知しない。 | branch、dirty、ahead/behind、command duration、pipestatus、`hydro_multiline` がある。[README](https://github.com/jorgebucaran/hydro/blob/main/README.md#features) [設定](https://github.com/jorgebucaran/hydro/blob/main/README.md#configuration) Nix item はなく、Nix 表示は custom prompt が必要。 | 1 plugin と少数の変数で移行できるが、Pure の Nix、色、細かな Git 表示は失う。2026-02-23 に source commit がある。[最新 source commit](https://github.com/jorgebucaran/hydro/commit/f130b55ee3eaf099eccf588e2a62e5447068d120) |
| 4 | Starship | Git status は既定で gitoxide の in-process status を使い、条件によって `git status --porcelain=2` を使う。ahead/behind、stash、各種 staged、modified、untracked を扱う。[Git status source](https://github.com/starship/starship/blob/v1.26.0/src/modules/git_status.rs#L329-L427) | Fish init は `::STARSHIP:: prompt` を foreground で呼ぶため、Fish から見た prompt は同期。Git status の static cache は一回の starship プロセス内で module 間共有されるだけで、prompt 間の永続キャッシュではない。[Fish init](https://github.com/starship/starship/blob/v1.26.0/src/init/starship.fish#L1-L70) [process-local cache](https://github.com/starship/starship/blob/v1.26.0/src/modules/git_status.rs#L300-L321) | stale 表示は避けられるが、計算中は入力が prompt を待つ。`command_timeout` 既定 500 ms で遅い処理を打ち切り、Git 表示が欠落することがある。[設定](https://starship.rs/config/#prompt) [timeout FAQ](https://starship.rs/faq/#why-do-i-see-executing-command--timed-out-warnings) | `nix_shell`、status、pipestatus、`line_break`、Git の詳細な count と format を持つ。[Nix](https://starship.rs/config/#nix-shell) [status](https://starship.rs/config/#status) [Git status](https://starship.rs/config/#git-status) | binary、Fish init、`starship.toml` の移行が必要。v1.26.0 と継続的な main の更新があり、保守は強い。[Fish guide](https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship) [リリース](https://github.com/starship/starship/releases/tag/v1.26.0) |
| 5 | Fish 組み込み `fish_git_prompt` | Fish 4.8.1 版は `rev-parse`、`git config`、`git status --porcelain`、`ls-files`、`rev-list` などを必要な表示モードに応じて同期実行。[Fish source](https://github.com/fish-shell/fish-shell/blob/4.8.1/share/functions/fish_git_prompt.fish#L215-L332) | 非同期処理も Git 結果キャッシュもない。 | 変更直後の同期結果を表示するが、Git が遅い間は prompt を待たせる。 | branch、dirty、staged、untracked、stash、upstream、operation、informative の各表示を変数で細かく設定できる。[公式ドキュメント](https://fishshell.com/docs/current/cmds/fish_git_prompt.html) Nix、Pure の終了ステータス、二行レイアウトは自前 `fish_prompt` が必要。 | 追加 plugin は不要だが、Pure と同じ表示を再現する設定量は大きい。Fish 本体の 4.8.1 が保守する。[Fish 4.8.1](https://github.com/fish-shell/fish-shell/releases/tag/4.8.1) |

### 候補ごとの読み方

#### Pure を継続する

短期の費用対効果が最もよい。
ローカル版を v4.18.0 へ更新し、`_pure_prompt_git_dirty` が `git status --porcelain` を使うことを確認した。
Pure の upstream ドキュメントも大規模リポジトリでは `status.showUntrackedFiles` の無効化と `fish-async-prompt` の併用を案内している。[Pure の大規模リポジトリ対策](https://github.com/pure-fish/pure/blob/master/docs/components/troubleshooting.md)

この案では `pure_enable_nixdevshell` の `IN_NIX_SHELL` 判定、`pure_show_exit_status` の pipeline status、`pure_separate_prompt_on_error`、二行表示を失わない。[Pure の Nix 判定](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_nixdevshell.fish) [Pure の終了ステータス](https://github.com/pure-fish/pure/blob/v4.18.0/functions/_pure_prompt_exit_status.fish) [Pure の prompt](https://github.com/pure-fish/pure/blob/v4.18.0/functions/fish_prompt.fish)

ただし、upstream の dirty 判定を取り込んでも stash と upstream の Git 呼び出しは残る。
今回の 30 ms の統合クエリまで下げるには、Pure の Git backend を置き換える中期作業が必要になる。

#### Hydro

Hydro は source が短く、計算処理と repaint の因果が読みやすい。
Git 計算を background に回し、前の PID を kill するため、連続して Enter を押したときに古いジョブが後から結果を上書きするリスクを Pure 現行版より抑えやすい。[Hydro の background 処理](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L60-L103)

一方で、Hydro README の LLVM での `time fish_prompt` は foreground の prompt 関数を測った値である。
Git 処理は background にあるため、Git の完了時間や更新鮮度の証拠には使えない。[Hydro の性能例](https://github.com/jorgebucaran/hydro/blob/main/README.md#performance) [Hydro の Git background source](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L68-L103)

`hydro_multiline=true` で prompt 記号を別行へ置けるが、Pure の二行の色や構造とは同一ではない。
`IN_NIX_SHELL` の表示処理は source と設定表にないため、Nix 記号を残すには custom function を追加する必要がある。[Hydro の設定](https://github.com/jorgebucaran/hydro/blob/main/README.md#configuration)

#### Tide

Tide は今回の要件を最も多く標準 item で持つ。
lean 設定は `pwd git newline character` を左に置き、右に `status` と `nix_shell` などを置くため、二行と Nix 表示を構成しやすい。[Tide lean 設定](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/tide/configure/configs/lean.fish#L54-L101)

Git item は Pure の単一 dirty 記号より多くの状態を数える。
その分、Git 状態の計算量が小さくなるとは断定できない。
非同期性によって入力待ちは避けられるが、表示が最新になるまでの時間は `git status`、stash、rev-list の実行時間に依存する。[Tide Git item](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/_tide_item_git.fish#L45-L72)

Tide の prompt は結果変数を universal にし、変数更新の event handler で repaint する。
古い background PID を kill するため、最新の directory で計算する設計になっている。[Tide prompt refresh](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/fish_prompt.fish#L10-L20) [Tide background job](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/fish_prompt.fish#L66-L88)

#### Starship

Starship の Git backend は Rust と gitoxide を使い、必要な状態を一回の status 計算から各 module が共有する。
`command_timeout` と module timing があるため、原因調査はしやすい。[Starship Git source](https://github.com/starship/starship/blob/v1.26.0/src/modules/git_status.rs#L192-L376) [Starship timings](https://starship.rs/faq/#starship-is-doing-something-unexpected-how-can-i-debug-it)

しかし Fish 初期化コードは `starship prompt` を `&` なしで呼ぶ。
Hydro や Tide のように前回値を描画してから後で repaint する設計ではないため、Git 表示の鮮度と入力待ちを同時には解決しない。[Starship Fish init](https://github.com/starship/starship/blob/v1.26.0/src/init/starship.fish#L18-L45)

`nix_shell` は `IN_NIX_SHELL` の `pure`、`impure` を判定し、`status` は pipeline の各 exit code を設定できる。[Starship Nix source](https://github.com/starship/starship/blob/v1.26.0/src/modules/nix_shell.rs#L1-L83) [Starship status source](https://github.com/starship/starship/blob/v1.26.0/src/modules/status.rs#L1-L85)
二行表示は `format` と `line_break`、終了表示は `[status] pipestatus=true` の設定へ移すため、Pure の変数をそのまま移せない。[Starship prompt format](https://starship.rs/config/#prompt) [Starship status 設定](https://starship.rs/config/#status)

#### Fish 組み込み `fish_git_prompt`

Fish の組み込み関数は追加 plugin を増やさずに branch、dirty、staged、untracked、stash、upstream、merge operation を表示できる。[fish_git_prompt の公式ドキュメント](https://fishshell.com/docs/current/cmds/fish_git_prompt.html)

informative status は dirty ファイル数、untracked 数、upstream 差分などを計算するため、大きなリポジトリでは遅くなると公式に明記されている。[大規模リポジトリでの注意](https://fishshell.com/docs/current/cmds/fish_git_prompt.html#description)
今回の 71–75 ms は Pure 現行版より短いが、同期処理なので idle 中の古い表示を作らない代わりに、毎回その時間を prompt が負担する。

## 要件の維持

| 要件 | Pure 継続 | Tide | Hydro | Starship | `fish_git_prompt` 単体 |
| --- | --- | --- | --- | --- | --- |
| `IN_NIX_SHELL` 記号 | 現行のまま | `nix_shell` item で可能。記号と表示文は再設定 | 標準 item なし。custom が必要 | `nix_shell` で可能。`pure`、`impure` の表現を設定 | custom が必要 |
| 終了 status と pipeline | 現行のまま | `status` item が pipeline を表示。記号と信号名は再設定 | `$pipestatus` を表示。Pure と failure 条件が異なる | `[status]` で `pipestatus=true` を設定 | custom が必要 |
| 二行 prompt | 現行のまま | `newline` item で構成 | `hydro_multiline=true` | `line_break` を format に置く | custom が必要 |
| Git branch、dirty、stash、ahead/behind | 現行のまま。upstream 更新で dirty だけ改善 | 標準で詳細。計算量は増える | dirty と upstream は標準。stash、細かな count はない | 標準で詳細。timeout で欠落し得る | 変数設定で可能。同期計算 |
| idle 中の外部 Git 変更 | 現行と同じ。watcher なし | watcher なし | watcher なし | 次の同期 prompt まで再計算しない | 次の同期 prompt まで表示されない |

## 推奨する進め方

### 実施した短期案

1. Pure を v4.18.0 へ更新し、`_pure_prompt_git_dirty` が `git status --porcelain` を使うことを確認した。[Pure v4.18.0](https://github.com/pure-fish/pure/releases/tag/v4.18.0) [dirty 判定の upstream 修正](https://github.com/pure-fish/pure/commit/9ffc53ed9fd8e0bbd484977956bf64a2efe6ad54)
2. `fish-async-prompt` と `set -g async_prompt_functions _pure_prompt_git` は維持する。
3. 大きなリポジトリだけで untracked 表示を不要と判断できるなら、`git config status.showUntrackedFiles false` を試す。
4. `status.showUntrackedFiles` を無効にすると `?` 表示を失うため、採用前後で untracked の見落としが許容できるか確認する。[Git の注意](https://git-scm.com/docs/git-status#Documentation/git-status.txt---untracked-filesltmodegt)
5. 計算中の古い値を明示したい場合は `_pure_prompt_git_loading_indicator` を追加できるが、これは見た目を変えるだけで計算時間は短くしない。[indicator の仕様](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/README.md#loading-indicator)

この案は既存の Nix、終了 status、二行表示を壊さない。
upstream 修正がこのリポジトリの実測でも効けば、設定変更一行より小さな移行で遅延を下げられる。

### 根本的な中期案

Pure の外観を残した小さな Git worker を作り、Git 公式が機械解析用に定義している porcelain v2 の情報を一回で取得する。
候補コマンドは `git --no-optional-locks status --porcelain=v2 --branch --show-stash` である。
porcelain v2 は branch、ahead/behind、stash、変更エントリを安定したヘッダと形式で返す。[Git porcelain v2](https://git-scm.com/docs/git-status#_porcelain_format_version_2)

worker には次の性質を持たせる。

- `fish_prompt` と `PWD` から起動し、前回の結果を直ちに表示する。
- 起動ごとに generation または PID を割り当て、古い計算を打ち切る。
- 完了時は最新 generation だけを変数へ格納し、`commandline -f repaint` を一度だけ発火する。
- `IN_NIX_SHELL`、`pipestatus`、Pure の記号と二行配置はメイン prompt 側で同期的に組み立てる。
- untracked を表示するかどうか、submodule を無視するかどうかを設定で明示する。

この構成なら、今回 30 ms と測った統合クエリを基礎にしながら、非同期表示と stale 結果の扱いを制御できる。
ただし、porcelain parser、rename、conflict、bare repo、未 commit の `git init`、同時実行をテストする必要がある。
ファイル監視まで必要なら Fish の prompt event だけでは足りず、外部 watcher か、Git 操作を行う wrapper から明示的に repaint を発火する設計を追加する。

保守コストを自分で持ちたくない場合は、Tide を v6.2.0 のタグから導入し、既存の Pure 設定を Tide の item 設定へ移すのが現実的な中期案になる。
Hydro は prompt を軽く保ちたい場合に向くが、Nix 表示の custom 部分を別途保守する必要がある。

## 比較検証のベンチマーク

### 計算時間

起動込みの測定は候補の prompt 初期化コストを混ぜるため、今回の不満を比較する第一指標にはしない。
各候補を同じ常駐 Fish に読み込み、warm-up 後に次を測る。

```fish
for i in (seq 8)
    time _pure_prompt_git >/dev/null
end
```

Git 単体は `hyperfine --warmup 5 --runs 20 'git status --porcelain=v2 --branch --show-stash'` のように同じ worktree で測る。

候補ごとに Git 表示関数を同じ表示要件へ合わせ、branch、dirty、staged、untracked、stash、ahead/behind の有無を揃える。
Starship の場合は `env STARSHIP_LOG=trace starship timings` も記録し、Git module 以外の遅延を分離する。[Starship timing の公式手順](https://starship.rs/faq/#starship-is-doing-something-unexpected-how-can-i-debug-it)
Fish 自体は `--profile` で関数と command substitution の時間を記録できる。[Fish の profiler](https://fishshell.com/docs/current/language.html#profiling-fish-scripts)

測定ケースは次の三つに分ける。

1. clean worktree
2. tracked file の staged、unstaged、rename、conflict
3. ignored を含む大きな untracked tree、submodule、upstream あり

`git status --porcelain=v2 --branch --show-stash` 単体も同じケースで測り、prompt 関数のオーバーヘッドと Git 自体の時間を分ける。
Hydro と Tide の `fish_prompt` は background を起動するだけなので、`time fish_prompt` だけで Git 完了時間を評価しない。[Hydro の background source](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L60-L103) [Tide の background source](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/fish_prompt.fish#L66-L88)

### 表示反映時間

同じ tracked file を外部プロセスで変更し、変更開始時刻から prompt の表示が新しい記号へ変わる時刻までを測る。
P50、P95、最大値を記録し、入力待ち時間と Git 結果の stale 時間を別列にする。

非同期候補では、worker の起動、Git コマンド完了、一時値の書き込み、repaint を別々に timestamp する。
`fish-async-prompt` は SIGUSR1 と `commandline -f repaint` の経路を持つため、ここを計測点にできる。[SIGUSR1 と repaint](https://github.com/acomagu/fish-async-prompt/blob/v1.3.0/conf.d/__async_prompt.fish#L348-L357)

Hydro と Tide は結果 variable の更新を計測点にする。[Hydro の variable event](https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish#L3-L7) [Tide の variable event](https://github.com/IlanCosman/tide/blob/v6.2.0/functions/fish_prompt.fish#L16-L20)
Starship と `fish_git_prompt` は同期なので、prompt 呼び出しの wall time と表示更新時刻がほぼ同じになる。

### 外部変更の鮮度

Fish の prompt を idle にしたまま、別プロセスで tracked file を変更、stash、checkout する。
何秒経っても表示が変わらないこと、Enter、`cd`、`commandline -f repaint` のどれで更新されることを個別に確認する。
このテストはファイル watcher を持たない候補の制約を可視化する。[Fish の標準イベント一覧](https://fishshell.com/docs/current/language.html#event-handlers)

合格基準は、表示が速いことだけにしない。
Git の状態が変わった後に古い表示が残る時間、連続実行で古い結果が逆戻りしないこと、Nix 表示、pipeline の終了 status、二行レイアウトが維持されることを同時に確認する。

## 参考資料と保守スナップショット

2026-08-31 時点で確認した公式 release と source の目安は次の通りである。

| プロジェクト | 確認した版または source | 保守状況の読み方 |
| --- | --- | --- |
| Pure | v4.18.0、dirty 判定修正コミットあり | ローカル版も v4.18.0 へ更新済み。更新後の実測は平均 76.38 ms。[release](https://github.com/pure-fish/pure/releases/tag/v4.18.0) |
| fish-async-prompt | v1.3.0 | v1.3.0 が公開されている。レビューした実装には timeout、TTL、Git watcher がない。[release](https://github.com/acomagu/fish-async-prompt/releases/tag/v1.3.0) |
| Hydro | main の 2026-02-23 commit | 小さな source と継続更新がある。機能は絞られる。[commit](https://github.com/jorgebucaran/hydro/commit/f130b55ee3eaf099eccf588e2a62e5447068d120) |
| Tide | v6.2.0、main の 2025-11-25 commit | 安定タグがあり、機能と設定項目が多い。導入後は v6 タグを固定する。[release](https://github.com/IlanCosman/tide/releases/tag/v6.2.0) [main の commit](https://github.com/IlanCosman/tide/commit/fcda500d2c2996e25456fb46cd1a5532b3157b16) |
| Starship | v1.26.0、main の 2026-08-30 commit | 大規模で更新頻度が高い。設定と binary の保守範囲も大きい。[release](https://github.com/starship/starship/releases/tag/v1.26.0) [main の commit](https://github.com/starship/starship/commit/cc763c5557a235530ff00c8917169bb77aac1e24) |
| Fish | 4.8.1 | 組み込み prompt の保守を Fish 本体へ委ねられる。[release](https://github.com/fish-shell/fish-shell/releases/tag/4.8.1) |
