---
name: pr-review-orchestrator
description: レビュー依頼が来ているPRを検知し、Herdrタブ + worktrunk worktree + Claude Codeで敵対的コードレビューを並列実行・監視するオーケストレーターになる
disable-model-invocation: true
---

# PR Review Orchestrator

このスキルを読んだエージェントがオーケストレーターになる。ウォッチャー（Monitor）が新規のレビュー依頼PRを通知するたびにスイープ→レビュー起動→監視を行い、停止指示があるまで続ける。オーケストレーターは専用 workspace（ラベル `pr-review`）で動く。PR workspace は herdr の仕様上 repo のメイン workspace（shogun）配下にネストされる（[[herdr-workspace-nesting-by-repo]]）。

## 環境の制約（先に読む）

- herdr CLI の構文と安全規則は herdr スキルが正。未読なら Skill ツールで先に読む。
- Monitor と TaskStop はホストのエージェント実行環境が提供する永続タスク API を使う。この二つを利用できない環境では開始せず、その制約を報告して終了する。CLI の JSON フィールド名は実行時の `herdr` 出力を正とする。
- gh と wt はサンドボックス内では動かない（keychain のトークンに触れず TLS も通らない。`sandbox.network.allowedDomains` 許可でも不十分）。このスキルはサンドボックス無効のセッションで動かす前提。前提確認の `gh pr list` が TLS エラーになったら、`api.github.com` と `github.com` のネットワーク許可に加えてサンドボックス無効のセッションが必要だと報告して止まる。
- `wt switch` は post-start フック（[[worktree-devenv-setup]]）が worktree 専用の herdr workspace を自動生成する。実行した pane では cd されず、`--no-cd` でもフックは走る。レビュー環境の workspace はこのフック任せで、スキル側では作らない。
- `claude` を引数なしで起動すると FleetView（セッション一覧UI）が開き、`agent prompt` がタスク作成ボックスに吸われてストールする。herdr から起動するときは初期プロンプトを argv で渡して直接セッションを開く（例: `-- "準備完了とだけ返して"`）。スラッシュコマンドは argv だとテキスト扱いされるので、起動後に idle を待ってから `agent prompt` で送る。

## 初回セットアップ

1. 前提確認。欠けたら原因を報告して終了する:
   - `test "${HERDR_ENV:-}" = 1`
   - `git rev-parse --show-toplevel`（リポジトリ内で動いている）
   - `wt --version`
   - `gh pr list --limit 1` が成功（TLS エラーなら上記 allowedHosts を案内する）
2. 専用 workspace へ移る: `herdr pane current --current` で現在の workspace ID を得て、`herdr workspace list` からそのラベルを照合する。ラベルが `pr-review` なら現在の pane ID を `<orchestrator pane>` とする。そうでなければ、`herdr pane move "$HERDR_PANE_ID" --new-workspace --label "pr-review" --tab-label "orchestrator" --no-focus` で自分ごと引っ越す（プロセスは生きたまま移動する）。以後は move の JSON にある `result.move_result.pane.pane_id` を `<orchestrator pane>` として使う。
3. 自セッションの scratchpad ディレクトリ（システムプロンプト記載）に `<scratchpad>/pr-review-orchestrator/<orchestrator pane>` を state ディレクトリとして作り、パスを以後の `<state>` として固定する。`launched.txt`（起動済みまたは失敗済みのPR番号、1行1件）と `seen.txt`（ウォッチャー通知済みPR番号、1行1件）を touch する。作成後に `<state>` をユーザーへ一度報告する。
4. ウォッチャーを起動する（次節）。初回ポーリングは即時に走るので、既存のレビュー依頼PRも起動直後の NEW_PR 通知として届く。

完了基準: 前提4点がすべて成功し、自分が `pr-review` workspace におり、state ディレクトリのパスが確定し、ウォッチャーが走っていること。

## ウォッチャー（スイープのトリガー）

Monitor ツールで一度だけ起動する（`persistent: true`、description は「レビュー依頼PRの検知」等）。返却された task ID を `<state>/watcher-task-id` に記録する。新規PR 1件につき `NEW_PR <番号>` を1行出力し、その通知が届いたらスイープを実行する:

```bash
touch <state>/seen.txt
while :; do
  gh pr list --search "review-requested:@me" --state open --json number --jq '.[].number' 2>/dev/null | sort -n > <state>/poll.txt || true
  new=$(grep -vxFf <state>/seen.txt <state>/poll.txt)
  if [ -n "$new" ]; then
    echo "$new" | sed 's/^/NEW_PR /'
    echo "$new" >> <state>/seen.txt
  fi
  sleep 300
done
```

`seen.txt` はウォッチャーの通知重複防止専用で、起動するかどうかの判断には使わない（それはスイープが launched.txt と既存タブで行う）。再アームは不要で、停止時には `watcher-task-id` の task ID を TaskStop に渡す。

## スイープ

トリガーは2つ: ウォッチャーの NEW_PR 通知、または監視が「枠空き + 持ち越しあり」を検知したとき。

1. 検知を実行し、結果を保存する:
   ```
   gh pr list --search "review-requested:@me" --state open --json number,title,headRefName,url > <state>/sweep.json
   ```
