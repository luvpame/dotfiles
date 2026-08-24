canonical_repo_root := "/Users/nasuno.ayumu/dev/github.com/luvpame/dotfiles"
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
    test "$(cd .. && pwd -P)" = "{{canonical_repo_root}}" || (echo "just switch は canonical checkout から実行してください。" >&2; exit 1)
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
