---
name: pr-review-orchestrator
description: レビュー依頼PRを影響度でトリアージし、none 以外を Herdr workspace と worktree で code-review と PR 解説へ回し、再レビュー、監視、片付けまで続けるオーケストレーター
disable-model-invocation: true
---

# PR Review Orchestrator

このスキルを読んだエージェントがオーケストレーターになる。ウォッチャー（Monitor）が新規のレビュー依頼PRを通知するたびにスイープ→レビュー起動／再レビュー→監視を行い、停止指示があるまで続ける。オーケストレーターは専用 workspace（ラベル `pr-review`）で動く。PR workspace は herdr の仕様上 repo のメイン workspace（shogun）配下にネストされる（[[herdr-workspace-nesting-by-repo]]）。

## レビュー結果の扱い

code-review は読み取り専用で行う。show-me は、レビュー起動で指定する Git ignore 済みディレクトリに限って解説用ファイルを生成してよい。各エージェントは結果をオーケストレーターへ返し、オーケストレーターはユーザーへ報告する。

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
   - `test "${HERDR_ENV:-}" = 1`
   - `git rev-parse --show-toplevel`（リポジトリ内で動いている）
   - `wt --version`
   - `gh pr list --limit 1` が成功（TLS エラーなら上記 `sandbox.network.allowedDomains` とサンドボックス無効を案内する）
   - `gh api user --jq .login` の出力を `<me>` として固定する（片付けの判断が自分のレビュー状態を引くのに使う）
2. 専用 workspace へ移る: `herdr pane current --current` で現在の workspace ID を得て、`herdr workspace list` からそのラベルを照合する。ラベルが `pr-review` なら現在の pane ID を `<orchestrator pane>` とする。そうでなければ、`herdr pane move "$HERDR_PANE_ID" --new-workspace --label "pr-review" --tab-label "orchestrator" --no-focus` で自分ごと引っ越す（プロセスは生きたまま移動する）。以後は move の JSON にある `result.move_result.pane.pane_id` を `<orchestrator pane>` として使う。
3. 自セッションの scratchpad ディレクトリ（システムプロンプト記載）に `<scratchpad>/pr-review-orchestrator/<orchestrator pane>` を state ディレクトリとして作り、パスを以後の `<state>` として固定する。`launched.txt`（起動済みまたは失敗済みのPR番号、1行1件）、`seen.txt`（ウォッチャー通知済みPR番号、1行1件）、`skipped.txt`（トリアージで対象外としたPR番号、1行1件）を touch する。作成後に `<state>` をユーザーへ一度報告する。
4. 前セッションの残骸を回収する。`<state>` はセッションごとの scratchpad 配下にあり前回のものは引き継がれないので、環境そのものを走査する: `herdr workspace list` でラベルが `review-#<番号>` の workspace を全部挙げ、`worktree.checkout_path` を `<state>/worktree-pr<番号>` に書き戻してから、1件ずつ「片付けの判断」の分岐に載せる（state と approve はそこで引くので、ここでは判断のための `gh pr view` を叩かない）。`worktree` キーを持たない workspace（過去に `herdr workspace create` で作られた残骸）は checkout_path を引けないので、`gh pr view <番号> --json headRefName` でブランチを求め、「レビュー起動」step 2 と同じ `git worktree list --porcelain` からパスを引く。**引いたパスも同じく `<state>/worktree-pr<番号>` に書く**（「片付けの実行」step 3 がこのファイルしか読まない）。残った分は一覧にしてユーザーへ報告する。該当 workspace が無ければ何もしない。
5. ウォッチャーを起動する（次節）。初回ポーリングは即時に走るので、既存のレビュー依頼PRも起動直後の NEW_PR 通知として届く。

