set --global herdr_calls
set --global wt_calls
set --global git_calls
set --global direnv_calls
set --global fzf_candidates
set --global fzf_selection ' New Worktree'
set --global action_candidates
set --global action_selection ' Worktree 作成・移動'
set --global python_calls
set --global worktree_path /private/tmp/repo-worktrees/feature
set --global workspace_initialized false
set --global source_checkout_path /private/tmp/repo-worktrees/current
set --global git_branch_refs

function wt
    set --global --append wt_calls (string join \t -- $argv)
    set --global wt_herdr_env "$HERDR_ENV"
    if test (count $git_branch_refs) -gt 0; and contains -- --create $argv
        echo 'branch already exists on remote' >&2
        return 1
    end
    printf '{"action":"created","branch":"feature","path":"%s"}\n' "$worktree_path"
end

function git
    set --global --append git_calls (string join \t -- $argv)
    if contains -- fetch $argv
        return
    end
    printf '%s\n' $git_branch_refs
end

function direnv
    set --global --append direnv_calls (string join \t -- $argv)
    $argv[3..]
end

function python3
    set --global --append python_calls (string join \t -- $argv)
end

function herdr
    set --global --append herdr_calls (string join \t -- $argv)

    switch "$argv[1] $argv[2]"
        case 'worktree list'
            set -l created_worktree
            if test (count $wt_calls) -gt 0
                set created_worktree (printf ',{"branch":"feature","path":"%s","open_workspace_id":"worktree-workspace"}' "$worktree_path")
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
    if contains -- "--prompt=repo action> " $argv
        set --global --erase action_candidates
        while read --local candidate
            set --global --append action_candidates "$candidate"
        end
        printf '%s\n' "$action_selection"
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

test "$fzf_candidates[1]" = ' New Worktree'
or begin
    echo ' New Worktree was not the first candidate.' >&2
    exit 1
end
test (string join , -- $action_candidates) = ' PR Review, Worktree 作成・移動,󰉋 Original Root,󰆴 Worktree 削除,󰘬 マージ済み PR の Worktree を一括削除'
or exit 1
assert_not_contains ' PR Review' $fzf_candidates
assert_not_contains (string join \t -- '󰉋 Original Root' /private/tmp/repo) $fzf_candidates
assert_not_contains (string join \t -- main /private/tmp/repo) $fzf_candidates
assert_contains (string join \t -- existing /private/tmp/repo-worktrees/existing) $fzf_candidates
assert_contains (string join \t -- -C /private/tmp/repo switch --no-cd --create feature --format=json) $wt_calls
assert_contains (string join \t -- -C /private/tmp/repo fetch --all) $git_calls
assert_contains (string join \t -- exec /private/tmp/repo wt -C /private/tmp/repo switch --no-cd --create feature --format=json) $direnv_calls
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
assert_contains (string join \t -- workspace focus worktree-workspace) $herdr_calls
assert_not_contains (string join \t -- tab list --workspace worktree-workspace) $herdr_calls
assert_not_contains (string join \t -- tab rename agent-tab agent) $herdr_calls
assert_not_contains (string join \t -- pane run agent-pane cc) $herdr_calls
assert_not_contains (string join \t -- tab create --workspace worktree-workspace --cwd "$worktree_path" --label nvim --no-focus) $herdr_calls

set --global --erase herdr_calls
set --global action_selection '󰉋 Original Root'
set --global --erase fzf_candidates

herdr_worktree_fzf
or exit 1

assert_contains (string join \t -- worktree open --workspace main-workspace --path /private/tmp/repo --focus --json) $herdr_calls

test (count $fzf_candidates) -eq 0
or exit 1

set --global --erase herdr_calls
set --global action_selection ' PR Review'
herdr_worktree_fzf
or exit 1
assert_contains ~/.config/herdr/scripts/pr-review.py $python_calls
test (count $herdr_calls) -eq 0
or exit 1

# Cancel either menu without opening a workspace or starting a review.
for action in '' ' Worktree 作成・移動'
    set --global action_selection "$action"
    set --global fzf_selection ''
    set --global --erase herdr_calls
    set --global --erase python_calls
    herdr_worktree_fzf
    or exit 1
    test (count $python_calls) -eq 0
    or exit 1
    for call in $herdr_calls
        test "$call" = (string join \t -- worktree list --workspace main-workspace --json)
        or exit 1
    end
end

set --global action_selection ' Worktree 作成・移動'
set --global --erase herdr_calls
set --global --erase wt_calls
set --global --erase git_calls
set --global --erase direnv_calls
set --global fzf_selection ' New Worktree'
set --global worktree_path /private/tmp/repo-worktrees/remote-feature
set --global git_branch_refs origin/remote-feature

printf 'remote-feature\n' | herdr_worktree_fzf
or begin
    echo 'Failed to open an existing remote branch.' >&2
    exit 1
end

assert_contains (string join \t -- -C /private/tmp/repo switch --no-cd remote-feature --format=json) $wt_calls
assert_not_contains (string join \t -- -C /private/tmp/repo switch --no-cd --create remote-feature --format=json) $wt_calls
test "$git_calls[1]" = (string join \t -- -C /private/tmp/repo fetch --all)
or begin
    echo 'Remote refs were inspected before fetching.' >&2
    exit 1
end

set --global action_selection '󰆴 Worktree 削除'
herdr_worktree_fzf
or exit 1
assert_contains ~/.config/herdr/scripts/worktree-remove.py $python_calls
set --global action_selection '󰘬 マージ済み PR の Worktree を一括削除'
herdr_worktree_fzf
or exit 1
assert_contains (string join \t -- ~/.config/herdr/scripts/worktree-remove.py --merged) $python_calls
