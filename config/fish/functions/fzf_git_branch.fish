function fzf_git_branch
    # 現在のブランチを取得
    set current_branch (env GIT_OPTIONAL_LOCKS=0 git branch --show-current 2>/dev/null)

    # gitリポジトリでない場合は終了
    if test -z "$current_branch"
        echo "Not in a git repository"
        return 1
    end

    # ブランチ一覧を取得
    set -l branches (env GIT_OPTIONAL_LOCKS=0 git branch -a | \
        grep -v HEAD | \
        sed "s/.* //" | \
        sed "s#remotes/[^/]*/##" | \
        sort -u)

    # PR情報を取得 (失敗時は警告してブランチ表示のみ継続)
    set -l pr_rows
    if type -q gh
        if type -q jq
            set -l pr_json (gh pr list --state all --limit 200 --json number,title,state,headRefName,updatedAt 2>/dev/null)
            if test $status -eq 0
                set pr_rows (printf '%s\n' "$pr_json" | jq -r '
                    map(select(.headRefName? and .headRefName != ""))
                    | sort_by(.headRefName)
                    | group_by(.headRefName)
                    | map(max_by([
                        (if .state == "OPEN" then 2 elif .state == "MERGED" then 1 else 0 end),
                        (.updatedAt // "")
                    ]))
                    | .[]
                    | "\(.headRefName)\tPR #\(.number) \(.title)"
                ' 2>/dev/null)
                if test $status -ne 0
                    echo "Warning: failed to parse PR data; showing branches only." 1>&2
                    set pr_rows
                end
            else
                echo "Warning: failed to fetch PR data via gh; showing branches only." 1>&2
            end
        else
            echo "Warning: jq is not available; showing branches only." 1>&2
        end
    else
        echo "Warning: gh is not available; showing branches only." 1>&2
    end

    # ブランチ表示行を作成 (PRがある場合は併記)
    set -l display_lines
    for candidate in $branches
        set -l pr_info ""
        if test (count $pr_rows) -gt 0
            set pr_info (printf '%s\n' $pr_rows | awk -F '\t' -v branch="$candidate" '$1==branch{print $2; exit}')
        end

        if test -n "$pr_info"
            set -a display_lines (string join \t -- "$candidate" "$pr_info")
        else
            set -a display_lines "$candidate"
        end
    end

    # 表示はブランチ+PR情報、実際にswitchするのはブランチ名のみ
    set -l selected (printf '%s\n' $display_lines | \
        fzf --height 40% \
            --border \
            --prompt="Switch to branch> " \
            --header="Current: $current_branch" \
            --delimiter='\t' \
            --preview="env GIT_OPTIONAL_LOCKS=0 git log --oneline --graph --color=always {1} | head -20")

    set -l branch (string split -m 1 \t -- "$selected")[1]

    # ブランチが選択された場合のみswitchを実行
    if test -n "$branch"
        git switch $branch
        commandline -f repaint
    end
end
