---
name: pr-review-orchestrator
description: レビュー依頼が来ているPRを検知し、Herdrタブ + worktrunk worktree + Claude Codeで敵対的コードレビューを並列実行・監視し、PRがマージ・クローズまたは自分がapprove済みになった worktree を自動で片付けるオーケストレーターになる
disable-model-invocation: true
---

# PR Review Orchestrator

このスキルを読んだエージェントがオーケストレーターになる。ウォッチャー（Monitor）が新規のレビュー依頼PRを通知するたびにスイープ→レビュー起動→監視を行い、停止指示があるまで続ける。オーケストレーターは専用 workspace（ラベル `pr-review`）で動く。PR workspace は herdr の仕様上 repo のメイン workspace（shogun）配下にネストされる（[[herdr-workspace-nesting-by-repo]]）。

## レビュー結果の扱い

レビューは読み取り専用で行う。レビューエージェントは結果をオーケストレーターへ返し、オーケストレーターはユーザーへ報告する。

GitHub の PR、レビュー、コメント、issue には書き込まない。`gh pr comment`、`gh pr review`、`gh api` による更新、ブラウザからの投稿を含む外部サービスへの書き込みは実行しない。

## 環境の制約（先に読む）

- herdr CLI の構文と安全規則は herdr スキルが正。未読なら Skill ツールで先に読む。
- Monitor と TaskStop はホストのエージェント実行環境が提供する永続タスク API を使う。この二つを利用できない環境では開始せず、その制約を報告して終了する。CLI の JSON フィールド名は実行時の `herdr` 出力を正とする。
- gh と wt はサンドボックス内では動かない（keychain のトークンに触れず TLS も通らない。`sandbox.network.allowedDomains` 許可でも不十分）。このスキルはサンドボックス無効のセッションで動かす前提。前提確認の `gh pr list` が TLS エラーになったら、`api.github.com` と `github.com` のネットワーク許可に加えてサンドボックス無効のセッションが必要だと報告して止まる。
- `wt switch` の post-start フック（[[worktree-devenv-setup]]、実体は dotfiles の `config/worktrunk/config.toml`）は `herdr worktree open --cwd <primary> --path <worktree> --focus` を実行し、worktree 専用の herdr workspace を生成する。実行した pane では cd されず、`--no-cd` でもフックは走る。
- ただし **worktree が既に存在すると `wt switch` はこのフックを走らせない**（`✓ Created worktree` ではなく `○ Switched to worktree` で終わる）。workspace はできない。したがって workspace をフック任せにせず、worktree パスで照合して無ければ自分で `herdr worktree open` を叩く（「レビュー起動」step 3）。**`herdr workspace create` で代用しない**。それで作った workspace は JSON に `worktree` キーごと付かず、`worktree.checkout_path` を頼る残骸回収が worktree パスを引き戻せなくなる。
- フックが生成するタブ構成は一定でない。dotfiles 側でフックが編集されうるため、root pane 1枚のときも `agent review` / `editor` / `diff` 相当が最初から生えているときもある。タブを足す前に必ず `herdr tab list --workspace <id>` で既存構成を確認する。しないと重複タブができる。
- state ファイルを消すときは `unlink <ファイル>` を使う。`rm` は guard-and-guide のフックが禁止している。リネーム退避のような回避策は取らない（ゴミが残り、次セッションの残骸回収を汚す）。ディレクトリごと消す必要が出たら削除コマンドをユーザーへ提示して実行してもらう。
- `claude` を引数なしで起動すると FleetView（セッション一覧UI）が開き、`agent prompt` がタスク作成ボックスに吸われてストールする。herdr から起動するときは初期プロンプトを argv で渡して直接セッションを開く（例: `-- "準備完了とだけ返して"`）。スラッシュコマンドは argv だとテキスト扱いされるので、起動後に idle または done を待ってから `agent prompt` で送り、Enter を追い打ちする（「レビュー起動」step 8）。

## 初回セットアップ

1. 前提確認。欠けたら原因を報告して終了する:
   - 自セッションのモデルが opus であること（システムプロンプトの記載で判断する）。オーケストレーターは自分のモデルを変えられないので、opus 以外なら `claude --model opus` での起動し直しを案内して終了する
   - `test "${HERDR_ENV:-}" = 1`
   - `git rev-parse --show-toplevel`（リポジトリ内で動いている）
   - `wt --version`
   - `gh pr list --limit 1` が成功（TLS エラーなら上記 `sandbox.network.allowedDomains` とサンドボックス無効を案内する）
   - `gh api user --jq .login` の出力を `<me>` として固定する（片付けの判断が自分のレビュー状態を引くのに使う）