完了基準: 前提4点がすべて成功し、自分が `pr-review` workspace におり、state ディレクトリのパスが確定し、既存の `review-#<番号>` workspace を全件仕分け済みで、ウォッチャーが走っていること。

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
2. 新規PR = sweep.json の番号 − `launched.txt` − `skipped.txt` − 稼働中の `pr<番号>` エージェント（`herdr agent list`）。稼働中エージェントで除外された番号は、次の step 3 の再レビュー判定に回る。残った新規PRは、番号の昇順で1件ずつ「トリアージ」にかける。
3. 再レビュー候補を判定する。稼働中の `pr<番号>` エージェントのうち、sweep.json に番号が載っており（＝現在レビュー依頼が出ている）、かつ idle または done のもの（working / blocked は動いている最中に指示を割り込ませることになるので対象外）を候補にする。**`launched.txt` への掲載は条件にしない**：片付けで launched.txt から番号が消えても pr<番号> エージェントは動き続けるので、掲載を条件にすると再依頼を取りこぼす（実例: PR #8139。片付けで `launched.txt` から消えた後の再依頼が拾われなかった）。候補ごとに `<state>/reviewed-sha-pr<番号>` の SHA と `gh pr view <番号> --json headRefOid --jq .headRefOid` が返す現在の PR HEAD を比較し、ファイルが存在し値が異なるものだけを「再レビュー候補」に確定する。一致するなら前回レビュー以降1コミットも進んでおらず、無関係な通知のたびに再レビューが暴発する（実例: PR #8152。無関係な PR #7981 の通知でスイープが走った際に再レビュー候補へ上がった）。この SHA 比較は一致／不一致のみを見る粗いフィルタで、不一致が rebase による見かけの変化か実変更かは「再レビュー」step 1 のパッチID比較が確定する。
4. トリアージがレビューすると決めた新規PRを番号の昇順で「レビュー起動」し、再レビュー候補を番号の昇順で「再レビュー」する。

完了基準: 新規PR全件のトリアージを終え、レビューすると決めたPRのレビュー起動と、再レビュー候補全件の再レビューを試行済みであること。

## トリアージ（PR 1件ごと）

スイープ step 2 が残した新規PRを、レビューを起こす前にふるいにかける。worktree・workspace・エージェントを一つでも作れば opus セッションで `/code-review` が20分・数百kトークンを消費するので、それに見合わない差分をここで落とす。

判定はオーケストレーター自身が行う。読むのはファイル名の一覧、規模の統計、対象外の候補に絞ったときだけの差分本文である。

影響度は次の5段階に分類する。高リスク領域の判定をファイル形式や対象外条件より先に行う。

- **none**：次のいずれかに限られ、実行時の動作へ影響する変更を含まない。生成物だけ、コメント、typo、フォーマットだけ、テスト追加だけ、見た目だけ、依存の patch 更新だけ、ドキュメントだけ、または動作へ影響しない設定だけ。高リスク領域の実行時の動作や運用設定を変える場合は none にしない。
- **low**：高リスク領域に触れず、一つの狭い領域で完結する小規模で単純な変更。
- **medium**：一般的なロジックや機能の変更、または影響度を判断できない変更。
- **high**：高リスク領域に狭く収まる変更、または高リスク領域に触れなくても複数領域へ広がる一般変更。
- **max**：高リスク領域へ広く影響する変更、大規模な移行、または構造変更。

高リスク領域は、認証、認可、データ層、インフラ、CI、デプロイ、Nix、権限、秘密情報、環境変数、バッチである。これらの実行時の動作や運用設定を変える場合は最低でも high とし、複数の高リスク領域や複数の基盤へ広がる場合は max とする。`changedFiles`、`additions`、`deletions` は規模の補助材料に使うが、行数やファイル数の固定閾値では分類しない。

**迷ったらレビューする。** 見逃したレビューは main に残るが、無駄に回したレビューはトークンを失うだけである。以下のどの段階でも、`gh` が失敗した回と判断の付かない回は、対象外にせず「レビュー起動」へ回す。

1. ファイル名を引く。失敗したらレビューする（空リストを真に受けると、コードのPRをドキュメント扱いで捨てる）:
   ```bash
   gh pr diff <番号> --name-only
   ```
   `.md` / `.mdx`だけでも拡張子だけで none とせず、差分と上記の定義で判定する。パスの接頭辞では判定しない。`docs/` 配下にはバックエンドE2Eの hurl（実コード）がある。
2. 規模を引く:
   ```bash
   gh pr view <番号> --json additions,deletions,changedFiles
   ```
   この時点で軽微ではありえないと分かるなら、差分本文を読まずにレビューする。`changedFiles`、`additions`、`deletions` のキーが欠けるか取得に失敗したら判断不能としてレビューする。
3. none の候補だけ差分本文（`gh pr diff <番号>`）を読み、生成物、コメント、typo、フォーマット、テスト追加、見た目、依存の patch 更新、ドキュメント、または動作へ影響しない設定だけに限られることを確認する。次のいずれかが1行でも混ざれば none にしない:
   - 生成元、クラス名、ロジック、プロダクションコードの変更
   - minor / major の依存更新
   - 上記の高リスク領域における実行時の動作や運用設定の変更
