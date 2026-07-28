set --global mock_status 0

function wt
    set --global captured_args $argv
    return $mock_status
end

source (path dirname (status filename))/functions/configure_worktrunk.fish
configure_worktrunk

function assert_args
    set --local expected $argv[1]
    set --local actual (string join ' ' -- $captured_args)

    if test "$actual" != "$expected"
        echo "expected: $expected" >&2
        echo "actual:   $actual" >&2
        exit 1
    end
end

set --global --export HERDR_ENV 1
wt switch --create feature
assert_args 'switch --no-cd --create feature'

wt switch --cd feature
assert_args 'switch --cd feature'

wt list
assert_args 'list'

set --global --erase HERDR_ENV
wt switch feature
assert_args 'switch feature'

set --global --export HERDR_ENV 1
set --global mock_status 7
wt switch feature
test $status -eq 7
or begin
    echo 'worktrunk exit status was not preserved' >&2
    exit 1
end
