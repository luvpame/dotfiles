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
- `wt switch` は post-start フック（[[worktree-devenv-setup]]）が worktree 専用の herdr workspace を自動生成する。実行した pane では cd されず、`--no-cd` でもフックは走る。レビュー環境の workspace はこのフック任せで、スキル側では作らない。
- `claude` を引数なしで起動すると FleetView（セッション一覧UI）が開き、`agent prompt` がタスク作成ボックスに吸われてストールする。herdr から起動するときは初期プロンプトを argv で渡して直接セッションを開く（例: `-- "準備完了とだけ返して"`）。スラッシュコマンドは argv だとテキスト扱いされるので、起動後に idle を待ってから `agent prompt` で送る。

## 初回セットアップ

1. 前提確認。欠けたら原因を報告して終了する:
   - 自セッションのモデルが opus であること（システムプロンプトの記載で判断する）。オーケストレーターは自分のモデルを変えられないので、opus 以外なら `claude --model opus` での起動し直しを案内して終了する
   - `test "${HERDR_ENV:-}" = 1`
   - `git rev-parse --show-toplevel`（リポジトリ内で動いている）
   - `wt --version`
   - `gh pr list --limit 1` が成功（TLS エラーなら上記 allowedHosts を案内する）
   - `gh api user --jq .login` の出力を `<me>` として固定する（片付けの判断が自分のレビュー状態を引くのに使う）
2. 専用 workspace へ移る: `herdr pane current --current` で現在の workspace ID を得て、`herdr workspace list` からそのラベルを照合する。ラベルが `pr-review` なら現在の pane ID を `<orchestrator pane>` とする。そうでなければ、`herdr pane move "$HERDR_PANE_ID" --new-workspace --label "pr-review" --tab-label "orchestrator" --no-focus` で自分ごと引っ越す（プロセスは生きたまま移動する）。以後は move の JSON にある `result.move_result.pane.pane_id` を `<orchestrator pane>` として使う。
3. 自セッションの scratchpad ディレクトリ（システムプロンプト記載）に `<scratchpad>/pr-review-orchestrator/<orchestrator pane>` を state ディレクトリとして作り、パスを以後の `<state>` として固定する。`launched.txt`（起動済みまたは失敗済みのPR番号、1行1件）と `seen.txt`（ウォッチャー通知済みPR番号、1行1件）を touch する。作成後に `<state>` をユーザーへ一度報告する。
4. 前セッションの残骸を回収する。`<state>` はセッションごとの scratchpad 配下にあり前回のものは引き継がれないので、環境そのものを走査する: `herdr workspace list` でラベルが `pr#<番号>` の workspace を全部挙げ、それぞれ `gh pr view <番号> --json state,title` を引く。`worktree.checkout_path` を `<state>/worktree-pr<番号>` に書き戻してから、1件ずつ「片付けの判断」の分岐に載せる。残った分は一覧にしてユーザーへ報告する。該当 workspace が無ければ何もしない。
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

## レビュー起動（PR 1件ごと）

`herdr workspace list` にラベル `pr#<番号>` が既にある場合（クラッシュ・中断後の再開）: step 1〜3 をスキップする。その workspace の `worktree.checkout_path` を `<worktreeパス>` とする。`herdr tab list --workspace <id>` でラベルが `agent review` の tab ID を一つだけ特定し、`herdr pane list --workspace <id>` からその tab ID の pane を一つだけ得る。この pane を root pane として step 4 を続ける。該当 tab または pane が 0 件か複数件なら、再開対象を推測せず、ユーザーへ報告して停止する。

1. worktree 作成: `wt switch` 前に `herdr workspace list` の workspace ID 一覧を保存し、自身の Bash で `wt switch pr:<番号> --no-cd` を実行する（PR 1件 = workspace 1つ。post-start フックが worktree 専用 workspace を生成し、同一 repo の workspace として repo の workspace 配下にグルーピングされる）。非0終了なら失敗。
2. 生成された workspace を整える: もう一度 `herdr workspace list` を取得し、保存済み一覧にない ID かつラベルが sweep.json の `headRefName` と一致する workspace を一つだけ特定する。0 件または複数件なら推測せず失敗として扱う。この JSON の `worktree.checkout_path` を `<worktreeパス>` とし、workspace ID を `<id>` とする。`herdr tab list --workspace <id>` で root tab `<id>:t1` を確認し、`herdr pane list --workspace <id>` からこの tab の pane を一つだけ得て `<root pane>` とする。0 件または複数件なら失敗として扱う。
   - `herdr workspace rename <id> "pr#<番号>"`
   - root tab を `herdr tab rename <id>:t1 "agent review"`
