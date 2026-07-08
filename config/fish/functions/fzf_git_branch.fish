function fzf_git_branch
    set -l current_branch (env GIT_OPTIONAL_LOCKS=0 git branch --show-current 2>/dev/null)

    if test -z "$current_branch"
        echo "Not in a git repository"
        return 1
    end

    set -l branches (begin
        env GIT_OPTIONAL_LOCKS=0 git for-each-ref --format='%(refname:lstrip=2)' refs/heads
        env GIT_OPTIONAL_LOCKS=0 git for-each-ref --format='%(refname:lstrip=3)' refs/remotes | \
            string match -v HEAD
    end | \
        sort -u)

    set -l branch (printf '%s\n' $branches | \
        fzf --height 40% \
            --border \
            --prompt="Switch to branch> " \
            --header="Current: $current_branch" \
            --preview="env GIT_OPTIONAL_LOCKS=0 git log --oneline --graph --color=always {1} | head -20")

    if test -n "$branch"
        git switch $branch
        commandline -f repaint
    end
end