4. 上の定義を max、high、none、low、medium の順に当てはめる。確定した値を次の1行ファイルへ保存する:
   ```bash
   printf '%s\n' '<level>' > <state>/impact-pr<番号>
   ```
   `<level>` は `none`、`low`、`medium`、`high`、`max` のいずれかに限る。後続のレビュー起動、監視、再開、再レビューではこのファイルを読み、値を推測しない。
5. `none` のPRは worktree、workspace、エージェントを一切作らず、番号を `skipped.txt` に追記して「PR #<番号> は<理由>のためレビュー対象外」と報告する。`launched.txt` へは載せない。`GONE_PR` は launched.txt が基準なので、対象外PRが閉じても片付け（消す worktree も無い）は走らない。ユーザーが後からレビューさせたくなったときは `skipped.txt` から番号を消せば、次のスイープが新規PRとして拾う。none 以外は影響度を付けたまま「レビュー起動」へ進む。

完了基準: 新規PR全件を5段階のいずれかへ分類し、各PRの `impact-pr<番号>` を保存し、none はリソースを作らず `skipped.txt` への追記と理由付きの報告まで、none 以外は「レビュー起動」への受け渡しまで終えていること。

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
2. まず origin の remote-tracking ref を更新する: `git fetch origin <baseRefName> <headRefName>`。remote-tracking ref は勝手には更新されないので、これを飛ばすと以降の rev-list / merge-base / diff がすべて古い基準で計算される（実例: ローカルの `origin/main` が19コミット古い（`419dab1b25`、実際は `b654f9873b`）まま merge-base を計算し、main 側の変更が紛れ込んで「25ファイル→56ファイルに増えた」と誤読した。fetch 後は25ファイルのまま、実変更は spec 2行だけだった）。

   worktree パスを確定する。`<headRefName>` は sweep.json のもの:
   ```bash
   git worktree list --porcelain \
     | awk -v b="refs/heads/<headRefName>" '/^worktree /{p=$2} $0=="branch "b{print p}'
   ```
   0 件または複数件なら推測せず失敗として扱う。得た値を `<worktreeパス>` とする。`wt list --format json` は使わない（出力スキーマが 1 から 2 へ移行中でキー名が変わる）。

   確定した worktree の HEAD を origin に追いつかせる。`wt switch` は fetch はするが worktree の HEAD を進めないため、既存 worktree が古いまま残ることがある（実例: origin より 34 コミット遅れていた）:
   ```bash
   git -C <worktreeパス> status --porcelain
   git -C <worktreeパス> rev-list --left-right --count HEAD...origin/<headRefName>
   ```
   `rev-list --left-right --count` は「worktree だけのコミット数 origin だけのコミット数」を返す。未コミット変更の有無とこの左側の数で分岐する:

   - **未コミット変更がある**: divergent かどうかに関わらず ff も作り直しもしない。レビューは読み取り専用のはずなので、変更があること自体が調査に値する。古い HEAD のままレビューを続けるかも含め、その事実をユーザーへ報告し判断を仰ぐ。
   - **未コミット変更が 0 件で左側が 0**（HEAD が origin より遅れているだけ）: `git -C <worktreeパス> merge --ff-only origin/<headRefName>` で追いつかせる。fast-forward のみなので、コミット済みの内容へ移動するだけで破壊的ではない。
   - **未コミット変更が 0 件で左側が 0 でない**（divergent。force-push で worktree の HEAD が捨てられた旧 head になっている疑い。実例: PR #7981 は 7/130、PR #8139 は 16/87 で、いずれも `git fetch` の出力に `(forced update)` が出ていた）: `git -C <worktreeパス> reflog show origin/<headRefName>` を見る。
     - worktree の HEAD が過去の origin head として（`forced-update` 付きで）記録されていれば、force-push で捨てられた内容であり失われるものはない。worktree を作り直す。workspace をまだ特定していなければ（この時点は step 3 より前）`herdr workspace list` の `worktree.checkout_path` が `<worktreeパス>` と一致するものを探して `<id>` とする:
       ```
       herdr workspace close <id>
       wt remove --foreground --reap <worktreeパス>
       git branch -D <headRefName>
       wt switch pr:<番号> --no-cd
       ```
       ここまで終えたら、この step 2 の先頭（worktree パスの確定）からやり直す。作り直した `wt switch` の出力は `✓ Created worktree` になるので、失敗時の片付け規定（`✓ Created worktree` のときだけ worktree を消す）とも矛盾しない。
     - reflog に記録が無くローカル固有のコミットに見えるなら、勝手に消さずユーザーへ報告し判断を仰ぐ。`git -C <worktreeパス> log --oneline origin/<headRefName>..HEAD` のコミット一覧を添える。

   新規 worktree（`✓ Created worktree`）はそもそも origin から作られるので、この手順は空振りするだけで害はない。