3. 補助タブを2枚作る（いずれも `--cwd <worktreeパス>` `--no-focus`。pane_id は create の JSON から読む）。`tab create` は shell の初期化完了を待たないため、各 pane で次の readiness gate を通してから目的のコマンドを送る。direnv の処理中に最初の入力が失われても、shell が sentinel を出力するまで最大3回再送する。sentinel は入力行との誤一致を避けるため、文字列をそのまま command に含めず8進エスケープで出力する:
   ```bash
   ready=0
   for attempt in 1 2 3; do
     herdr pane run <pane_id> "printf '\137\137PR\137REVIEW\137SHELL\137READY\137\137\n'"
     if herdr pane wait-output <pane_id> --match "__PR_REVIEW_SHELL_READY__" --timeout 60000; then
       ready=1
       break
     fi
   done
   test "$ready" = 1
   ```
   3回とも sentinel を確認できなければ、この step の失敗として扱う。
   - **editor**: `herdr tab create --workspace <id> --label "editor" ...` → `herdr pane run <pane_id> "nvim ."`
   - **diff**: `herdr tab create --workspace <id> --label "diff" ...` → `herdr pane run <pane_id> "hunk diff origin/<baseRefName>...HEAD"`（ベースが `main` なら `origin/main...HEAD`、それ以外ならそのベースブランチと `HEAD` の差分を Hunk で表示）
4. Claude Code 起動（agent review タブの root pane で）: `herdr agent start pr<番号> --kind claude --pane <root pane> -- --model opus "準備完了とだけ返して"` → `herdr agent wait pr<番号> --timeout 60000` で idle を待つ。
5. レビュー指示（`--wait` は付けない。レビューは長い）:
   ```
   herdr agent prompt pr<番号> "/code-review:code-review 敵対的検証をして。レビューは読み取り専用で行い、指摘はこのセッションに返答すること。GitHub の PR、レビュー、コメント、issue を含む外部サービスへは一切書き込まないこと。"
   ```
6. `<worktreeパス>` を `<state>/worktree-pr<番号>` に書く（片付けが参照する。sweep.json はスイープごとに上書きされ、マージ済みPRは消えるので当てにしない）。`launched.txt` に番号を追記し、Monitor の persistent task として `herdr agent wait pr<番号> --timeout 3600000` を実行して監視をアームする。返却された task ID を `<state>/monitor-pr<番号>-task-id` に記録する。

step 1〜5 のどれかが失敗したら: 原因を確認し（agent 系は `pane read`）、この起動試行で新規に生成した workspace を閉じ、`wt switch` が作った worktree も `wt remove --foreground --reap <worktreeパス>` で消す。再開した既存 workspace と worktree は残す。`launched.txt` に番号を**追記した上で**ユーザーに報告する。追記するのは自動再試行の無限ループを防ぐため。再試行はユーザーの指示で launched.txt から番号を消して行う。

完了基準: `herdr agent list` に pr<番号> が working で載っているか、失敗として launched.txt 追記 + 報告済みであること。

## 監視（agent wait が戻ったとき）

`herdr agent get pr<番号>` で状態を確認して分岐する:

- **idle / done**: `herdr agent read pr<番号> --source recent-unwrapped --lines 150` で結果を読み、重大指摘の有無を1〜2文でユーザーへ報告する。workspace と worktree はそのまま残す。ユーザーは指摘の裏を取るために worktree を開くので、ここで消してはいけない。
- **blocked**: read で何を聞かれているかを確認し、ユーザーへ通知して指示を待つ。他PRの監視とスイープは継続する。
- **timeout（エラー）**: 同じ wait をアームし直す。

## 片付けの判断

worktree はユーザーが指摘を読み、自分の目でコードを確かめるための場所である。**自動で消してよいのは、PR が閉じたか、`<me>` が approve を出したときだけ**。それ以外は消さずに報告し、ユーザーの指示を待つ。

入口は2つ。ウォッチャーの `GONE_PR <番号>` 通知と、初回セットアップの残骸回収である。どちらも次で PR の実態を確定させてから分岐する:

```
gh pr view <番号> --json state,title,latestReviews \
  --jq '{state, title, mine: [.latestReviews[] | select(.author.login == "<me>") | .state]}'
```

