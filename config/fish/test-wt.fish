function git
    set --global git_args $argv
    return $git_status
end

function gtr
    set --global gtr_args $argv
end

source (path dirname (status filename))/functions/wt.fish

functions --query wt
or begin
    echo "wt function is not defined" >&2
    exit 1
end

wt feat/example
test "$gtr_args" = "new --cd feat/example"
or begin
    echo "unexpected branch arguments: $gtr_args" >&2
    exit 1
end

wt '#123'
test "$git_args" = "fetch origin pull/123/head:pr-123"
or begin
    echo "unexpected fetch arguments: $git_args" >&2
    exit 1
end

test "$gtr_args" = "new --cd pr-123 --no-fetch"
or begin
    echo "unexpected PR arguments: $gtr_args" >&2
    exit 1
end

wt '#abc' 2>/dev/null
test $status -eq 2
or begin
    echo "invalid PR number was accepted" >&2
    exit 1
end

set --erase gtr_args
set --global git_status 1
wt '#404'
test $status -eq 1; and not set --query gtr_args
or begin
    echo "worktree creation continued after fetch failure" >&2
    exit 1
end
