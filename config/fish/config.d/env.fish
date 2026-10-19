# Configurations for git
set -gx GIT_CONFIG_GLOBAL ~/.config/git/config

# Configurations for Git TUIs
set -gx XDG_CONFIG_HOME ~/.config
set -gx ZIGGITY_CONFIG ~/.config/ziggity/config.ini

# Set Editor
set -gx EDITOR nvim
set -gx PAGER ov

# 1Password SSH Agent (tmux内でも署名が動作するように固定)
set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
