if status is-interactive
    # remove welcome message
    set fish_greeting

    if command -q tirith
        tirith init --shell fish | source
    end
end
