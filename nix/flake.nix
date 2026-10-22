{
  description = "Luvpame's Dotfiles.";

  inputs = {
    # スキル配布ツール本体。更新は nix/ で nix flake update agent-skills を実行する。
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 外部スキルだけを取得するときは、ここに取得元の入力（flake = false）を追加し、
    # nix-darwin/home-manager/skills.nix の sources と skills.enable に登録する。
    # 入力の変更後は nix/ で nix flake lock path:. → just check → just switch。
    # URLにコミットを指定した入力の更新は、URLのコミットも変更する必要がある。
    agent-browser-skills = {
      url = "github:vercel-labs/agent-browser/v0.39.2";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/claude-plugins-official/465f09344424225c25d438f2e052732c3d688d2f";
      flake = false;
    };
    explainer = {
      url = "github:mizchi/explainer/ccdd7bacfb47451e38506d837af8a629504960b2";
      flake = false;
    };
    herdr-skills = {
      url = "github:herdrdev/herdr/5bd900d88c80d95f5b145397e45bbeea398b8165";
      flake = false;
    };
    humanlayer-skills = {
      url = "github:humanlayer/skills/653b6411c1f70c275a18e37673b042ff99f67ceb";
      flake = false;
    };
    imozuru = {
      url = "github:MaryCache/imozuru/ecb82c71b611872a0f49e783eda3bec987c80d91";
      flake = false;
    };
    mizchi-skills = {
      url = "github:mizchi/skills/ab4eb2f7a92a13fb37c225ab427f2f492143ace1";
      flake = false;
    };
    agent-memory-repo = {
      url = "github:AgentMemoryRepo/agentmemoryrepo/8798cb26c817d451a5ed6cba0ad8d9eca8d5ec3e";
      flake = false;
    };
    security-audit-skill = {
      url = "github:cloudflare/security-audit-skill/c1c8a8c1471069fb0e188eeaff69b8e8db6564a8";
      flake = false;
    };
    yomiyasu = {
      url = "github:nanaism/yomiyasu/c09270bc93daab14e253fb3ef406182011b79ccb";
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
    git-surgeon = {
      # v0.1.17 タグには Flake がないため、Flake 追加後の同版コミットに固定する。
      url = "github:raine/git-surgeon/ecf6dc42172ba757cc03bce1800ba1db45779f46";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hunk = {
      # イベント駆動の watch を含む main commit に固定する。
      url = "github:modem-dev/hunk/43138ca1b997a1245fa3d2e5523a140f7d456766";
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
