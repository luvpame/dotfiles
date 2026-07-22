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
    or return 0

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
