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

    set -l gtr_cache_root "$HOME/.cache"
    if test -n "$XDG_CACHE_HOME"
        set gtr_cache_root "$XDG_CACHE_HOME"
    end
    set -l gtr_init "$gtr_cache_root/gtr/init-gtr.fish"
    test -f "$gtr_init"; or git gtr init fish >/dev/null 2>&1
    source "$gtr_init" 2>/dev/null

    # Configurations for mise
    if command -q mise
        mise activate fish | source
    end

    herdr completion fish | source
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
