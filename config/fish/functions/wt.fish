function wt
    set -l target $argv[1]
    if not string match --quiet '#*' -- "$target"
        gtr new --cd $argv
        return
    end

    if not string match --quiet --regex '^#[1-9][0-9]*$' -- "$target"; or test (count $argv) -ne 1
        echo "Usage: wt <branch> | wt '#<pr-number>'" >&2
        return 2
    end

    set -l pr_number (string replace '#' '' -- "$target")
    set -l branch "pr-$pr_number"
    git fetch origin "pull/$pr_number/head:$branch"; or return
    gtr new --cd "$branch" --no-fetch
end
