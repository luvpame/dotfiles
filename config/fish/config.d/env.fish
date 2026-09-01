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

# Cage内で書き込みが拒否された場合は、制限を回避せずに報告する。
set -g __CAGE_SANDBOX_NOTE 'Cageの制限で書き込みが拒否された場合は、意図された境界として扱うこと。操作を中止し、拒否されたパスと理由を報告すること。別のコマンドやパスで回避しないこと。追加の許可が必要なら、ユーザーに対象パスを提案すること。'
