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

# Vite+ bin (https://viteplus.dev)
. "/Users/luvpame/.config/vite-plus/env"

# Vite+ bin (https://viteplus.dev)
. "/tmp/tsuregoro-vp-isolated/env"

# Vite+ bin (https://viteplus.dev)
. "/Users/luvpame/dev/github.com/luvpame/tsuregoro/.devenv/state/vite-plus/env"