3. workspace を確定する。`herdr workspace list` から `worktree.checkout_path` が `<worktreeパス>` と一致する workspace を探す。**どの分岐に乗ったかを控えておく**。失敗したときに workspace を閉じてよいかの唯一の判断材料になる（step 1 の `wt switch` 出力と対になる）:
   - **1 件**: その `workspace_id` を `<id>` とする。post-start フックが作った直後も、クラッシュ・中断からの再開もここに乗る。**この分岐なら自分が作った workspace ではない**。
   - **0 件**: フックが走らなかった場合（既存 worktree）。次で作り、返る JSON の `result.workspace.workspace_id` を `<id>` とする。**この分岐で作った workspace だけが自分のもの**:
     ```
     herdr worktree open --cwd <リポジトリroot> --path <worktreeパス> --label "review-#<番号>" --no-focus
     ```
   - **複数件**: 推測せず失敗として扱う。
4. `herdr workspace rename <id> "review-#<番号>"` でラベルを揃える（フック生成分はブランチ名ラベルになっている）。既にラベルが一致していても、判定を挟まず毎回呼ぶ。
5. root tab と root pane を得る。root tab は `herdr tab list --workspace <id>` のうちラベルが `agent review` のもの。無ければ `editor` と `diff` を除いた残りで `number` が最小のもの（フックが最初に作るタブで、ブランチ名ラベルが付いている）。件数で分岐する:
   - **1 件**: `herdr pane list --workspace <id>` から、その tab でラベルが `code review` の pane を探す。1 件なら `<root pane>` とする。0 件なら、その tab の pane が1件だけの場合に限って `<root pane>` とする。それ以外は失敗として扱う。root tab のラベルが `agent review` でなければ `herdr tab rename <root tab> "agent review"`。
   - **0 件**: 再試行しても workspace の状態は変わらないので、失敗にせず `herdr tab create --workspace <id> --label "agent review" --cwd <worktreeパス> --no-focus` で新規作成する。返る JSON の `result.root_pane.pane_id` を `<root pane>` とする。
   - **複数件**: どれが root か推測できないので失敗として扱う。

   `<root pane>` を確定したら `herdr pane rename <root pane> "code review"` でラベルを固定する。これにより、右側へ解説 pane を追加した後の再開でも root pane を一意に引ける。
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
   - **diff**: `cmd="hunk diff <baseRefOid>...HEAD"`、`want=hunk`。`<baseRefOid>` は `gh pr view <番号> --json baseRefOid --jq .baseRefOid` で得た SHA。ブランチ名（`origin/<baseRefName>`）を基点にすると、ローカルの remote-tracking ref が古いだけで merge-base が本来より下がり、ベースが別PRのブランチのスタックPRでは下段PR由来の変更まで混入する（実例: PR #8228、ベースは PR #8153 のブランチ。`origin/<baseRefName>` 基点では merge-base が #8153 より下がり 100ファイル+3076/-66 → 正しい基点（`baseRefOid` = #8153 の現HEAD）では 52ファイル+1626/-11）

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
   impact=$(cat <state>/impact-pr<番号>)
   herdr agent prompt pr<番号> "/code-review:code-review 敵対的検証をして。影響度は $impact。この影響度に応じた effort でレビューすること。レビューは読み取り専用で行い、指摘はこのセッションに返答すること。GitHub の PR、レビュー、コメント、issue を含む外部サービスへは一切書き込まないこと。"
   sleep 2
   herdr agent send-keys pr<番号> enter
   ```
   送信できたかは `herdr agent get pr<番号>` が working になったかで確認する。ならなければ `herdr agent read pr<番号> --source visible` で入力欄の残留を見る（working 中の agent に `--source recent-unwrapped` を使うと `agent_not_idle` で拒否される）。キューに積んでしまった場合は `herdr agent send-keys pr<番号> up`（キューを入力欄へ戻す）→ `herdr agent send-keys pr<番号> ctrl+u`（クリア）で解除する。

9. 初回だけ PR 解説を起動する。まず生成先が Git ignore 済みか確認する。次が非0なら生成先を変えず、解説の起動失敗として報告して step 10 へ進む。
   ```bash
   git -C <worktreeパス> check-ignore -q .cache/pr-review/pr<番号>/show-me.html
   ```
   `herdr pane list --workspace <id>` から root tab でラベルが `PR explanation` の pane を探し、0件なら次で `<root pane>` の右側へ作る。1件ならその pane を再利用し、複数件なら解説の起動失敗として報告する。
   ```bash
   herdr pane split <root pane> --direction right --cwd <worktreeパス> --no-focus
   herdr pane rename <返却されたpane_id> "PR explanation"
   ```
   `<show pane>` を得たら、step 7 の起動と初回 argv prompt の待機を、agent 名 `pr<番号>-show`、pane `<show pane>`、モデル `sonnet` に置き換えて実行する。起動済みの同名 agent がいれば `herdr agent get pr<番号>-show` が返す pane と状態を使い、`agent start` を重ねない。

   `<state>/show-me-started-pr<番号>` が無く、agent が idle または done になったら次を送る。HTMLなどの生成物は Cage の書き込み範囲内にある Git ignore 済みのディレクトリへ置く。
   ```bash
   mkdir -p <worktreeパス>/.cache/pr-review/pr<番号>
   herdr agent prompt pr<番号>-show "/show-me PR #<番号> の変更をレビューしやすい形で解説して。差分の基準は <baseRefOid>...HEAD。影響度は $impact。HTMLなどのファイルを生成する場合は <worktreeパス>/.cache/pr-review/pr<番号>/ の下だけに保存すること。GitHub の PR、レビュー、コメント、issue を含む外部サービスへは一切書き込まないこと。"
   sleep 2
   herdr agent send-keys pr<番号>-show enter
   ```
   `herdr agent get pr<番号>-show` が working になったら `<state>/show-me-started-pr<番号>` を touch する。idle または done なら `herdr agent read pr<番号>-show --source recent-unwrapped --lines 150` で show-me の結果が返ったことを確認してから同じファイルを touch する。起動、準備完了待機、prompt の送信、実行開始または完了の確認のどれかに失敗したら、`herdr agent read pr<番号>-show --source visible` または `herdr pane read <show pane>` で原因を確認して報告し、code-review は止めず step 10 へ進む。blocked なら「blocked への回答」を使う。新規作成した pane で agent の起動に失敗し、blocked でもなければ `herdr pane close <show pane>` でその pane だけを閉じる。

10. `git -C <worktreeパス> rev-parse HEAD` の結果を `<state>/reviewed-sha-pr<番号>` に書く（次回スイープの再レビュー判定が、この時点の HEAD から PR が進んでいるかを見る基準にする）。`<worktreeパス>` を `<state>/worktree-pr<番号>` に書く（片付けが参照する。sweep.json はスイープごとに上書きされ、マージ済みPRは消えるので当てにしない）。`launched.txt` に番号を追記し、Monitor の persistent task として `herdr agent wait pr<番号> --timeout 3600000` を実行して監視をアームする。返却された task ID を `<state>/monitor-pr<番号>-task-id` に記録する。`pr<番号>-show` が working または blocked なら同様に `herdr agent wait pr<番号>-show --timeout 3600000` をアームし、task ID を `<state>/monitor-show-pr<番号>-task-id` に記録する。idle または done ならその場で結果を読み、解説が完了したと報告する。

step 1〜8 のどれかが失敗したら（各 step の「失敗として扱う」はすべてここへ来る）: 原因を確認し（step 7 以降の失敗なら `herdr agent read pr<番号> --source visible`、それ以前なら `herdr pane read <pane_id>`）、**この起動試行で自分が新規に作ったものだけ**を片付ける。

- workspace: step 3 の 0 件分岐で `herdr worktree open` した場合のみ閉じる。step 3 で既存が 1 件ヒットしていたなら残す。ただし次の worktree 削除に該当するときは、その workspace も一緒に閉じる。フックが作った直後のものであり、worktree を消せば行き先を失うため。
- worktree: step 1 の `wt switch` 出力が `✓ Created worktree` だった場合のみ `wt remove --foreground --reap <worktreeパス>` で消す。`○ Switched to worktree` なら**既存の worktree なので消さない**（他の作業の未コミット変更を巻き込む）。
- タブとエージェント: どちらの分岐でも個別に止めない。workspace を閉じるなら pane ごと落ちる。workspace を残すなら editor / diff タブ、step 5 で新規作成した agent review タブ、起動済みの `pr<番号>` エージェントも残るが、そのままでよい。再試行時は step 3 が同じ workspace を 1 件ヒットで拾い、step 5・6 が既存タブを再利用する。

`launched.txt` に番号を**追記した上で**ユーザーに報告する。追記するのは自動再試行の無限ループを防ぐため。再試行はユーザーの指示で launched.txt から番号を消して行う。step 9 の失敗だけならレビュー起動は成功として扱う。

完了基準: `agent start` の成功、または `agent_not_ready` 後に同名 agent が idle または done になったことと初回 argv prompt の idle または done を確認し、step 8 で `herdr agent get pr<番号>` が working になっていること。加えて、`pr<番号>-show` の監視をアームしたか、完了または失敗を報告済みであること。code-review の確認に失敗した場合は、`launched.txt` への追記と原因の報告まで終える。

## 再レビュー（PR 1件ごと）

スイープ step 3 の再レビュー候補に対して実行する。新規の worktree・workspace・エージェントは作らない。既存の `pr<番号>` エージェントへ指示を送るだけである。

1. パッチID比較で実変更の有無を判定する。rebase は HEAD の SHA を必ず変えるが、PR が加える変更は1行も変わっていないことが多く、SHA 比較だけでは無関係な通知のたびにフルレビューが走ってしまう（実例: PR #8152、3回 rebase いずれも内容ゼロ変化）。累積差分のパッチIDを新旧で比較する（コミット単位ではなく累積差分で比較すること。`git log -N` のコミット単位比較はコミット数が変わると破綻する。実例で一度誤判定した）:
   ```bash
   base=$(gh pr view <番号> --json baseRefOid --jq .baseRefOid)
   git fetch origin <baseRefName> <headRefName>
   old=$(cat <state>/reviewed-sha-pr<番号>); new=$(gh pr view <番号> --json headRefOid --jq .headRefOid)
   omb=$(git merge-base "$old" "$base"); nmb=$(git merge-base "$new" "$base")
   o=$(git diff "$omb".."$old" | git patch-id --stable | awk '{print $1}')
   n=$(git diff "$nmb".."$new" | git patch-id --stable | awk '{print $1}')
   ```
   `git patch-id --stable` は行番号・文脈行の位置ズレを吸収するので、rebase による見かけの差分を実変更と誤判定しない。

   - **`$o` と `$n` が一致（純粋な rebase）**: PR が加える変更は1行も変わっていない。下記の worktree 最新化だけ行い、フルレビューはしない。追いついたら `<state>/reviewed-sha-pr<番号>` を `$new` で更新し、この PR の再レビューは完了とする。
   - **不一致（実変更あり）**: `git diff --stat "$omb".."$old"` と `git diff --stat "$nmb".."$new"` を比較し、変わったファイルを特定する（step 3・4 で使う）。以降を続ける。

   worktree を最新化する。「レビュー起動」step 2 の HEAD 追いつき手順（fetch → `git status --porcelain` → `rev-list --left-right --count` → `merge --ff-only`。fetch は上のパッチID比較で済んでいれば省略してよい）を、sweep.json の最新の `baseRefName` を使ってそのまま実行する。親PRのマージ等でベースブランチが変わっていることがある。ただし divergent で force-push と確認できても、workspace を作り直す分岐だけは再レビューでは取らない。動いている `pr<番号>` エージェントと workspace を道連れに消してしまい、以降の step が前提とする「既存エージェントへ指示を送るだけ」が崩れるためである。この分岐に該当したら reflog の確認結果を添えてユーザーへ報告し、作り直すかどうかの判断を仰ぐ。
2. diff タブを張り直す。ベースブランチが変わっていれば古い diff タブは前回の base のままで使えないし、前セッションのプロセス再起動でタブ自体が消えていることもある。`herdr workspace list` からラベル `review-#<番号>` の workspace を引き、diff タブがあれば閉じてから「レビュー起動」step 6 と同じ手順で `<baseRefOid>...HEAD` を基点に張る（`<baseRefOid>` は step 1 の `$base` を再利用する）。
3. 前回のレビュー以降の変更を控える。追加されたコミットの SHA とメッセージ、step 1 で特定した変わったファイルを `git -C <worktreeパス> log` 等で確認する。
4. レビューの深度を決める。`<me>` がこのPRへレビューを投稿済みかで分岐する:
   ```
   gh pr view <番号> --json latestReviews \
     --jq '[.latestReviews[] | select(.author.login == "<me>") | .state]'
   ```
   - **空配列**: 初回レビューの指摘はまだPRへ渡っていない。**フルレビュー**を指示する。
   - **1件以上**（`COMMENTED` / `CHANGES_REQUESTED` / `APPROVED`）: ユーザーが初回レビューの指摘をPRへ渡し済みで、今回の差分はその応答である。**軽量チェック**を指示する。code-review スキルは1つのPRにつき初回の1回だけ走らせる。同じ観点で20分・数百kトークンを再消費しても、初回指摘の解消確認以上のものは出ない。
