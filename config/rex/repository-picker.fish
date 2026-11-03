set -l selected (ghq list --full-path | fzf --layout=reverse --prompt='ghq> ')
or exit $status
test -n "$selected"; or exit 0

for session in (rex ls --json | jq -r '.sessions[].session_id')
    for block in (rex block ls -s "$session" --json | jq -r '.blocks[] | select(.creator_name == "com.superlogical.terminal") | .block_id')
        set -l cwd (rex block call -s "$session" -b "$block" process | jq -r '.foreground.cwd // .child.cwd // empty')
        if test "$cwd" = "$selected"
            rex do session.select session_id="$session"
            exit $status
        end
    end
end

set -l created (rex new (path basename "$selected") -c "$selected" --json)
or exit $status
set -l session (string join '' $created | jq -r '.session_id')
rex do session.select session_id="$session"
