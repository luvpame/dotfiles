# Herdr PR Review Worktree Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 現在のリポジトリで reviewer に指定された PR を選び、レビュー専用 worktree の新しい Herdr workspace 全域に Hunk の PR 差分を表示する。

**Architecture:** レビュー専用 Fish 関数 `review-pr` が `gh`、`fzf`、`git gtr`、Herdr CLI を順に制御する。Herdr の `prefix+shift+g` は popup でこの関数を呼び、新しい workspace の root pane に Hunk を起動する。

**Tech Stack:** Fish、GitHub CLI、fzf、git-gtr、Herdr CLI、jq、Hunk、TOML

## Global Constraints

- 現在の GitHub リポジトリだけを対象にする。
- 既存の `wt` 関数は変更せず、`review-pr` からも呼び出さない。
- ローカル branch 名は `review-pr-<PR番号>` とする。
- 同名の branch または worktree は自動削除や再利用をしない。
- Herdr workspace と tab は改名しない。
- Hunk は split pane を作らず、新しい workspace の root pane 全域で起動する。
- 新しい依存関係は追加しない。

---

### Task 1: レビュー専用 Fish 関数

**Files:**
- Create: `config/fish/functions/review-pr.fish`
- Create: `config/fish/test-review-pr.fish`

**Interfaces:**
- Consumes: 現在の Git リポジトリ、`gh pr list` の TSV、`HERDR_ENV` 内の Herdr CLI
- Produces: `review-pr` Fish 関数、新しい review worktree、root pane で動く Hunk

- [ ] **Step 1: 失敗する Fish テストを作成する**

```fish
set --global mock_prs (string join \t 42 main 'Fix reviewer flow')
set --global mock_selection $mock_prs
set --global mock_fzf_status 0
set --global git_calls
set --global herdr_calls

function gh
    printf '%s\n' $mock_prs
end

function fzf
    printf '%s\n' "$mock_selection"
    return $mock_fzf_status
end

function git
    set --global --append git_calls (string join \t -- $argv)
    if test "$argv[1] $argv[2]" = 'rev-parse --show-toplevel'
        printf '/repo\n'
    else if test "$argv[1] $argv[2]" = 'gtr go'
        printf '/repo/.worktrees/review-pr-42\n'
    end
end

function herdr
    set --global --append herdr_calls (string join \t -- $argv)
    if test "$argv[1] $argv[2]" = 'workspace create'
        printf '%s\n' '{"result":{"root_pane":{"pane_id":"root-pane"}}}'
    end
end

function jq
    printf 'root-pane\n'
end

function hunk
end

function assert_contains
    contains -- "$argv[1]" $argv[2..]
    or begin
        echo "missing call: $argv[1]" >&2
        exit 1
    end
end

function assert_no_fetch
    for call in $git_calls
        if string match --quiet 'fetch*' -- "$call"
            echo "unexpected fetch: $call" >&2
            exit 1
        end
    end
end

source (path dirname (status filename))/functions/review-pr.fish

review-pr
or exit 1

assert_contains (string join \t fetch origin '+refs/heads/main:refs/remotes/origin/main' 'refs/pull/42/head:refs/heads/review-pr-42') $git_calls
assert_contains (string join \t gtr new review-pr-42 --no-fetch) $git_calls
assert_contains (string join \t gtr go review-pr-42) $git_calls
assert_contains (string join \t workspace create --cwd /repo/.worktrees/review-pr-42) $herdr_calls
assert_contains (string join \t pane run root-pane 'hunk diff origin/main...HEAD') $herdr_calls

set --global mock_prs
set --global git_calls
set --global herdr_calls
review-pr
or exit 1
assert_no_fetch

set --global mock_prs (string join \t 42 main 'Fix reviewer flow')
set --global mock_selection
set --global mock_fzf_status 130
set --global git_calls
set --global herdr_calls
review-pr
or exit 1
assert_no_fetch
```

- [ ] **Step 2: テストが対象関数未実装で失敗することを確認する**

Run:

```bash
fish config/fish/test-review-pr.fish
```

Expected: `functions/review-pr.fish` が存在しないため FAIL。

- [ ] **Step 3: 最小の `review-pr` 関数を実装する**