5. `herdr agent prompt pr<番号>` で再レビューを指示する。深度によらず次を含める:
   - 再度レビュー依頼が来たので再レビューすること
   - 前回のレビュー以降に何が変わったか（step 3 のコミットと変わったファイル、ベースブランチが変わったならその旨）
   - worktree を最新化済みであること
   - 差分の基準（`<baseRefOid>...HEAD`）
   - 従来と同じ制約（読み取り専用、結果はこのセッションに返答、GitHub を含む外部サービスへ一切書き込まない）

   深度ごとに次を足す。フルレビューでは `impact=$(cat <state>/impact-pr<番号>)` で初回の影響度を読む:
   - **フルレビュー**: `/code-review:code-review 敵対的検証をして。影響度は $impact。この影響度に応じた effort でレビューすること` で始める。レビュー範囲は step 1 で特定した変わったファイルに絞ってよいこと（フルレビューより速く正確だった。実例: 3分55秒で完了）
   - **軽量チェック**: 初回レビューで自分が挙げた指摘を1件ずつ挙げ直し、解消・未解消・対応不要のどれかを判定すること。加えて step 1 で特定した変わったファイルだけを通し読みし、新たな問題があれば挙げること。この2点だけで完結させ、`/code-review:code-review` は実行しないこと。結果は判定と新規指摘の有無を数行で返すこと。

   送信後の扱い（`send-keys enter` の追い打ち、`herdr agent get` で working を確認、`reviewed-sha-pr<番号>` の更新、`launched.txt` への記録、Monitor での `herdr agent wait` アーム）は「レビュー起動」step 8〜9 と同じ。

