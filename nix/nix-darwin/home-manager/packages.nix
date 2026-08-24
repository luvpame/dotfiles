{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  cclens = inputs.cclens.packages.${system}.default;
  iris = pkgs.callPackage ../../pkgs/iris/default.nix { };
  guardAndGuide = inputs.guard-and-guide.packages.${system}.default;
in
{
  home.packages = with pkgs; [
    efm-langserver
    oxfmt
    nixfmt
    nixd
    statix
    deadnix
    shellcheck
    shfmt
    stylua
    lua-language-server
    css-variables-language-server
    yamllint
    fzf
    bat
    ripgrep
    eza
    fish
    zoxide
    gh
    git
    mergiraf
    just
    nh
    mise
    jq
    jnv
    luarocks
    neovim
    tre-command
    ffmpeg
    hyperfine
    fd
    wget
    just-lsp
    tmux
    ghq
    direnv
    devenv
    nix-direnv
    lazygit
    openssl_3
    (yazi.override {
      _7zz = pkgs._7zz-rar;
    })
    _7zz-rar
    imagemagick
    resvg
    poppler
    # rtk 0.43.0 fails to compile its test target with warnings = "deny".
    (rtk.overrideAttrs { doCheck = false; })
    socat
    ov
    guardAndGuide
    pkgs.herdr
    inputs.hunk.packages.${system}.default
    (callPackage ../../pkgs/pique/default.nix { })
    (callPackage ../../pkgs/site2skill/default.nix { })
    (callPackage ../../pkgs/tree-sitter-cli/default.nix { })
    awscli2
    inputs.crit.packages.${system}.default
    cclens
    claude-code
    iris
  ];
}
