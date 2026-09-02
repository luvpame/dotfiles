# Keep Nix profiles ahead of Homebrew and macOS defaults.
# Paths are prepended, so lower-priority entries come first.
if [[ -d "${HOME}/.local/share/mise/shims" ]]; then
  path=("${HOME}/.local/share/mise/shims" "${path[@]}")
fi

if [[ -d "${HOME}/go/bin" ]]; then
  path=("${HOME}/go/bin" "${path[@]}")
fi

if [[ -d /opt/homebrew/sbin ]]; then
  path=("/opt/homebrew/sbin" "${path[@]}")
fi

if [[ -d /opt/homebrew/bin ]]; then
  path=("/opt/homebrew/bin" "${path[@]}")
fi

if [[ -d /run/current-system/sw/bin ]]; then
  path=("/run/current-system/sw/bin" "${path[@]}")
fi

if [[ -d "/etc/profiles/per-user/${USER}/bin" ]]; then
  path=("/etc/profiles/per-user/${USER}/bin" "${path[@]}")
fi

if [[ -d "${HOME}/.nix-profile/bin" ]]; then
  path=("${HOME}/.nix-profile/bin" "${path[@]}")
fi

typeset -U path PATH
export PATH