完了基準: 再レビュー候補全件についてパッチID比較を終え、純粋な rebase と判定したものは worktree の最新化と `reviewed-sha-pr<番号>` の更新を、実変更ありと判定したものは worktree の最新化・diff タブの張り直し・深度の判定・再レビュー指示の送信を終え `herdr agent get pr<番号>` が working になっていること。

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

`<state>/monitor-show-pr<番号>-task-id` の wait が戻ったときは `herdr agent get pr<番号>-show` で分岐する。idle または done なら `herdr agent read pr<番号>-show --source recent-unwrapped --lines 150` で結果を読み、PR 解説が完了したとユーザーへ報告して再アームしない。blocked なら「blocked への回答」を実行し、回答を送った場合だけ同じ wait を再アームして新しい task ID でファイルを上書きする。timeout なら同じ wait を再アームする。agent を取得できないなど、それ以外の失敗は原因を報告して終了し、code-review の監視には影響させない。

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

worktree を残す分岐でも、`launched.txt` と `seen.txt` から番号を消す（消し方は「片付けの実行」step 5）。残骸回収は初回セットアップの一度きりで、この時点の両ファイルは touch したばかりの空である。消す番号が載っていないだけで、手順を飛ばすわけではない。実際に効くのは `GONE_PR` 起点のときだけである。5分ごとの再通知を止めるためで、消しても poll.txt に載っていない以上スイープは再起動しない。ただし code-review と show-me の監視タスクは止めない。エージェントがまだ動いている可能性があり、止めると結果を取りこぼす。片付けの実行へ進む分岐では、その step 5 が同じ後始末をする。再びレビュー依頼が来たら新規PRとして扱われるが、「レビュー起動」step 3 が worktree パスで既存 workspace を拾うので、残っていればそれを再利用する。

