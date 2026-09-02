eval "$(mise activate zsh)"
source "${ZDOTDIR:-$HOME}/.zshenv"

if [[ -d "${HOME}/.vite-plus/bin" ]]; then
  path+=("${HOME}/.vite-plus/bin")
fi

# mise prepends managed tool paths during precmd; restore the Nix priority after it.
_dotfiles_restore_path() {
  source "${ZDOTDIR:-$HOME}/.zshenv"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_restore_path