2. 専用 workspace へ移る: `herdr pane current --current` で現在の workspace ID を得て、`herdr workspace list` からそのラベルを照合する。ラベルが `pr-review` なら現在の pane ID を `<orchestrator pane>` とする。そうでなければ、`herdr pane move "$HERDR_PANE_ID" --new-workspace --label "pr-review" --tab-label "orchestrator" --no-focus` で自分ごと引っ越す（プロセスは生きたまま移動する）。以後は move の JSON にある `result.move_result.pane.pane_id` を `<orchestrator pane>` として使う。
3. 自セッションの scratchpad ディレクトリ（システムプロンプト記載）に `<scratchpad>/pr-review-orchestrator/<orchestrator pane>` を state ディレクトリとして作り、パスを以後の `<state>` として固定する。`launched.txt`（起動済みまたは失敗済みのPR番号、1行1件）と `seen.txt`（ウォッチャー通知済みPR番号、1行1件）を touch する。作成後に `<state>` をユーザーへ一度報告する。
4. 前セッションの残骸を回収する。`<state>` はセッションごとの scratchpad 配下にあり前回のものは引き継がれないので、環境そのものを走査する: `herdr workspace list` でラベルが `pr#<番号>` の workspace を全部挙げ、`worktree.checkout_path` を `<state>/worktree-pr<番号>` に書き戻してから、1件ずつ「片付けの判断」の分岐に載せる（state と approve はそこで引くので、ここでは判断のための `gh pr view` を叩かない）。`worktree` キーを持たない workspace（過去に `herdr workspace create` で作られた残骸）は checkout_path を引けないので、`gh pr view <番号> --json headRefName` でブランチを求め、「レビュー起動」step 2 と同じ `git worktree list --porcelain` からパスを引く。**引いたパスも同じく `<state>/worktree-pr<番号>` に書く**（「片付けの実行」step 3 がこのファイルしか読まない）。残った分は一覧にしてユーザーへ報告する。該当 workspace が無ければ何もしない。
5. ウォッチャーを起動する（次節）。初回ポーリングは即時に走るので、既存のレビュー依頼PRも起動直後の NEW_PR 通知として届く。

完了基準: 前提5点がすべて成功し、自分が `pr-review` workspace におり、state ディレクトリのパスが確定し、既存の `pr#<番号>` workspace を全件仕分け済みで、ウォッチャーが走っていること。

## ウォッチャー（スイープのトリガー）

Monitor ツールで一度だけ起動する（`persistent: true`、description は「レビュー依頼PRの検知」等）。返却された task ID を `<state>/watcher-task-id` に記録する。2種類の通知を1行1件で出力する。`NEW_PR <番号>` が届いたらスイープを、`GONE_PR <番号>` が届いたら「片付けの判断」を実行する:

```bash
touch <state>/seen.txt <state>/launched.txt
while :; do
  if open=$(gh pr list --search "review-requested:@me" --state open --json number --jq '.[].number' 2>/dev/null); then
    printf '%s\n' "$open" | sed '/^$/d' | sort -n > <state>/poll.txt
    new=$(grep -vxFf <state>/seen.txt <state>/poll.txt)
    if [ -n "$new" ]; then
      echo "$new" | sed 's/^/NEW_PR /'
      echo "$new" >> <state>/seen.txt
    fi
    gone=$(grep -vxFf <state>/poll.txt <state>/launched.txt)
    [ -n "$gone" ] && echo "$gone" | sed 's/^/GONE_PR /'
  fi
  sleep 300
done
```

`poll.txt` の更新は `gh` の成功時だけに限る。失敗した回の空リストを真に受けると、起動中の全PRを `GONE_PR` 扱いして worktree を消してしまう。

`GONE_PR` は launched.txt に載っているのにレビュー依頼一覧から消えたPRを指す。マージ・クローズ・レビュー依頼の取り下げが混ざっているので、これ単独では削除の根拠にならない。「片付けの判断」が理由を確定させ、launched.txt から番号を消すので通知は止まる。

