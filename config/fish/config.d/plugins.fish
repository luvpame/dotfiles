if status is-interactive
    # Configurations for pure
    set --universal pure_check_for_new_release false
    set --universal pure_separate_prompt_on_error true
    set --universal pure_show_exit_status true
    set --universal pure_enable_nixdevshell true
    set --universal pure_symbol_nixdevshell_prefix " "
    set -g async_prompt_functions _pure_prompt_git

    # Configurations for plugin: fish-autols
    set -gx autols_cmd eza -alh

    # Configurations for plugin: fish-fzf
    set -gx FZF_DISABLE_KEYBINDINGS 1

    # Configurations for zoxide
    if command -q zoxide
        zoxide init fish --cmd z | source
        alias cd z
    end

    # Load git gtr completions
    if test -f ~/.config/fish/completions/gtr.fish
        source ~/.config/fish/completions/gtr.fish
    end

    # Configurations for mise
    if command -q mise
        mise activate fish | source
    end

    herdr completion fish | source
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
