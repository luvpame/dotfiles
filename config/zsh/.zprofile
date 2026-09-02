if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  source "${ZDOTDIR:-$HOME}/.zshenv"
fi

if [[ -d /Applications/Obsidian.app/Contents/MacOS ]]; then
  path+=(/Applications/Obsidian.app/Contents/MacOS)
fi
