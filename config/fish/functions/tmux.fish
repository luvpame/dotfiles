function tmux --description 'Attach to or create the main tmux session by default'
    if test (count $argv) -eq 0
        command tmux new-session -A -s main
        return
    end

    command tmux $argv
end