自動で片付けてよい根拠は `gh pr view` が返す state と `<me>` の approve、そしてユーザーの明示的な指示だけである。次はいずれも根拠にならない:

- レビューエージェントが idle / done になったこと
- 指摘をユーザーへ報告し終えたこと
- PR にコメントやレビューが投稿されたこと（`<me>` の APPROVED 以外は、ユーザーが見終えた証拠にならない。このスキルはそもそも GitHub へ書き込まないので、投稿の主体はエージェント以外の誰かである）
- `review-requested:@me` の一覧から消えたこと（`GONE_PR` は調査の合図であって、削除の許可ではない）

完了基準: `GONE_PR` / 残骸回収 起点の対象PR全件について `gh pr view` を引き終え、片付けたものと残したものをユーザーへ報告済みであること。

## 片付けの実行

PR 1件ごとに step 1〜5 を通しで走らせる。複数件あるときは番号の昇順で1件ずつ完結させる（step 単位で横断しない。途中で失敗したPRの影響を他へ広げないため）。

1. `<state>/monitor-pr<番号>-task-id` と `<state>/monitor-show-pr<番号>-task-id` のうち存在する各ファイルから task ID を読み、TaskStop に渡してから unlink する。ファイルが無ければその対象を飛ばす。前セッションの残骸を回収する経路では監視をアームしていないので必ず不在になる。
2. `herdr workspace list` からラベル `review-#<番号>` の workspace ID を得て `herdr workspace close <id>` する。code-review、show-me、editor、diff の全 pane が閉じ、worktree を掴んでいる claude、nvim、hunk が落ちる。該当 workspace が無ければこの手順を飛ばす。
3. `<state>/worktree-pr<番号>` からパスを読み、`wt remove --foreground --reap <worktreeパス>` を実行する。`--foreground` は削除完了までブロックさせて結果を確かめるため、`--reap` は worktree 内に残ったプロセス（LSP・ウォッチャー等）を先に落とすために付ける。マージ済みならブランチも一緒に消える。
4. `test ! -d <worktreeパス>` で worktree が実際に消えたことを確かめ、消えていれば `unlink <state>/worktree-pr<番号>` でそのファイルを消す。残っていれば `wt remove` の出力と**残った worktree の絶対パス**をユーザーへ報告し、worktree はそのまま残す。`-f` / `-D` は使わない。未コミットの変更が理由で消せないのは、レビューが読み取り専用のはずなのに書き込みが起きた合図なので、握り潰さずユーザーの判断に渡す。step 2 で workspace を閉じた以上、この worktree は次セッションの残骸回収（`review-#<番号>` ラベルの走査）にも引っかからない。報告したパスがユーザーの手がかりのすべてになる。
5. `launched.txt` と `seen.txt` に番号が残っていれば消す: `awk -v n=<番号> '$0 != n' <ファイル> > <ファイル>.tmp && mv <ファイル>.tmp <ファイル>` を両方に対して実行する。`<state>/reviewed-sha-pr<番号>`、`<state>/impact-pr<番号>`、`<state>/show-me-started-pr<番号>` のうち存在するファイルを unlink する（PR が閉じたか approve 済みなので、この PR の再レビュー判定はもう発生しない）。**step 3 / 4 の成否によらず実行する**。worktree が消せなかったときも `GONE_PR` の再通知は止める。5 分ごとに同じ判断を蒸し返しても結論は変わらず、消せない理由はユーザーの手にしか無いため。