`seen.txt` はウォッチャーの `NEW_PR` 重複防止専用で、起動するかどうかの判断には使わない（それはスイープが launched.txt と既存タブで行う）。再アームは不要で、停止時には `watcher-task-id` の task ID を TaskStop に渡す。

## スイープ

トリガーはウォッチャーの NEW_PR 通知である。

1. 検知を実行し、結果を保存する:
   ```
   gh pr list --search "review-requested:@me" --state open --json number,title,headRefName,baseRefName,url > <state>/sweep.json
   ```
2. 新規PR = sweep.json の番号 − `launched.txt` − 稼働中の `pr<番号>` エージェント（`herdr agent list`）。
3. 新規PRを番号の昇順で「レビュー起動」する。

完了基準: 新規PR全件のレビュー起動を試行済みであること。

## blocked への回答

起動時と監視時の blocked には、この共有手順を使う。
v0.8.2 の通常 prompt は blocked 中に `agent_blocked` を返して入力を送らないため、この手順では使わない。

1. `herdr agent read <target> --source visible` で承認または質問の画面を読む。
2. 画面をユーザーへ提示し、明示的な回答を待つ。
   画面だけから承認を推測せず、回答が曖昧なときは送信しない。
3. ユーザーが指定した入力だけを送る。
   - 選択 UI には `herdr agent send-keys <target> up`、`down`、`enter` などを使う。
   - 自由文には `herdr agent get <target>` の JSON から解決済みの pane ID を取得する。
     ```bash
     agent_json=$(herdr agent get <target>)
     pane_id=$(printf '%s\n' "$agent_json" | jq -r '.result.agent.pane_id // empty')
     test -n "$pane_id"
     ```
     回答は shell の代入や連結に埋め込まず、execution tool の単一 argv として渡す。
     ```text
     ["herdr", "pane", "send-text", "<pane_id>", "<ユーザーが明示した回答>"]
     ["herdr", "pane", "send-keys", "<pane_id>", "enter"]
     ```
4. 入力後に `herdr agent get <target>` で対象 pane と状態を確認し、入力が受理されたことを確かめる。
   状態が blocked のまま、または受理を確認できなければ再送せず、ユーザーへ再度確認する。

## レビュー起動（PR 1件ごと）

worktree が新規か既存か、クラッシュ後の再開かで分岐しない。worktree パスで workspace を照合する step 3 が3ケースすべてを吸収する。

1. worktree を用意する: 自身の Bash で `wt switch pr:<番号> --no-cd` を実行する。非0終了なら失敗。worktree が新規でも既存でも、ここまでで worktree 自体は必ず用意される（新規のときだけ post-start フックが workspace も作る）。**出力を控えておく**。`✓ Created worktree` か `○ Switched to worktree` かが、失敗時に worktree を消してよいかの唯一の判断材料になる。
2. worktree パスを確定する。`<headRefName>` は sweep.json のもの:
   ```bash
   git worktree list --porcelain \
     | awk -v b="refs/heads/<headRefName>" '/^worktree /{p=$2} $0=="branch "b{print p}'
   ```
   0 件または複数件なら推測せず失敗として扱う。得た値を `<worktreeパス>` とする。`wt list --format json` は使わない（出力スキーマが 1 から 2 へ移行中でキー名が変わる）。
3. workspace を確定する。`herdr workspace list` から `worktree.checkout_path` が `<worktreeパス>` と一致する workspace を探す。**どの分岐に乗ったかを控えておく**。失敗したときに workspace を閉じてよいかの唯一の判断材料になる（step 1 の `wt switch` 出力と対になる）:
   - **1 件**: その `workspace_id` を `<id>` とする。post-start フックが作った直後も、クラッシュ・中断からの再開もここに乗る。**この分岐なら自分が作った workspace ではない**。
   - **0 件**: フックが走らなかった場合（既存 worktree）。次で作り、返る JSON の `result.workspace.workspace_id` を `<id>` とする。**この分岐で作った workspace だけが自分のもの**:
     ```
     herdr worktree open --cwd <リポジトリroot> --path <worktreeパス> --label "pr#<番号>" --no-focus
     ```
   - **複数件**: 推測せず失敗として扱う。
