function ghq_cd_fzf --description 'Search ghq repositories with fzf'
    set -l commands ghq fzf roots
    if test "$argv[1]" = --workspace
        set --append commands herdr jq
    end

    for cmd in $commands
        if not type -q $cmd
            echo "ghq_cd_fzf: $cmd command is not installed." >&2
            return 127
        end
    end

    set -l pane_list
    if test "$argv[1]" = --workspace
        set pane_list (herdr pane list)
        or return
    end

    set -l preview_cmd "
set -l repo_path '{}'

if not test -d \"\$repo_path\"
    echo \"Not found: \$repo_path\"
    exit 0
end

set -l readme
for file in README.md README.rst README.txt README README.MD readme.md readme.rst readme.txt
    if test -f \"\$repo_path/\$file\"
        set readme \"\$repo_path/\$file\"
        break
    end
end

if test -n \"\$readme\"
    if type -q bat
        bat --color=always --language=markdown --paging=never --line-range :80 \"\$readme\"
    else
        sed -n '1,80p' \"\$readme\"
    end
else
    echo \"path: \$repo_path\"
    if test -d \"\$repo_path/.git\"
        set -l branch (env GIT_OPTIONAL_LOCKS=0 git -C \"\$repo_path\" branch --show-current 2>/dev/null)
        if test -n \"\$branch\"
            echo \"branch: \$branch\"
        end

        set -l last_commit (env GIT_OPTIONAL_LOCKS=0 git -C \"\$repo_path\" log -1 --pretty=format:'%h %s (%cr)' 2>/dev/null)
        if test -n \"\$last_commit\"
            echo \"last: \$last_commit\"
        end
    end
end
"

    set -l selected_path (
        begin
            ghq list --full-path | roots
            if test "$argv[1]" = --workspace
                # ponytail: Herdr exposes pane cwd only; persist workspace paths if the first pane stops being representative.
                printf '%s\n' "$pane_list" | jq --raw-output \
                    '.result.panes | unique_by(.workspace_id)[] | .cwd'
            end
        end | sort --unique | _fzf_wrapper \
            --ansi \
            --height 80% \
            --layout=reverse \
            --prompt='ghq roots> ' \
            --preview-window='right:60%:wrap' \
            --preview "$preview_cmd"
    )
    if test -z "$selected_path"
        return
    end

    if test "$argv[1]" != --workspace
        cd "$selected_path"
        return
    end

    set -l workspace_id (printf '%s\n' "$pane_list" | jq --raw-output --arg cwd "$selected_path" \
        'first(.result.panes[] | select(.cwd == $cwd) | .workspace_id) // empty')
    or return

    if test -n "$workspace_id"
        herdr workspace focus "$workspace_id" >/dev/null
    else
        herdr workspace create --cwd "$selected_path" --focus >/dev/null
    end
end
