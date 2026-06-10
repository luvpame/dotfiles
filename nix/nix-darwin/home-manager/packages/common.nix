{
  inputs,
  local,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;

  profilePackages = import (./. + "/${local.profile}.nix") {
    inherit
      inputs
      pkgs
      ;
  };

  guardAndGuide = inputs.guard-and-guide.packages.${system}.default.overrideAttrs {
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      src = inputs.guard-and-guide;
      hash = "sha256-YAwHEhFaJucb/tdj2UJWz1qToEK+IyE/PPce9a1gudw=";
    };
  };

  commonPackages = with pkgs; [
    efm-langserver
    nixfmt
    nixd
    statix
    deadnix
    shellcheck
    shfmt
    stylua
    lua-language-server
    yamllint
    fzf
    bat
    ripgrep
    eza
    fish
    zoxide
    gh
    git
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
    terminal-notifier
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
    rtk
    socat
    ov
    mergiraf
    guardAndGuide
    (callPackage ../../../pkgs/site2skill/default.nix { })
    (callPackage ../../../pkgs/tree-sitter-cli/default.nix { })
  ];
in
{
  home.packages = commonPackages ++ profilePackages;
}
