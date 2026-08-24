{
  inputs,
  pkgs,
  userName,
  ...
}:
{
  # nixpkgs の共通設定。
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: _: {
        claude-code = final.callPackage ../pkgs/claude-code/default.nix {
          claudeCodeSource = inputs.claude-code-source;
        };
      })
      (_: prev: {
        # Temporary workaround for statix snapshot tests failing on darwin.
        statix = prev.statix.overrideAttrs (_: {
          doCheck = false;
        });
      })
    ];
  };

  # ponytail: disabled until nix-darwin stops passing the removed --toc-depth.
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
        userName
      ];
      # 開発CLI用のバイナリキャッシュ。
      extra-substituters = [
        "https://cclens.cachix.org"
        "https://ryoppippi.cachix.org"
      ];
      # バイナリキャッシュの公開鍵。
      extra-trusted-public-keys = [
        "cclens.cachix.org-1:0QUNU6PuVyf+yXOvg3n1rd3FksBoB3s3/Jty50iKRNQ="
        "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
      ];
    };
  };
}
