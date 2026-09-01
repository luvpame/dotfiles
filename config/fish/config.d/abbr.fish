if status is-interactive
    abbr -a c clear
    abbr -a reload 'exec $SHELL -l'
    abbr -a ll 'eza -alh'
    abbr -a ls eza
    abbr -a g git
    abbr -a pn pnpm
    abbr -a j just
    abbr -a cc 'agent-browser open about:blank >/dev/null 2>&1; or true; CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model opus --permission-mode auto'
    abbr -a ccs 'agent-browser open about:blank >/dev/null 2>&1; or true; CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model sonnet --permission-mode auto'
    abbr -a ccf 'agent-browser open about:blank >/dev/null 2>&1; or true; CLAUDE_CODE_NO_FLICKER=1 cage claude --append-system-prompt "$__CAGE_SANDBOX_NOTE" --model fable --permission-mode auto'
    abbr -a v nvim
    abbr -a cdg cd-gitroot
    abbr -a cat bat
    abbr -a co 'agent-browser open about:blank >/dev/null 2>&1; or true; cage codex'
    abbr -a lg ziggity
    abbr -a tm tmux
    abbr -a hd herdr
end
