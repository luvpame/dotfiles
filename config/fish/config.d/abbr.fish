if status is-interactive
    abbr -a c clear
    abbr -a reload 'exec $SHELL -l'
    abbr -a ll 'eza -alh'
    abbr -a ls eza
    abbr -a g git
    abbr -a pn pnpm
    abbr -a j just
    abbr -a cc 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model opus --effort medium'
    abbr -a ccs 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model sonnet --effort medium'
    abbr -a ccf 'CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model fable'
    abbr -a v nvim
    abbr -a cdg cd-gitroot
    abbr -a cat bat
    abbr -a co 'cage codex'
    abbr -a lg lazygit
    abbr -a tm tmux
    abbr -a hd herdr
end
