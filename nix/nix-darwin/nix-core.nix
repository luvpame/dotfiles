{
  config,
  inputs,
  pkgs,
  ...
}:
let
  primaryUser = config.dotfiles.user.name;
in
{
  # nixpkgs の共通設定。
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (_: prev: {
        # Temporary workaround for statix snapshot tests failing on darwin.
        statix = prev.statix.overrideAttrs (_: {
          doCheck = false;
        });
      })
    ];
  };

  # nix-darwin が削除済みの --toc-depth を渡すため、ドキュメント生成を無効にする。
  documentation.doc.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  # このホストで共有する Nix のコア設定。
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
      keep-derivations = true;
      min-free = 10737418240;
      max-free = 21474836480;
      trusted-users = [
        "root"
        primaryUser
      ];
      # 開発CLI用のバイナリキャッシュ。
      extra-substituters = [
        "https://luvpame.cachix.org"
      ];
      # バイナリキャッシュの公開鍵。
      extra-trusted-public-keys = [
        "luvpame.cachix.org-1:2LWxP7zffWxE3HweuI51NQrKJFpTsbelIkkP/YYMcNk="
      ];
    };
  };
}