4. `herdr workspace rename <id> "pr#<番号>"` でラベルを揃える（フック生成分はブランチ名ラベルになっている）。既にラベルが一致していても、判定を挟まず毎回呼ぶ。
5. root tab と root pane を得る。root tab は `herdr tab list --workspace <id>` のうちラベルが `agent review` のもの。無ければ `editor` と `diff` を除いた残りで `number` が最小のもの（フックが最初に作るタブで、ブランチ名ラベルが付いている）。該当が 0 件または複数件なら推測せず失敗として扱う。`herdr pane list --workspace <id>` からその tab の pane を一つだけ得て `<root pane>` とする。0 件または複数件なら失敗として扱う。root tab のラベルが `agent review` でなければ `herdr tab rename <root tab> "agent review"`。
6. 補助タブ（`editor` と `diff`）を用意する。ラベルはこの2つで固定し、`diff (PR)` のような別名を付けない。step 5 で引いた `herdr tab list` / `herdr pane list` の結果をそのまま使う（間で構成は変わらないので引き直さなくてよい）。ラベルごとに次で分岐する:
   - **同名タブが無い**: `herdr tab create --workspace <id> --label "<ラベル>" --cwd <worktreeパス> --no-focus` で作る。pane_id は create の JSON から読む。
   - **同名タブがある**: **作らない。そのタブの pane を `herdr pane list --workspace <id>` から引いて再利用する。** フックが作るタブは shell が置かれているだけで目的のコマンドは走っていないので、既存タブを避けて新規に作ると `diff` と `diff (PR)` のようなタブの二重化を起こす。

   pane_id が決まったら、ラベルごとのコマンドを**起動を確認するまで最大3回送る**。`tab create` は shell の初期化完了を待たず、direnv / devenv の評価中に送った入力は失われるため、送りっぱなしにすると nvim も hunk も起動しない空のタブが残る。判定は `herdr pane process-info` の foreground プロセスで行い、次の3値に潰す（`shell` = 入力を受け付けられる、`nvim` / `hunk` = 目的のコマンドが走っている、それ以外 = direnv 等が前面にいて入力は失われる）:
   ```bash
   pane=<pane_id>; cmd=<コマンド>; want=<プロセス名>   # editor は nvim、diff は hunk
   fg() {
     herdr pane process-info --pane "$pane" | jq -r '.result.process_info as $i
       | (($i.foreground_processes // [])[0] // {}) as $p
       | if $p.pid == null or $p.pid == $i.shell_pid then "shell" else $p.argv0 end'
   }
   for attempt in 1 2 3; do
     [ "$(fg)" = "$want" ] && break          # 再開ケース。走っている nvim に文字を打ち込まない
     for i in $(seq 1 30); do                # shell が前面に戻るまで待つ
       [ "$(fg)" = "shell" ] && break
       sleep 2
     done
     herdr pane run "$pane" "$cmd"
     for i in $(seq 1 15); do
       sleep 2
       [ "$(fg)" = "$want" ] && break
     done
   done
   test "$(fg)" = "$want"
   ```
   - **editor**: `cmd="nvim ."`、`want=nvim`
   - **diff**: `cmd="hunk diff origin/<baseRefName>...HEAD"`、`want=hunk`（ベースが `main` なら `origin/main...HEAD`、それ以外ならそのベースブランチと `HEAD` の差分を Hunk で表示）

   3回とも起動しなければ `herdr pane read <pane_id>` で原因を確認してユーザーへ報告する。補助タブはレビューの前提ではないので、この step の失敗としては扱わず次へ進む。
