set --global mock_selected_path (pwd)

function ghq
    printf '%s\n' "$mock_selected_path"
end

function fzf
end

function _fzf_wrapper
    while read -l candidate
    end
    printf '%s\n' "$mock_selected_path"
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
