{
  description = "My Dotfiles.";

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

  outputs =
    inputs@{
      nix-darwin,
      home-manager,
      ...
    }:
    let
      userName = "nasuno.ayumu";
      homeDirectory = "/Users/${userName}";
      repoRoot = "${homeDirectory}/dev/github.com/luvpame/dotfiles";
    in
    {
      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit
            userName
            homeDirectory
            repoRoot
            inputs
            ;
        };
        modules = [
          home-manager.darwinModules.home-manager

          ./nix-darwin/default.nix
        ];
      };
    };
}