```fish
function review-pr --description 'Open a review-requested PR in a Herdr worktree'
    for cmd in gh fzf jq git herdr hunk
        if not type --query $cmd
            echo "review-pr: $cmd command is not installed." >&2
            return 1
        end
    end

    git rev-parse --show-toplevel >/dev/null 2>&1
    or begin
        echo 'review-pr: not inside a Git repository.' >&2
        return 1
    end

    set -l pull_requests (gh pr list \
        --search 'review-requested:@me' \
        --json number,baseRefName,title \
        --jq '.[] | [.number, .baseRefName, .title] | @tsv')
    or return

    if test (count $pull_requests) -eq 0
        echo 'review-pr: no review-requested pull requests.' >&2
        return 0
    end

    set -l selection (printf '%s\n' $pull_requests | fzf \
        --delimiter=\t \
        --with-nth=1,3 \
        --layout=reverse \
        --border \
        --prompt='Review PR> ')
    set -l picker_status $status
    test $picker_status -eq 0; or return 0

    set -l fields (string split \t -- "$selection")
    if test (count $fields) -lt 2; or not string match --quiet --regex '^[1-9][0-9]*$' -- "$fields[1]"; or test -z "$fields[2]"
        echo 'review-pr: invalid pull request selection.' >&2
        return 1
    end

    set -l pr_number $fields[1]
    set -l base_branch $fields[2]
    set -l branch "review-pr-$pr_number"

    git fetch origin \
        "+refs/heads/$base_branch:refs/remotes/origin/$base_branch" \
        "refs/pull/$pr_number/head:refs/heads/$branch"
    or return

    git gtr new "$branch" --no-fetch
    or return

    set -l worktree (git gtr go "$branch")
    or return

    set -l workspace (herdr workspace create --cwd "$worktree")
    or return

    set -l root_pane (printf '%s\n' "$workspace" | jq --exit-status --raw-output '.result.root_pane.pane_id')
    or return

    set -l diff_ref (string escape -- "origin/$base_branch...HEAD")
    herdr pane run "$root_pane" "hunk diff $diff_ref"
end
```

- [ ] **Step 4: Fish テストが通ることを確認する**

Run:

```bash
fish config/fish/test-review-pr.fish
```

Expected: exit 0、標準エラーには「no review-requested pull requests.」だけが表示される。

- [ ] **Step 5: Task 1 をコミットする**

```bash
git add config/fish/functions/review-pr.fish config/fish/test-review-pr.fish
git commit -m "feat(fish): PRレビューworktree関数を追加"
```

### Task 2: Herdr popup キー

**Files:**
- Modify: `config/herdr/config.toml`

**Interfaces:**
- Consumes: `review-pr` Fish 関数、`prefix+shift+g`
- Produces: PR picker popup、失敗内容を確認して閉じる挙動

- [ ] **Step 1: キー設定が未実装であることを確認する**

Run:

```bash
rg -F 'key = "prefix+shift+g"' config/herdr/config.toml
```

Expected: exit 1。

- [ ] **Step 2: popup キー設定を追加する**

`prefix+g` の lazygit 設定の直後に追加する。

```toml
[[keys.command]]
key = "prefix+shift+g"
type = "popup"
description = "review requested PR"
command = "fish -c 'review-pr; set review_status $status; if test $review_status -ne 0; read -P \"Press Enter to close\"; end; exit $review_status'"
width = "80%"
height = "80%"
```

- [ ] **Step 3: キー設定と Herdr 構文を確認する**

Run:

```bash
rg -A 7 -F 'key = "prefix+shift+g"' config/herdr/config.toml
HERDR_CONFIG_PATH="$PWD/config/herdr/config.toml" herdr config check
```

Expected: popup 設定が表示され、`herdr config check` が exit 0。

- [ ] **Step 4: `code-simplifier` を適用し、テストを再実行する**

`config/fish/functions/review-pr.fish` と `config/herdr/config.toml` の変更範囲だけを対象に、既存の動作を保ったまま不要な分岐や重複を削る。

Run:

```bash
fish config/fish/test-review-pr.fish
HERDR_CONFIG_PATH="$PWD/config/herdr/config.toml" herdr config check
git diff --check
just check
```

Expected: すべて exit 0。

- [ ] **Step 5: Task 2 をコミットする**

```bash
git add config/herdr/config.toml
git commit -m "feat(herdr): PRレビューpopupを追加"
```