7. Claude Code 起動（agent review タブの root pane で）。direnv / devenv の評価中はシェルに到達しておらず `{"error":{"code":"agent_pane_busy"}}` で落ちるため、このエラーだけを最大10回まで再試行する。
   ```bash
   started=0
   start_error=
   for i in $(seq 1 10); do
     out=$(herdr agent start pr<番号> --kind claude --pane <root pane> -- --model opus "準備完了とだけ返して" 2>&1) || true
     if ! printf '%s\n' "$out" | jq -e . >/dev/null 2>&1; then
       start_error=invalid_output
       printf '%s\n' "$out"
       break
     fi
     code=$(printf '%s\n' "$out" | jq -r '.error.code // empty')
     if [ -z "$code" ]; then
       started=1
       break
     fi
     start_error="$code"
     [ "$code" = agent_pane_busy ] || break
     sleep 5
   done
   ```
   `started=1` なら、下記の初回 argv prompt の待機へ進む。
   `start_error` が `agent_pane_busy` のままなら、10回の再試行を使い切ったため失敗として扱う。
   `agent_pane_busy` 以外のエラーも再試行せず、原因を確認して失敗として扱う。

   `start_error=agent_not_ready` は起動中に blocked を検出した結果であり、agent 名は保持される。
   ここで同名の `agent start` を再実行しない。
   `blocked への回答` の共有手順を実行する。
   ユーザーの回答を送った後、`herdr agent wait pr<番号> --until idle --until done --timeout 300000` を実行する。
   idle または done になったら、この step 7 の初回 argv prompt 待機へ進む。
   待機中に再び blocked になったら、共有手順へ戻る。

   起動成功または `agent_not_ready` 解消後は、初回 argv prompt が終わって idle または done になるまで `herdr agent wait pr<番号> --until idle --until done --timeout 60000` を最大5回実行する。
   ```bash
   ready=0
   for i in $(seq 1 5); do
     if herdr agent wait pr<番号> --until idle --until done --timeout 60000; then
       ready=1
       break
     fi
   done
   test "$ready" = 1
   ```
   **この wait の戻り値を必ず確認する。**
   timeout（まだ working）のまま次へ進むと step 8 の prompt がキューに積まれ、前ターン終了後に自動送信されてレビューが二重に走る（20分・数百kトークンの丸損）。
   idle または done にならなければ prompt を送らず `herdr agent read pr<番号> --source visible` で状況を確認し、失敗として扱う。
8. レビュー指示（`--wait` は付けない。レビューは長い）。スラッシュコマンドは Claude Code の補完ポップアップに Enter を食われてテキストが入力欄に残るため、`send-keys enter` で追い打ちする:
   ```bash
   herdr agent prompt pr<番号> "/code-review:code-review 敵対的検証をして。レビューは読み取り専用で行い、指摘はこのセッションに返答すること。GitHub の PR、レビュー、コメント、issue を含む外部サービスへは一切書き込まないこと。"
   sleep 2
   herdr agent send-keys pr<番号> enter
   ```
   送信できたかは `herdr agent get pr<番号>` が working になったかで確認する。ならなければ `herdr agent read pr<番号> --source visible` で入力欄の残留を見る（working 中の agent に `--source recent-unwrapped` を使うと `agent_not_idle` で拒否される）。キューに積んでしまった場合は `herdr agent send-keys pr<番号> up`（キューを入力欄へ戻す）→ `herdr agent send-keys pr<番号> ctrl+u`（クリア）で解除する。
9. `<worktreeパス>` を `<state>/worktree-pr<番号>` に書く（片付けが参照する。sweep.json はスイープごとに上書きされ、マージ済みPRは消えるので当てにしない）。`launched.txt` に番号を追記し、Monitor の persistent task として `herdr agent wait pr<番号> --timeout 3600000` を実行して監視をアームする。返却された task ID を `<state>/monitor-pr<番号>-task-id` に記録する。

step 1〜8 のどれかが失敗したら（各 step の「失敗として扱う」はすべてここへ来る）: 原因を確認し（step 7 以降の失敗なら `herdr agent read pr<番号> --source visible`、それ以前なら `herdr pane read <pane_id>`）、**この起動試行で自分が新規に作ったものだけ**を片付ける。

- workspace: step 3 の 0 件分岐で `herdr worktree open` した場合のみ閉じる。step 3 で既存が 1 件ヒットしていたなら残す。ただし次の worktree 削除に該当するときは、その workspace も一緒に閉じる。フックが作った直後のものであり、worktree を消せば行き先を失うため。
- worktree: step 1 の `wt switch` 出力が `✓ Created worktree` だった場合のみ `wt remove --foreground --reap <worktreeパス>` で消す。`○ Switched to worktree` なら**既存の worktree なので消さない**（他の作業の未コミット変更を巻き込む）。
- タブとエージェント: どちらの分岐でも個別に止めない。workspace を閉じるなら pane ごと落ちる。workspace を残すなら editor / diff タブも起動済みの `pr<番号>` エージェントも残るが、そのままでよい。再試行時は step 3 が同じ workspace を 1 件ヒットで拾い、step 6 が既存タブを再利用する。

`launched.txt` に番号を**追記した上で**ユーザーに報告する。追記するのは自動再試行の無限ループを防ぐため。再試行はユーザーの指示で launched.txt から番号を消して行う。

完了基準: `agent start` の成功、または `agent_not_ready` 後に同名 agent が idle または done になったことと初回 argv prompt の idle または done を確認し、step 8 で `herdr agent get pr<番号>` が working になっていること。いずれかの確認に失敗した場合は、`launched.txt` への追記と原因の報告まで終える。