完了基準: worktree が消えているか、消せなかった事実をユーザーへ報告済みであること。

## 停止

ユーザーが停止を指示したら: `watcher-task-id` と、`<state>` に**ファイルとして存在する**各 `monitor-pr<番号>-task-id`、`monitor-show-pr<番号>-task-id` の task ID を TaskStop に渡して止め（既に戻った wait の失効 ID が混ざっても構わない。生きているものを取りこぼす方が悪い）、レビューの一覧（PR番号、影響度、workspace ID、worktree パス、code-review と show-me の `herdr agent get` が返す status）を報告して終わる。workspace、worktree、エージェントはすべて残す。停止は片付けの根拠にならない。残りも消したいとユーザーが言ったら、各PRについて「片付けの実行」を走らせる。

レビュー済みPRへの再レビュー依頼はスイープが自動で拾う。既存の `pr<番号>` エージェントが idle または done で（working / blocked は対象外）、かつ PR の現在の HEAD が `<state>/reviewed-sha-pr<番号>` に記録した前回レビュー時点の SHA と異なる場合だけ再レビュー候補になる。**`launched.txt` への掲載は条件にしない**。片付けで launched.txt から番号が消えても pr<番号> エージェントが動いていれば拾われる一方、HEAD が前回から1コミットも進んでいなければ、再依頼が来ても再レビューはしない。エージェントが落ちている、またはそもそも存在しないPRを再レビューしたいときは、ユーザーが `launched.txt` から番号を消せば新規PRとして「レビュー起動」に乗る。`NEW_PR` 通知も再度必要なら `seen.txt` からも消す。トリアージで対象外にしたPRをレビューしたいときは `skipped.txt` から番号を消す。検知は個人宛の `review-requested:@me` のみで、チーム宛のレビュー依頼は対象外。
