if status is-interactive
    abbr -a c clear
    abbr -a reload 'exec $SHELL -l'
    abbr -a ll 'eza -alh'
    abbr -a ls eza
    abbr -a g git
    abbr -a pn pnpm
    abbr -a j just
    abbr -a cc 'CLAUDE_CODE_NO_FLICKER=1 cage claude --model claude-opus-4-7 --permission-mode auto'
    abbr -a ccs 'CLAUDE_CODE_NO_FLICKER=1 cage claude --model sonnet --permission-mode auto'
    abbr -a v nvim
    abbr -a cdg cd-gitroot
    abbr -a cat bat
    abbr -a wt 'git gtr'
    abbr -a co codex
    abbr -a lg lazygit
    abbr -a tm tmux
end
