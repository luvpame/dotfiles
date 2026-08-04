function herdr_worktree_fzf --description 'Open a Git worktree in Herdr'
    set -l new_worktree_label ' New Worktree'
    set -l original_root_label '󰉋 Original Root'
    set -l commands herdr jq fzf wt git direnv
    if test "$argv[1]" = --repo
        set --append commands ghq
    end

    for command in $commands
        if not type -q $command
            echo "herdr_worktree_fzf: $command command is not installed." >&2
            return 127
        end
    end

    if test "$argv[1]" != --repo; and test -z "$HERDR_ACTIVE_WORKSPACE_ID"
        echo 'herdr_worktree_fzf: run this command from a Herdr custom command.' >&2
        return 1
    end

    set -l worktree_source --workspace "$HERDR_ACTIVE_WORKSPACE_ID"
    if test "$argv[1]" = --repo
        set -l repo_path (
            ghq list --full-path | sort --unique | fzf \
                --layout=reverse \
                --prompt='repo> '
        )
        if test -z "$repo_path"
            return
        end
        set worktree_source --cwd "$repo_path"
    end

    set -l worktree_list (herdr worktree list $worktree_source --json)
    or return
    set -l repo_root (printf '%s\n' "$worktree_list" | jq --raw-output '.result.source.repo_root')
    or return

    set -l selection (
        begin
            printf '%s\n' "$new_worktree_label"
            printf '%s\t%s\n' "$original_root_label" "$repo_root"
            printf '%s\n' "$worktree_list" | jq --raw-output '
                .result.source.source_checkout_path as $source
                | .result.source.repo_root as $root
                | .result.worktrees[]
                | select(.path != $source and .path != $root)
                | [.branch, .path]
                | @tsv
            '
        end | fzf \
            --no-sort \
            --layout=reverse \
            --prompt='worktree> '
    )
    if test -z "$selection"
        return
    end

    set -l workspace_id
    set -l worktree_path
    if test "$selection" = "$new_worktree_label"
        read --local --prompt-str='Worktree name: ' worktree_name
        set worktree_name (string trim -- "$worktree_name")
        if test -z "$worktree_name"
            return
        end

        set --local --export HERDR_ENV 1
        git -C "$repo_root" fetch --all
        or return
        set -l branch_refs (git -C "$repo_root" for-each-ref \
            --format='%(refname:short)' \
            refs/heads \
            refs/remotes)
        or return
        set -l create_option
        if not contains -- "$worktree_name" $branch_refs; and not string match --quiet "*/$worktree_name" $branch_refs
            set create_option --create
        end
        set -l worktree_result (direnv exec "$repo_root" wt -C "$repo_root" switch \
            --no-cd \
            $create_option "$worktree_name" \
            --format=json)
        or return
        set worktree_path (printf '%s\n' "$worktree_result" | jq --raw-output '.path')
        or return

        set -l attempt 0
        while test $attempt -lt 50
            set -l updated_worktree_list (herdr worktree list $worktree_source --json)
            or return
            set workspace_id (printf '%s\n' "$updated_worktree_list" | jq --raw-output --arg path "$worktree_path" \
                'first(.result.worktrees[] | select(.path == $path) | .open_workspace_id) // empty')
            if test -n "$workspace_id"
                break
            end

            sleep 0.1
            set attempt (math $attempt + 1)
        end
        if test -z "$workspace_id"
            echo 'herdr_worktree_fzf: timed out waiting for the Worktrunk hook.' >&2
            return 1
        end
        herdr workspace focus "$workspace_id" >/dev/null
        or return
    else
        set -l fields (string split \t -- "$selection")
        set -l response (herdr worktree open \
            $worktree_source \
            --path "$fields[-1]" \
            --focus \
            --json)
        or return
        if printf '%s\n' "$response" | jq --exit-status '.result.already_open == true' >/dev/null
            return
        end
        set -l workspace_fields (
            printf '%s\n' "$response" \
                | jq --raw-output '[
                    .result.workspace.workspace_id,
                    .result.worktree.path
                ] | @tsv' \
                | string split \t
        )
        set workspace_id "$workspace_fields[1]"
        set worktree_path "$workspace_fields[2]"
    end

    set -l tab_list (herdr tab list --workspace "$workspace_id")
    or return
    set -l agent_tab_id (printf '%s\n' "$tab_list" | jq --raw-output \
        'first(.result.tabs[] | select(.label == "agent") | .tab_id) // empty')
    set -l nvim_tab_id (printf '%s\n' "$tab_list" | jq --raw-output \
        'first(.result.tabs[] | select(.label == "nvim") | .tab_id) // empty')

    if test -z "$agent_tab_id"
        set agent_tab_id (printf '%s\n' "$tab_list" | jq --raw-output '.result.tabs[0].tab_id')
        set -l pane_list (herdr pane list)
        or return
        set -l agent_pane_id (printf '%s\n' "$pane_list" | jq --raw-output --arg tab_id "$agent_tab_id" \
            'first(.result.panes[] | select(.tab_id == $tab_id) | .pane_id) // empty')

        herdr tab rename "$agent_tab_id" agent >/dev/null
        or return
        herdr pane run "$agent_pane_id" cc
        or return
    end

    if test -z "$nvim_tab_id"
        set -l nvim_tab (herdr tab create \
            --workspace "$workspace_id" \
            --cwd "$worktree_path" \
            --label nvim \
            --no-focus)
        or return
        set -l nvim_pane_id (printf '%s\n' "$nvim_tab" | jq --raw-output '.result.root_pane.pane_id')
        herdr pane run "$nvim_pane_id" nvim
    end
end
