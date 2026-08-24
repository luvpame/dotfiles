darwin_config_name := "default"

_:
    just --list

[working-directory("nix")]
update:
    nix flake update

alias u := update

[working-directory("nix")]
build:
    nh darwin build path:. -H {{darwin_config_name}}

[working-directory("nix")]
switch:
    #!/bin/bash
    set -euo pipefail

    repo_root="$(cd .. && pwd -P)"
    dotfiles_link="$HOME/.dotfiles"

    if [[ -e "$dotfiles_link" && ! -L "$dotfiles_link" ]]; then
        echo "$dotfiles_link が既存のシンボリックリンクではないため、上書きせずに停止しました。" >&2
        exit 1
    fi

    ln -shf "$repo_root" "$dotfiles_link"
    nh darwin switch path:. -H {{darwin_config_name}}

alias s := switch

[working-directory("nix")]
check:
    nix flake check path:.

alias c := check

[working-directory("nix")]
clean:
    nh clean all --keep-since 30d --keep 3

[working-directory("nix")]
update-and-switch: update switch

alias us := update-and-switch
