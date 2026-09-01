{
  config,
  lib,
  pkgs,
  ...
}:
let
  configRoot = "${config.home.homeDirectory}/.dotfiles/config";
  oos = config.lib.file.mkOutOfStoreSymlink;
  claudeMcpConfig = "${configRoot}/claude/mcp.json";
in
{
  xdg.enable = true;

  # Repository内で直接編集する設定は、activationなしで反映する。
  # Applicationが同じdirectoryへ生成するstateは、Gitのignore対象として分離する。
  xdg.configFile = {
    aerospace.source = oos "${configRoot}/aerospace";
    fish.source = oos "${configRoot}/fish";
    git.source = oos "${configRoot}/git";
    mise.source = oos "${configRoot}/mise";
    nvim.source = oos "${configRoot}/nvim";
    lazygit.source = oos "${configRoot}/lazygit";
    ziggity.source = oos "${configRoot}/ziggity";
    yazi.source = oos "${configRoot}/yazi";
    tmux.source = oos "${configRoot}/tmux";
    "herdr/scripts".source = oos "${configRoot}/herdr/scripts";
    "herdr/config.toml".source = oos "${configRoot}/herdr/config.toml";
    cage.source = oos "${configRoot}/cage";

    # Runtime stateを含むHunkの親directory linkはT24でfile単位へ分割する。
    "worktrunk/config.toml".source = oos "${configRoot}/worktrunk/config.toml";
    hunk.source = oos "${configRoot}/hunk";
    wezterm.source = oos "${configRoot}/wezterm";
    zed.source = oos "${configRoot}/zed";
    guard-and-guide.source = oos "${configRoot}/guard-and-guide";
    efm-langserver.source = oos "${configRoot}/efm-langserver";

    # direnvrc は ${pkgs.nix-direnv} の Nix Store パスを参照するため
    # dotfiles 側に静的ファイルとして管理できない。text で直接記述する。
    "direnv/direnvrc" = {
      text = "source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };
  };

  # Agent設定もRepository内で直接編集し、各Agentへ即時反映する。
  home.file = {
    ".zshenv".source = oos "${configRoot}/zsh/.zshenv";
    ".agents".source = oos "${configRoot}/agents";
    ".codex/agents".source = oos "${configRoot}/codex/agents";
    ".codex/hooks".source = oos "${configRoot}/codex/hooks";
    ".codex/hooks.json".source = oos "${configRoot}/codex/hooks.json";
    ".codex/AGENTS.md".source = oos "${configRoot}/codex/AGENTS.md";
    ".codex/config.toml".source = oos "${configRoot}/codex/config.toml";
    ".agent-browser/config.json".source = oos "${configRoot}/agent-browser/config.json";
    ".claude/settings.json" = {
      source = oos "${configRoot}/claude/settings.json";

      # Claudeはlocal stateを書き戻さないため、Repositoryを唯一の正とする。
      force = true;
    };
    ".claude/statusline.py".source = oos "${configRoot}/claude/statusline.py";
    ".claude/hooks".source = oos "${configRoot}/claude/hooks";
    ".claude/skills".source = oos "${configRoot}/agents/skills";
    ".claude/CLAUDE.md".source = oos "${configRoot}/claude/CLAUDE.md";
    ".claude/RTK.md".source = oos "${configRoot}/claude/RTK.md";
    ".cursor/skills".source = oos "${configRoot}/agents/skills";
  };

  home.activation.configureClaudeMcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    (
      claudeConfig="$HOME/.claude.json"
      mcpConfig="${claudeMcpConfig}"
      mergedConfig="$(mktemp /tmp/claude-json.XXXXXX)"
      trap 'rm -f "$mergedConfig"' EXIT

      if [ -f "$claudeConfig" ]; then
        ${pkgs.jq}/bin/jq --slurpfile mcp "$mcpConfig" \
          '.mcpServers = ((.mcpServers // {}) * ($mcp[0].mcpServers // {}))' \
          "$claudeConfig" > "$mergedConfig"
      else
        ${pkgs.jq}/bin/jq '.' "$mcpConfig" > "$mergedConfig"
      fi

      chmod 600 "$mergedConfig"
      if [ ! -f "$claudeConfig" ] || ! cmp -s "$mergedConfig" "$claudeConfig"; then
        mv "$mergedConfig" "$claudeConfig"
      fi
    )
  '';
}
