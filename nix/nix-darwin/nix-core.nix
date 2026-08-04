{
  inputs,
  pkgs,
  local,
  ...
}:
{
  # nixpkgs の共通設定。
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.claude-code-overlay.overlays.default
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
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
      keep-outputs = true;
      keep-derivations = true;
      trusted-users = [
        "root"
        local.userName
      ];
      # claude-code-overlay 用のバイナリキャッシュ。
      extra-substituters = [ "https://ryoppippi.cachix.org" ];
      # claude-code-overlay のバイナリキャッシュ用公開鍵。
      extra-trusted-public-keys = [
        "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
      ];
    };
  };
}
