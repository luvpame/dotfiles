{
  description = "Luvpame's Dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cage = {
      url = "github:Warashi/cage/v0.1.13";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-source = {
      url = "github:ryoppippi/claude-code-overlay";
      flake = false;
    };
    cclens.url = "github:lambdalisue/cclens";
    crit = {
      url = "git+https://github.com/tomasz-tomczyk/crit.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    guard-and-guide = {
      url = "github:kawarimidoll/guard-and-guide";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hunk = {
      # イベント駆動の watch を含む main commit に固定する。
      url = "github:modem-dev/hunk/c58b70714bc32691a999134c49a2de16e464cea2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://luvpame.cachix.org"
    ];
    extra-trusted-public-keys = [
      "luvpame.cachix.org-1:2LWxP7zffWxE3HweuI51NQrKJFpTsbelIkkP/YYMcNk="
    ];
  };

  outputs =
    inputs@{
      nix-darwin,
      home-manager,
      ...
    }:
    {
      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.darwinModules.home-manager
          inputs.nix-index-database.darwinModules.nix-index
          { programs.nix-index-database.comma.enable = true; }

          ./nix-darwin/default.nix
        ];
      };
    };
}
