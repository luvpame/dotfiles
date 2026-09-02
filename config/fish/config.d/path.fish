# `homebrew.goPackages` installs Go CLI binaries into `~/go/bin`.
if test -d ~/go/bin
    if not contains ~/go/bin $PATH
        set -gx PATH ~/go/bin $PATH
    end
end

if not contains ~/.local/bin $PATH
    set -gx PATH ~/.local/bin $PATH
end

# Keep Nix profiles ahead of Homebrew and macOS defaults.
fish_add_path --path --move \
    "$HOME/.nix-profile/bin" \
    "/etc/profiles/per-user/$USER/bin" \
    /run/current-system/sw/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin

# brewでインストールしたfisherをnixpkgsでインストールしたfishで使う
if test -d /opt/homebrew/share/fish/vendor_functions.d
    set -p fish_function_path /opt/homebrew/share/fish/vendor_functions.d
end