`latestReviews` は著者ごとの最新レビューを返すので、`mine` は `["APPROVED"]` / `["COMMENTED"]` / `["CHANGES_REQUESTED"]` / `[]` のいずれかになる。

- **state が MERGED / CLOSED**: PR 自体が閉じたので誰もレビューしない。エージェントが動いていても止めて「片付けの実行」へ進む。
- **state が OPEN かつ `mine` が `["APPROVED"]`**: ユーザーが目を通して承認を出した。worktree の役目は終わりなので「片付けの実行」へ進む。
- **state が OPEN でそれ以外**（`COMMENTED` / `CHANGES_REQUESTED` / `[]`）: コメントを付けてレビュー依頼が外れただけで、ユーザーはまだこのPRを見続ける。「レビュー依頼が外れたが PR は open で `<me>` は未 approve。worktree を残している」と `mine` の中身を添えて報告し、指示を待つ。

approve 済みかどうかは `mine` の**最新**の状態で見る。approve の後に changes-requested を出していれば approve は覆っており、残すのが正しい。

`GONE_PR` 起点のときは、どちらの分岐でも `launched.txt` と `seen.txt` から番号を消す。5分ごとの再通知を止めるためで、消しても poll.txt に載っていない以上スイープは再起動しない。再びレビュー依頼が来たら新規PRとして扱われ、既存 workspace があれば「レビュー起動」の再開パスに乗る。

自動で片付けてよい根拠は `gh pr view` が返す state と `<me>` の approve、そしてユーザーの明示的な指示だけである。次はいずれも根拠にならない:

- レビューエージェントが idle / done になったこと
- 指摘をユーザーへ報告し終えたこと
- PR にコメントやレビューが投稿されたこと（`<me>` の APPROVED 以外は、ユーザーが見終えた証拠にならない。このスキルはそもそも GitHub へ書き込まないので、投稿の主体はエージェント以外の誰かである）
- `review-requested:@me` の一覧から消えたこと（`GONE_PR` は調査の合図であって、削除の許可ではない）

ユーザーが明示的に片付けを指示したときも「片付けの実行」を走らせる。

完了基準: 対象PR全件について `gh pr view` を引き終え、片付けたものと残したものをユーザーへ報告済みであること。

## 片付けの実行

1. `<state>/monitor-pr<番号>-task-id` の task ID を TaskStop に渡し、そのファイルを消す。
2. `herdr workspace list` からラベル `pr#<番号>` の workspace ID を得て `herdr workspace close <id>` する。agent review / editor / diff の全 pane が閉じ、worktree を掴んでいる claude・nvim・hunk が落ちる。該当 workspace が無ければこの手順を飛ばす。
3. `<state>/worktree-pr<番号>` からパスを読み、`wt remove --foreground --reap <worktreeパス>` を実行する。`--foreground` は削除完了までブロックさせて結果を確かめるため、`--reap` は worktree 内に残ったプロセス（LSP・ウォッチャー等）を先に落とすために付ける。マージ済みならブランチも一緒に消える。
4. `test ! -d <worktreeパス>` で worktree が実際に消えたことを確かめ、消えていれば `<state>/worktree-pr<番号>` を消す。残っていれば `wt remove` の出力とともにユーザーへ報告し、worktree はそのまま残す。`-f` / `-D` は使わない。未コミットの変更が理由で消せないのは、レビューが読み取り専用のはずなのに書き込みが起きた合図なので、握り潰さずユーザーの判断に渡す。
5. `launched.txt` と `seen.txt` にまだ番号が残っていれば消す。

完了基準: worktree が消えているか、消せなかった事実をユーザーへ報告済みであること。

## 停止

ユーザーが停止を指示したら: `watcher-task-id` と残っている各 `monitor-pr<番号>-task-id` に記録した task ID を TaskStop に渡して止め、レビューの一覧（PR番号・workspace ID・worktree パス・状態）を報告して終わる。workspace・worktree・エージェントはすべて残す。停止は片付けの根拠にならない。残りも消したいとユーザーが言ったら、各PRについて「片付けの実行」を走らせる。

レビュー済みPRへの再レビュー依頼はスコープ外。`launched.txt` に載った番号は sweep の起動候補から除外される。`seen.txt` は watcher の `NEW_PR` 再通知だけを抑止する。再レビューするにはユーザーが `launched.txt` から番号を消す。`NEW_PR` 通知も再度必要なら `seen.txt` からも消す。検知は個人宛の `review-requested:@me` のみで、チーム宛のレビュー依頼は対象外。
