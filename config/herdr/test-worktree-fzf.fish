set --global herdr_calls
set --global wt_calls
set --global fzf_candidates
set --global fzf_selection 'New Worktree'
set --global repo_candidates
set --global repo_selection /private/tmp/repo
set --global worktree_path /private/tmp/repo-worktrees/feature
set --global workspace_initialized false
set --global source_checkout_path /private/tmp/repo-worktrees/current

function wt
    set --global --append wt_calls (string join \t -- $argv)
    set --global wt_herdr_env "$HERDR_ENV"
    printf '{"action":"created","branch":"feature","path":"%s"}\n' "$worktree_path"
end

function ghq
    printf '/private/tmp/another-repo\n%s\n' "$repo_selection"
end

function herdr
    set --global --append herdr_calls (string join \t -- $argv)

    switch "$argv[1] $argv[2]"
        case 'worktree list'
            set -l created_worktree
            if test (count $wt_calls) -gt 0
                set created_worktree ',{"branch":"feature","path":"/private/tmp/repo-worktrees/feature","open_workspace_id":"worktree-workspace"}'
            end
            printf '{"result":{"source":{"repo_root":"/private/tmp/repo","source_checkout_path":"%s"},"worktrees":[{"branch":"main","path":"/private/tmp/repo"},{"branch":"current","path":"%s"},{"branch":"existing","path":"/private/tmp/repo-worktrees/existing"}%s]}}\n' \
                "$source_checkout_path" "$source_checkout_path" "$created_worktree"
        case 'worktree open'
            printf '{"result":{"already_open":true,"workspace":{"workspace_id":"worktree-workspace"},"worktree":{"path":"%s"}}}\n' "$worktree_path"
        case 'tab list'
            if $workspace_initialized
                printf '{"result":{"tabs":[{"tab_id":"agent-tab","label":"agent"},{"tab_id":"nvim-tab","label":"nvim"}]}}\n'
            else
                printf '{"result":{"tabs":[{"tab_id":"agent-tab","label":"1"}]}}\n'
            end
        case 'pane list'
            printf '{"result":{"panes":[{"pane_id":"agent-pane","tab_id":"agent-tab"}]}}\n'
        case 'tab create'
            printf '{"result":{"root_pane":{"pane_id":"nvim-pane"}}}\n'
    end
end

function fzf
    if contains -- "--prompt=repo> " $argv
        set --global --erase repo_candidates
        while read --local candidate
            set --global --append repo_candidates "$candidate"
        end
        printf '%s\n' "$repo_selection"
        return
    end

    set --global --erase fzf_candidates
    while read --local candidate
        set --global --append fzf_candidates "$candidate"
    end
    printf '%s\n' "$fzf_selection"
end

function assert_contains
    contains -- "$argv[1]" $argv[2..]
    or begin
        echo "missing call: $argv[1]" >&2
        exit 1
    end
end

function assert_not_contains
    if contains -- "$argv[1]" $argv[2..]
        echo "unexpected call: $argv[1]" >&2
        exit 1
    end
end

source (path dirname (status filename))/worktree-fzf.fish

set --global --erase HERDR_WORKSPACE_ID
set --global --export HERDR_ACTIVE_WORKSPACE_ID main-workspace

printf 'feature\n' | herdr_worktree_fzf
or exit 1

test "$fzf_candidates[1]" = 'New Worktree'
or begin
    echo 'New Worktree was not the first candidate.' >&2
    exit 1
end
assert_contains (string join \t -- existing /private/tmp/repo-worktrees/existing) $fzf_candidates
assert_contains (string join \t -- -C /private/tmp/repo switch --no-cd --create feature --format=json) $wt_calls
test "$wt_herdr_env" = 1
or begin
    echo 'HERDR_ENV was not exported to Worktrunk hooks.' >&2
    exit 1
end
assert_contains (string join \t -- workspace focus worktree-workspace) $herdr_calls
assert_not_contains (string join \t -- worktree open --workspace main-workspace --path "$worktree_path" --focus --json) $herdr_calls
assert_contains (string join \t -- tab rename agent-tab agent) $herdr_calls
assert_contains (string join \t -- pane run agent-pane cc) $herdr_calls
assert_contains (string join \t -- tab create --workspace worktree-workspace --cwd "$worktree_path" --label nvim --no-focus) $herdr_calls
assert_contains (string join \t -- pane run nvim-pane nvim) $herdr_calls

set --global --erase herdr_calls
set --global fzf_selection (string join \t -- existing /private/tmp/repo-worktrees/existing)
set --global worktree_path /private/tmp/repo-worktrees/existing
set --global workspace_initialized false

herdr_worktree_fzf
or exit 1

assert_contains (string join \t -- worktree open --workspace main-workspace --path "$worktree_path" --focus --json) $herdr_calls
assert_not_contains (string join \t -- tab list --workspace worktree-workspace) $herdr_calls
assert_not_contains (string join \t -- tab rename agent-tab agent) $herdr_calls
assert_not_contains (string join \t -- pane run agent-pane cc) $herdr_calls
assert_not_contains (string join \t -- tab create --workspace worktree-workspace --cwd "$worktree_path" --label nvim --no-focus) $herdr_calls

set --global --erase herdr_calls
set --global repo_selection /private/tmp/repo

herdr_worktree_fzf --repo
or exit 1

assert_contains "$repo_selection" $repo_candidates
assert_contains (string join \t -- worktree list --cwd "$repo_selection" --json) $herdr_calls
assert_contains (string join \t -- worktree open --cwd "$repo_selection" --path "$worktree_path" --focus --json) $herdr_calls
