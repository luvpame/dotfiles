{
  config,
  local,
  pkgs,
  ...
}:
let
  dotfilesRoot = local.dotfilesRoot;
  configRoot = "${dotfilesRoot}/config";
  oos = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.enable = true;
  xdg.configFile = {
    fish.source = oos "${configRoot}/fish";
    zsh.source = oos "${configRoot}/zsh";
    git.source = oos "${configRoot}/git";
    mise.source = oos "${configRoot}/mise";
    nvim.source = oos "${configRoot}/nvim";
    lazygit.source = oos "${configRoot}/lazygit";
    yazi.source = oos "${configRoot}/yazi";
    tmux.source = oos "${configRoot}/tmux";
    herdr.source = oos "${configRoot}/herdr";
    wezterm.source = oos "${configRoot}/wezterm";
    zed.source = oos "${configRoot}/zed";
    cage.source = oos "${configRoot}/cage";
    guard-and-guide.source = oos "${configRoot}/guard-and-guide";
    efm-langserver.source = oos "${configRoot}/efm-langserver";

    # direnvrc は ${pkgs.nix-direnv} の Nix Store パスを参照するため
    # dotfiles 側に静的ファイルとして管理できない。text で直接記述する。
    "direnv/direnvrc" = {
      text = "source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };
  };

  home.file = {
    ".zshenv".source = oos "${configRoot}/zsh/.zshenv";
    ".agents".source = oos "${configRoot}/agents";
    ".codex/hooks".source = oos "${configRoot}/codex/hooks";
    ".codex/hooks.json".source = oos "${configRoot}/codex/hooks.json";
    ".codex/AGENTS.md".source = oos "${configRoot}/codex/AGENTS.md";
    ".claude/settings.json".source = oos "${configRoot}/claude/settings.json";
    ".claude/statusline.py".source = oos "${configRoot}/claude/statusline.py";
    ".claude/hooks".source = oos "${configRoot}/claude/hooks";
    ".claude/skills".source = oos "${configRoot}/agents/skills";
    ".claude/CLAUDE.md".source = oos "${configRoot}/claude/CLAUDE.md";
    ".claude/RTK.md".source = oos "${configRoot}/claude/RTK.md";
    ".cursor/skills".source = oos "${configRoot}/agents/skills";
  };
}