## 監視（agent wait が戻ったとき）

wait が戻った時点で `<state>/monitor-pr<番号>-task-id` の task ID は失効している。**アームし直すときは必ず、返った新しい task ID でこのファイルを上書きする。** 上書きを忘れると停止時の TaskStop が失効した ID に空振りし、監視タスクが生き残る。アームし直すかどうかは分岐ごとに違う（下記）。

`herdr agent get pr<番号>` で状態を確認して分岐する:

- **idle / done**: `herdr agent read pr<番号> --source recent-unwrapped --lines 150` で結果を読み、重大指摘の有無を1〜2文でユーザーへ報告する。workspace と worktree はそのまま残す。ユーザーは指摘の裏を取るために worktree を開くので、ここで消してはいけない。レビューはここで完結するので**再アームしない**。task-id ファイルは失効したまま残るが、停止や片付けの TaskStop に渡しても無害。
- **blocked**: `blocked への回答` の共有手順を実行する。
  他PRの監視とスイープは継続する。
  回答を送ったことを確認できた場合だけ **`herdr agent wait pr<番号> --timeout 3600000` を Monitor で再アームして、返った新しい task ID でファイルを上書きする**。
  ユーザーの回答がない間は blocked のまま待ち、監視を再アームしない。
  進行中の agent に `--source recent-unwrapped` を使うと `agent_not_idle` で拒否されるので、idle / done 以外は必ず `visible` を使う。
  Claude Code は代替スクリーンで動くため、`--lines` を増やしてもスクロールアウトした行は取れない。
- **timeout（エラー）**: 同じ wait をアームし直し、返った task ID でファイルを上書きする。

## 片付けの判断

worktree はユーザーが指摘を読み、自分の目でコードを確かめるための場所である。**自動で消してよいのは、PR が閉じたか、`<me>` が approve を出したときだけ**。それ以外は消さずに報告し、ユーザーの指示を待つ。

入口は3つ。ウォッチャーの `GONE_PR <番号>` 通知、初回セットアップの残骸回収、そしてユーザーの明示的な片付け指示である。**3つめは判断を飛ばして「片付けの実行」へ直行する**（`gh pr view` を引かない。ユーザーの指示が根拠であり、PR の state は関係ない）。残る2つは次で PR の実態を確定させてから分岐する:

```
gh pr view <番号> --json state,title,latestReviews \
  --jq '{state, title, mine: [.latestReviews[] | select(.author.login == "<me>") | .state]}'
```

`latestReviews` は著者ごとの最新レビューを返すので、`mine` は `["APPROVED"]` / `["COMMENTED"]` / `["CHANGES_REQUESTED"]` / `[]` のいずれかになる。

- **state が MERGED / CLOSED**: PR 自体が閉じたので誰もレビューしない。エージェントが動いていても止めて「片付けの実行」へ進む。
- **state が OPEN かつ `mine` が `["APPROVED"]`**: ユーザーが目を通して承認を出した。worktree の役目は終わりなので「片付けの実行」へ進む。
- **state が OPEN でそれ以外**（`COMMENTED` / `CHANGES_REQUESTED` / `[]`）: コメントを付けてレビュー依頼が外れただけで、ユーザーはまだこのPRを見続ける。「レビュー依頼が外れたが PR は open で `<me>` は未 approve。worktree を残している」と `mine` の中身を添えて報告し、指示を待つ。

approve 済みかどうかは `mine` の**最新**の状態で見る。approve の後に changes-requested を出していれば approve は覆っており、残すのが正しい。

worktree を残す分岐でも、`launched.txt` と `seen.txt` から番号を消す（消し方は「片付けの実行」step 5）。残骸回収は初回セットアップの一度きりで、この時点の両ファイルは touch したばかりの空である。消す番号が載っていないだけで、手順を飛ばすわけではない。実際に効くのは `GONE_PR` 起点のときだけである。5分ごとの再通知を止めるためで、消しても poll.txt に載っていない以上スイープは再起動しない。ただし `<state>/monitor-pr<番号>-task-id` の監視タスクは止めない。レビューエージェントがまだ動いている可能性があり、止めると結果を取りこぼす。片付けの実行へ進む分岐では、その step 5 が同じ後始末をする。再びレビュー依頼が来たら新規PRとして扱われるが、「レビュー起動」step 3 が worktree パスで既存 workspace を拾うので、残っていればそれを再利用する。

