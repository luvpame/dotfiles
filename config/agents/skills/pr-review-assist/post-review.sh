#!/usr/bin/env bash
# crit のコメント JSON を GitHub の Pull Request Review へ GraphQL 3段構え
# （addPullRequestReview → addPullRequestReviewThread ×N → submitPullRequestReview）
# で投稿する。REST の一括レビュー API はファイルスコープコメントを表現できず
# 422 で全滅するため使わない。詳細は pr-review-assist/SKILL.md を参照。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
post-review.sh --pr <番号> --commit <headRefOid> [--dry-run] <comments.json>...
post-review.sh --self-check
USAGE
}

# crit comments --json の1件を GraphQL スレッド variables へ写像する jq フィルタ。
# 入力: crit JSON 配列を jq -s add で連結したもの。
# 出力: {threads: [...], review_body: string|null, counts: {...}}
read -r -d '' MAP_FILTER <<'JQ' || true
def norm_side(s): if s == "old" then "LEFT" else "RIGHT" end;

def combined_body:
  ([.body] + ((.replies // []) | map(.body))) | join("\n\n---\n");

def kept:
  map(select(
    (.dom_anchor // null) == null and
    (.resolved // false) != true and
    ((.github_id // 0) == 0)
  ));

def to_thread:
  . as $c
  | ($c | combined_body) as $b
  | if $c.scope == "file" then
      {path: $c.path, body: $b, subjectType: "FILE"}
    else
      ($c.side // "") as $rawside
      | norm_side($rawside) as $side
      | {path: $c.path, body: $b, subjectType: "LINE", line: $c.end_line, side: $side} as $base
      | if ($c.start_line != null and $c.start_line != $c.end_line and $c.start_line > 0)
        then $base + {startLine: $c.start_line, startSide: $side}
        else $base end
    end;

kept as $k
| ($k | map(select(.scope == "line" or .scope == "file")) | map(to_thread)) as $threads
| ($k | map(select(.scope == "review")) | map(combined_body)) as $reviews
| {
    threads: $threads,
    review_body: (if ($reviews | length) > 0 then ($reviews | join("\n\n---\n")) else null end),
    counts: {
      line: ($k | map(select(.scope == "line")) | length),
      file: ($k | map(select(.scope == "file")) | length),
      review: ($reviews | length),
      skipped: ((length) - ($k | length))
    }
  }
JQ

self_check() {
  local fixture result fail=0

  # 判定表の全分岐を1件ずつ含む。id 6/7/8 はそれぞれ resolved / dom_anchor / github_id でスキップされる。
  fixture='[
    {"id":1,"scope":"file","path":"foo.rb","start_line":0,"end_line":0,"side":null,"body":"file comment","resolved":false,"github_id":0,"dom_anchor":null,"replies":[]},
    {"id":2,"scope":"line","path":"bar.rb","start_line":10,"end_line":10,"side":null,"body":"line comment","resolved":false,"github_id":0,"dom_anchor":null,"replies":[]},
    {"id":3,"scope":"line","path":"baz.rb","start_line":5,"end_line":8,"side":"old","body":"range comment","resolved":false,"github_id":0,"dom_anchor":null,"replies":[]},
    {"id":4,"scope":"line","path":"qux.rb","start_line":0,"end_line":5,"side":"","body":"zero start","resolved":false,"github_id":0,"dom_anchor":null,"replies":[]},
    {"id":5,"scope":"review","path":null,"start_line":null,"end_line":null,"side":null,"body":"overall review comment","resolved":false,"github_id":0,"dom_anchor":null,"replies":[]},
    {"id":6,"scope":"line","path":"skip1.rb","start_line":1,"end_line":1,"side":null,"body":"resolved","resolved":true,"github_id":0,"dom_anchor":null,"replies":[]},
    {"id":7,"scope":"line","path":"skip2.rb","start_line":1,"end_line":1,"side":null,"body":"live pin","resolved":false,"github_id":0,"dom_anchor":"anchor-xyz","replies":[]},
    {"id":8,"scope":"line","path":"skip3.rb","start_line":1,"end_line":1,"side":null,"body":"already on github","resolved":false,"github_id":12345,"dom_anchor":null,"replies":[]},
    {"id":9,"scope":"line","path":"thread.rb","start_line":20,"end_line":20,"side":null,"body":"parent","resolved":false,"github_id":0,"dom_anchor":null,"replies":[{"body":"reply one"},{"body":"reply two"}]}
  ]'
  result=$(jq -c "$MAP_FILTER" <<<"$fixture")

  check() {
    local desc="$1" expr="$2"
    if jq -e "$expr" >/dev/null 2>&1 <<<"$result"; then
      echo "OK: $desc"
    else
      echo "FAIL: $desc" >&2
      fail=1
    fi
  }

  check "counts" '.counts == {line:4,file:1,review:1,skipped:3}'
  check "threads count" '(.threads | length) == 5'
  check "file scope: no line key, subjectType FILE" \
    '(.threads[] | select(.path=="foo.rb")) == {path:"foo.rb",body:"file comment",subjectType:"FILE"}'
  check "line scope: default side RIGHT, no startLine" \
    '(.threads[] | select(.path=="bar.rb")) == {path:"bar.rb",body:"line comment",subjectType:"LINE",line:10,side:"RIGHT"}'
  check "line scope: side old -> LEFT, multi-line -> startLine/startSide" \
    '(.threads[] | select(.path=="baz.rb")) == {path:"baz.rb",body:"range comment",subjectType:"LINE",line:8,side:"LEFT",startLine:5,startSide:"LEFT"}'
  check "line scope: start_line=0 is not > 0, so no startLine even though start_line != end_line" \
    '(.threads[] | select(.path=="qux.rb")) == {path:"qux.rb",body:"zero start",subjectType:"LINE",line:5,side:"RIGHT"}'
  check "replies concatenated with parent body" \
    '(.threads[] | select(.path=="thread.rb") | .body) == "parent\n\n---\nreply one\n\n---\nreply two"'
  check "review scope becomes review_body, not a thread" \
    '.review_body == "overall review comment"'
  check "resolved/dom_anchor/github_id skips do not leak into threads" \
    '([.threads[].path] | inside(["foo.rb","bar.rb","baz.rb","qux.rb","thread.rb"]))'

  if [[ "$fail" -eq 0 ]]; then
    echo "self-check: all assertions passed"
    return 0
  else
    echo "self-check: FAILED" >&2
    return 1
  fi
}

print_dry_run() {
  local result="$1"
  local line file review skipped
  line=$(jq -r '.counts.line' <<<"$result")
  file=$(jq -r '.counts.file' <<<"$result")
  review=$(jq -r '.counts.review' <<<"$result")
  skipped=$(jq -r '.counts.skipped' <<<"$result")

  echo "投稿予定: LINE ${line} / FILE ${file} / review-level ${review}（スキップ ${skipped}）"
  echo
  jq -r '.threads[] | "[\(.subjectType)] \(.path)" + (if .line then ":\(.line)" else "" end) + " — " + (.body | gsub("\n"; " ") | .[0:80])' <<<"$result"
  # レビュー本文も同じ jq のコードポイント単位スライスでプレビューを揃える（cut -c はバイト単位でマルチバイト文字を割る）。
  jq -r 'if (.review_body // "") == "" then empty else "[REVIEW] (submitPullRequestReview.body) — " + (.review_body | gsub("\n"; " ") | .[0:80]) end' <<<"$result"
}

post_review() {
  local pr="$1" commit="$2" result="$3"
  local pr_node_id review_id

  pr_node_id=$(gh pr view "$pr" --json id -q .id)

  review_id=$(gh api graphql \
    -f query='
      mutation($pr: ID!, $commit: GitObjectID!) {
        addPullRequestReview(input: {pullRequestId: $pr, commitOID: $commit}) {
          pullRequestReview { id }
        }
      }' \
    -f pr="$pr_node_id" -f commit="$commit" \
    -q .data.addPullRequestReview.pullRequestReview.id)

  local delete_cmd="gh api graphql -f query='mutation{deletePullRequestReview(input:{pullRequestReviewId:\"${review_id}\"}){clientMutationId}}'"

  local thread_query='
    mutation($reviewId: ID!, $path: String!, $body: String!, $subjectType: PullRequestReviewThreadSubjectType!, $line: Int, $side: DiffSide, $startLine: Int, $startSide: DiffSide) {
      addPullRequestReviewThread(input: {pullRequestReviewId: $reviewId, path: $path, body: $body, subjectType: $subjectType, line: $line, side: $side, startLine: $startLine, startSide: $startSide}) {
        thread { id }
      }
    }'

  local total ok=0
  total=$(jq '.threads | length' <<<"$result")

  local thread
  while IFS= read -r thread; do
    local path body subject line side start_line start_side resp
    path=$(jq -r '.path' <<<"$thread")
    body=$(jq -r '.body' <<<"$thread")
    subject=$(jq -r '.subjectType' <<<"$thread")
    line=$(jq -r '.line // empty' <<<"$thread")
    side=$(jq -r '.side // empty' <<<"$thread")
    start_line=$(jq -r '.startLine // empty' <<<"$thread")
    start_side=$(jq -r '.startSide // empty' <<<"$thread")

    local args=(-f query="$thread_query" -f reviewId="$review_id" -f path="$path" -f body="$body" -f subjectType="$subject")
    [[ -n "$line" ]] && args+=(-F line="$line")
    [[ -n "$side" ]] && args+=(-f side="$side")
    [[ -n "$start_line" ]] && args+=(-F startLine="$start_line")
    [[ -n "$start_side" ]] && args+=(-f startSide="$start_side")

    if ! resp=$(gh api graphql "${args[@]}" 2>&1) || jq -e '.errors' >/dev/null 2>&1 <<<"$resp"; then
      echo "スレッド追加に失敗しました（${ok}/${total} 件成功、失敗: ${path}${line:+:$line}）" >&2
      echo "$resp" >&2
      echo >&2
      echo "pending レビューは破棄せず残しています: id=${review_id}" >&2
      echo "破棄する場合: ${delete_cmd}" >&2
      return 1
    fi
    ok=$((ok + 1))
  done < <(jq -c '.threads[]' <<<"$result")

  local review_body submit_args
  review_body=$(jq -r '.review_body // empty' <<<"$result")
  submit_args=(-f query='
    mutation($reviewId: ID!, $body: String) {
      submitPullRequestReview(input: {pullRequestReviewId: $reviewId, event: COMMENT, body: $body}) {
        pullRequestReview { id state }
      }
    }' -f reviewId="$review_id")
  [[ -n "$review_body" ]] && submit_args+=(-f body="$review_body")

  local submit_resp
  if ! submit_resp=$(gh api graphql "${submit_args[@]}" 2>&1) || jq -e '.errors' >/dev/null 2>&1 <<<"$submit_resp"; then
    echo "submit に失敗しました（スレッドは全 ${ok} 件投稿済み）" >&2
    echo "$submit_resp" >&2
    echo >&2
    echo "pending レビューは破棄せず残しています: id=${review_id}" >&2
    echo "破棄する場合: ${delete_cmd}" >&2
    return 1
  fi

  echo "投稿完了: スレッド ${ok} 件 + submit(COMMENT)"
  jq -r '.data.submitPullRequestReview.pullRequestReview | "review id=\(.id) state=\(.state)"' <<<"$submit_resp"
}

main() {
  local pr="" commit="" dry_run=0
  local -a files=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --self-check) self_check; exit $? ;;
      --pr) pr="$2"; shift 2 ;;
      --commit) commit="$2"; shift 2 ;;
      --dry-run) dry_run=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) files+=("$1"); shift ;;
    esac
  done

  if [[ -z "$pr" || -z "$commit" || ${#files[@]} -eq 0 ]]; then
    usage
    exit 1
  fi

  local merged result
  merged=$(jq -s 'add' "${files[@]}")
  result=$(jq -c "$MAP_FILTER" <<<"$merged")

  if [[ "$(jq -r '(.threads | length) == 0 and (.review_body == null)' <<<"$result")" == "true" ]]; then
    echo "投稿対象なし（フィルタ後に残ったコメントが0件）"
    exit 0
  fi

  if [[ "$dry_run" -eq 1 ]]; then
    print_dry_run "$result"
    exit 0
  fi

  post_review "$pr" "$commit" "$result"
}

main "$@"
