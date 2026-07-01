{
  description = "My Dotfiles.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi.url = "github:sxyazi/yazi";
    guard-and-guide.url = "github:kawarimidoll/guard-and-guide";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      localConfigPath = ./local.nix;
      rawLocal =
        if builtins.pathExists localConfigPath then import localConfigPath else import ./local.nix.example;
      validProfiles = [
        "work"
        "private"
      ];
      profile =
        if rawLocal ? profile then
          if builtins.elem rawLocal.profile validProfiles then
            rawLocal.profile
          else
            throw "Invalid local.profile '${rawLocal.profile}' in nix/local.nix. Use one of: ${builtins.concatStringsSep ", " validProfiles}."
        else
          throw "Missing local.profile in nix/local.nix. Set it to \"work\" or \"private\".";
      local = builtins.seq profile (
        rawLocal
        // {
          inherit profile;
        }
      );
      darwinConfigName =
        if local ? darwinConfigName then
          local.darwinConfigName
        else
          throw "Missing local.darwinConfigName in nix/local.nix. Create/update it from nix/local.nix.example.";
    in
    {
      darwinConfigurations = {
        ${darwinConfigName} = nix-darwin.lib.darwinSystem {
          system = system;
          specialArgs = {
            inherit
              local
              inputs
              ;
          };
          modules = [
            home-manager.darwinModules.home-manager

            ./nix-darwin/default.nix
          ];
        };
      };
    };
}