自動で片付けてよい根拠は `gh pr view` が返す state と `<me>` の approve、そしてユーザーの明示的な指示だけである。次はいずれも根拠にならない:

- レビューエージェントが idle / done になったこと
- 指摘をユーザーへ報告し終えたこと
- PR にコメントやレビューが投稿されたこと（`<me>` の APPROVED 以外は、ユーザーが見終えた証拠にならない。このスキルはそもそも GitHub へ書き込まないので、投稿の主体はエージェント以外の誰かである）
- `review-requested:@me` の一覧から消えたこと（`GONE_PR` は調査の合図であって、削除の許可ではない）

完了基準: `GONE_PR` / 残骸回収 起点の対象PR全件について `gh pr view` を引き終え、片付けたものと残したものをユーザーへ報告済みであること。

## 片付けの実行

PR 1件ごとに step 1〜5 を通しで走らせる。複数件あるときは番号の昇順で1件ずつ完結させる（step 単位で横断しない。途中で失敗したPRの影響を他へ広げないため）。

1. `<state>/monitor-pr<番号>-task-id` の task ID を TaskStop に渡し、`unlink <state>/monitor-pr<番号>-task-id` でそのファイルを消す。ファイルが無ければこの手順を飛ばす。前セッションの残骸を回収する経路では監視をアームしていないので必ず不在になる。
2. `herdr workspace list` からラベル `pr#<番号>` の workspace ID を得て `herdr workspace close <id>` する。agent review / editor / diff の全 pane が閉じ、worktree を掴んでいる claude・nvim・hunk が落ちる。該当 workspace が無ければこの手順を飛ばす。
3. `<state>/worktree-pr<番号>` からパスを読み、`wt remove --foreground --reap <worktreeパス>` を実行する。`--foreground` は削除完了までブロックさせて結果を確かめるため、`--reap` は worktree 内に残ったプロセス（LSP・ウォッチャー等）を先に落とすために付ける。マージ済みならブランチも一緒に消える。
4. `test ! -d <worktreeパス>` で worktree が実際に消えたことを確かめ、消えていれば `unlink <state>/worktree-pr<番号>` でそのファイルを消す。残っていれば `wt remove` の出力と**残った worktree の絶対パス**をユーザーへ報告し、worktree はそのまま残す。`-f` / `-D` は使わない。未コミットの変更が理由で消せないのは、レビューが読み取り専用のはずなのに書き込みが起きた合図なので、握り潰さずユーザーの判断に渡す。step 2 で workspace を閉じた以上、この worktree は次セッションの残骸回収（`pr#<番号>` ラベルの走査）にも引っかからない。報告したパスがユーザーの手がかりのすべてになる。
5. `launched.txt` と `seen.txt` に番号が残っていれば消す: `awk -v n=<番号> '$0 != n' <ファイル> > <ファイル>.tmp && mv <ファイル>.tmp <ファイル>` を両方に対して実行する。**step 3 / 4 の成否によらず実行する**。worktree が消せなかったときも `GONE_PR` の再通知は止める。5 分ごとに同じ判断を蒸し返しても結論は変わらず、消せない理由はユーザーの手にしか無いため。

完了基準: worktree が消えているか、消せなかった事実をユーザーへ報告済みであること。

## 停止

ユーザーが停止を指示したら: `watcher-task-id` と、`<state>` に**ファイルとして存在する**各 `monitor-pr<番号>-task-id` の task ID を TaskStop に渡して止め（既に戻った wait の失効 ID が混ざっても構わない。生きているものを取りこぼす方が悪い）、レビューの一覧（PR番号・workspace ID・worktree パス・`herdr agent get` が返す status）を報告して終わる。workspace・worktree・エージェントはすべて残す。停止は片付けの根拠にならない。残りも消したいとユーザーが言ったら、各PRについて「片付けの実行」を走らせる。

レビュー済みPRへの再レビュー依頼はスコープ外。`launched.txt` に載った番号は sweep の起動候補から除外される。`seen.txt` は watcher の `NEW_PR` 再通知だけを抑止する。再レビューするにはユーザーが `launched.txt` から番号を消す。`NEW_PR` 通知も再度必要なら `seen.txt` からも消す。検知は個人宛の `review-requested:@me` のみで、チーム宛のレビュー依頼は対象外。
