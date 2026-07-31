set --global herdr_calls
set --global fzf_candidates
set --global mock_selected_path (pwd)
set --global mock_workspace_id existing-workspace
set --global mock_workspace_only_path (path dirname "$mock_selected_path")

function ghq
    printf '%s\n' "$mock_selected_path"
end

function fzf
end

function _fzf_wrapper
    set --global --erase fzf_candidates
    while read -l candidate
        set --global --append fzf_candidates "$candidate"
    end
    printf '%s\n' "$mock_selected_path"
end

function herdr
    set --global --append herdr_calls (string join \t -- $argv)

    if test "$argv[1] $argv[2]" = 'pane list'
        if test -n "$mock_workspace_id"
            printf '{"result":{"panes":[{"cwd":"%s","workspace_id":"%s"},{"cwd":"%s","workspace_id":"workspace-only"},{"cwd":"/private/tmp","workspace_id":"workspace-only"}]}}\n' \
                "$mock_selected_path" "$mock_workspace_id" "$mock_workspace_only_path"
        else
            printf '{"result":{"panes":[]}}\n'
        end
    end
end

function assert_contains
    contains -- "$argv[1]" $argv[2..]
    or begin
        echo "missing call: $argv[1]" >&2
        exit 1
    end
end

source (path dirname (status filename))/functions/ghq_cd_fzf.fish

set -l original_path (pwd)
set --global mock_selected_path (path dirname "$original_path")
ghq_cd_fzf
or exit 1
test (pwd) = "$mock_selected_path"
or begin
    echo 'selected repository was not entered.' >&2
    exit 1
end
cd "$original_path"

set --global mock_selected_path "$original_path"
ghq_cd_fzf --workspace
or exit 1

assert_contains (string join \t -- pane list) $herdr_calls
assert_contains (string join \t -- workspace focus existing-workspace) $herdr_calls
assert_contains "$mock_workspace_only_path" $fzf_candidates
test (count (string match -- "$mock_selected_path" $fzf_candidates)) -eq 1
or begin
    echo 'duplicate workspace candidate was not removed.' >&2
    exit 1
end
if contains -- /private/tmp $fzf_candidates
    echo 'a second pane from the same workspace became a candidate.' >&2
    exit 1
end

set --global --erase mock_workspace_id
set --global --erase herdr_calls

ghq_cd_fzf --workspace
or exit 1

assert_contains (string join \t -- workspace create --cwd "$mock_selected_path" --focus) $herdr_calls
