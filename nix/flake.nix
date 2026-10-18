{
  description = "Luvpame's Dotfiles.";

  inputs = {
    # スキル配布ツール本体。更新は nix/ で nix flake update agent-skills を実行する。
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 外部スキルを追加するときは、ここに取得元の入力（flake = false）を追加し、
    # nix-darwin/home-manager/skills.nix の sources と skills.enable に登録する。
    # 入力の変更後は nix/ で nix flake lock path:. → just check → just switch。
    # URLにコミットを指定した入力の更新は、URLのコミットも変更する必要がある。
    anthropic-skills = {
      url = "github:anthropics/claude-plugins-official/022b3c274938ddfb9fd928fc582eb9b9ed0f537f";
      flake = false;
    };
    cognitive-rhythm-writing = {
      url = "git+https://gist.github.com/eb2929f13ed19c97188393d297be8432.git?rev=a3b1e26beced71d582e13314fb6f5b179b023c76";
      flake = false;
    };
    herdr-skills = {
      url = "github:herdrdev/herdr/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c";
      flake = false;
    };
    humanlayer-skills = {
      url = "github:humanlayer/skills/3c2629142c5d437428269b1b722b08c0b87f574d";
      flake = false;
    };
    japanese-tech-writing = {
      url = "git+https://gist.github.com/fd287c3133457c4fd8f5601d34aa817d.git?rev=5ed08e4475365fd233aa0d3ab71c19b87e1a5732";
      flake = false;
    };
    mizchi-skills = {
      url = "github:mizchi/skills/95b8a50edf0684620c29d09848591de453b99831";
      flake = false;
    };
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
      checks.aarch64-darwin.agent-skills =
        let
          config = inputs.self.darwinConfigurations.default.config;
        in
        config.home-manager.users.${config.dotfiles.user.name}.programs.agent-skills.bundlePath;

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
