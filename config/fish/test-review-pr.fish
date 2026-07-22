set --global mock_prs (string join \t 42 main 'Fix reviewer flow')
set --global mock_selection $mock_prs
set --global mock_fzf_status 0
set --global mock_pane_run_status 0
set --global git_calls
set --global herdr_calls

function gh
    if set --query mock_prs[1]
        printf '%s\n' $mock_prs
    end
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
        printf '%s\n' '{"result":{"workspace":{"workspace_id":"review-workspace"},"root_pane":{"pane_id":"root-pane"}}}'
    else if test "$argv[1] $argv[2]" = 'pane run'
        return $mock_pane_run_status
    end
end

function jq
    if string match --quiet '*.workspace.workspace_id' -- "$argv[-1]"
        printf 'review-workspace\n'
    else
        printf 'root-pane\n'
    end
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

assert_contains (string join \t -- fetch origin '+refs/heads/main:refs/remotes/origin/main' 'refs/pull/42/head:refs/heads/review-pr-42') $git_calls
assert_contains (string join \t -- gtr new review-pr-42 --no-fetch) $git_calls
assert_contains (string join \t -- gtr go review-pr-42) $git_calls
assert_contains (string join \t -- workspace create --cwd /repo/.worktrees/review-pr-42) $herdr_calls
assert_contains (string join \t -- pane run root-pane 'hunk diff origin/main...HEAD') $herdr_calls

set -l expected_run (string join \t -- pane run root-pane 'hunk diff origin/main...HEAD')
set -l expected_focus (string join \t -- workspace focus review-workspace)
if test "$herdr_calls[-2]" != "$expected_run"; or test "$herdr_calls[-1]" != "$expected_focus"
    echo 'Hunk did not run before workspace focus.' >&2
    exit 1
end

set --global mock_pane_run_status 1
set --global --erase git_calls
set --global --erase herdr_calls
review-pr
test $status -eq 1
or begin
    echo 'Hunk failure was not propagated.' >&2
    exit 1
end

if contains -- (string join \t -- workspace focus review-workspace) $herdr_calls
    echo 'workspace was focused after Hunk failure.' >&2
    exit 1
end

set --global mock_pane_run_status 0

set --global --erase mock_prs
set --global --erase git_calls
set --global --erase herdr_calls
review-pr
or exit 1
assert_no_fetch

set --global mock_prs (string join \t 42 main 'Fix reviewer flow')
set --global --erase mock_selection
set --global mock_fzf_status 130
set --global --erase git_calls
set --global --erase herdr_calls
review-pr
or exit 1
assert_no_fetch