2. 新規PR = sweep.json の番号 − `launched.txt` − 稼働中の `pr<番号>` エージェント（`herdr agent list`）。
3. 新規PRを番号の昇順で「レビュー起動」する。同時レビューは3件まで（数え方: `herdr agent list` で working 状態の `pr<番号>` エージェント数）。超過分は起動せず launched.txt にも書かず、持ち越しとして記録する。

完了基準: 新規PR全件が「タブ起動済み」か「上限による持ち越し」のどちらかに分類されていること。

## レビュー起動（PR 1件ごと）

`herdr workspace list` にラベル `pr#<番号>` が既にある場合（クラッシュ・中断後の再開）: step 1〜3 をスキップする。`herdr tab list --workspace <id>` でラベルが `agent review` の tab ID を一つだけ特定し、`herdr pane list --workspace <id>` からその tab ID の pane を一つだけ得る。この pane を root pane として step 4 を続ける。該当 tab または pane が 0 件か複数件なら、再開対象を推測せず、ユーザーへ報告して停止する。

1. worktree 作成: `wt switch` 前に `herdr workspace list` の workspace ID 一覧を保存し、自身の Bash で `wt switch pr:<番号> --no-cd` を実行する（PR 1件 = workspace 1つ。post-start フックが worktree 専用 workspace を生成し、同一 repo の workspace として repo の workspace 配下にグルーピングされる）。非0終了なら失敗。
2. 生成された workspace を整える: もう一度 `herdr workspace list` を取得し、保存済み一覧にない ID かつラベルが sweep.json の `headRefName` と一致する workspace を一つだけ特定する。0 件または複数件なら推測せず失敗として扱う。この JSON の `worktree.checkout_path` を `<worktreeパス>` とし、workspace ID を `<id>` とする。`herdr tab list --workspace <id>` で root tab `<id>:t1` を確認し、`herdr pane list --workspace <id>` からこの tab の pane を一つだけ得て `<root pane>` とする。0 件または複数件なら失敗として扱う。
   - `herdr workspace rename <id> "pr#<番号>"`
   - root tab を `herdr tab rename <id>:t1 "agent review"`
3. 補助タブを2枚作る（いずれも `--cwd <worktreeパス>` `--no-focus`。pane_id は create の JSON から読む）:
   - **editor**: `herdr tab create --workspace <id> --label "editor" ...` → `herdr pane run <pane_id> "nvim ."`
   - **diff**: `herdr tab create --workspace <id> --label "diff" ...` → `herdr pane run <pane_id> "gh pr diff <番号>"`（pager で hunk 表示）
4. Claude Code 起動（agent review タブの root pane で）: `herdr agent start pr<番号> --kind claude --pane <root pane> -- "準備完了とだけ返して"` → `herdr agent wait pr<番号> --timeout 60000` で idle を待つ。
5. レビュー指示（`--wait` は付けない。レビューは長い）:
   ```
   herdr agent prompt pr<番号> "/code-review:code-review 敵対的検証をして"
   ```
6. `launched.txt` に番号を追記し、Monitor の persistent task として `herdr agent wait pr<番号> --timeout 3600000` を実行して監視をアームする。返却された task ID を `<state>/monitor-pr<番号>-task-id` に記録する。

step 1〜5 のどれかが失敗したら: 原因を確認し（agent 系は `pane read`）、この起動試行で新規に生成した workspace だけを閉じる。再開した既存 workspace は閉じない。`launched.txt` に番号を**追記した上で**ユーザーに報告する。追記するのは自動再試行の無限ループを防ぐため。再試行はユーザーの指示で launched.txt から番号を消して行う。

完了基準: `herdr agent list` に pr<番号> が working で載っているか、失敗として launched.txt 追記 + 報告済みであること。

## 監視（agent wait が戻ったとき）

`herdr agent get pr<番号>` で状態を確認して分岐する:

- **idle / done**: `herdr agent read pr<番号> --source recent-unwrapped --lines 150` で結果を読み、重大指摘の有無を1〜2文でユーザーへ報告する。workspace は閉じない。持ち越しPRがあれば枠が空いたので即スイープする。
- **blocked**: read で何を聞かれているかを確認し、ユーザーへ通知して指示を待つ。他PRの監視とスイープは継続する。
- **timeout（エラー）**: 同じ wait をアームし直す。

## 停止と後片付け

ユーザーが停止を指示したら: `watcher-task-id` と各 `monitor-pr<番号>-task-id` に記録した task ID を TaskStop に渡して止め、レビューの一覧（PR番号・workspace ID・状態）を報告して終わる。レビュー用の workspace・worktree・エージェントは残す。片付けはユーザーが明示したときだけ行う: `herdr workspace close <workspace_id>` と `wt remove <headRefName>`（headRefName は sweep.json にある）。

レビュー済みPRへの再レビュー依頼はスコープ外。`launched.txt` に載った番号は sweep の起動候補から除外される。`seen.txt` は watcher の `NEW_PR` 再通知だけを抑止し、持ち越しPRを後続 sweep から除外しない。再レビューするにはユーザーが `launched.txt` から番号を消す。`NEW_PR` 通知も再度必要なら `seen.txt` からも消す。検知は個人宛の `review-requested:@me` のみで、チーム宛のレビュー依頼は対象外。
