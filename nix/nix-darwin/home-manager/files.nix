{
  config,
  lib,
  pkgs,
  ...
}:
let
  configRoot = "${config.home.homeDirectory}/.dotfiles/config";
  oos = config.lib.file.mkOutOfStoreSymlink;
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
    yazi.source = oos "${configRoot}/yazi";
    tmux.source = oos "${configRoot}/tmux";
    "herdr/scripts".source = oos "${configRoot}/herdr/scripts";
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

  # GUI が共有設定の symlink を拒否するため、通常ファイルとしてコピーする。
  home.activation.copyHerdrConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    herdr_state_dir="${config.xdg.stateHome}/dotfiles/herdr"
    run ${pkgs.coreutils}/bin/install -dm700 "$herdr_state_dir"

    for file in config.toml config-gpui.local.toml; do
      source="${configRoot}/herdr/$file"
      target="${config.xdg.configHome}/herdr/$file"
      previous="$herdr_state_dir/$file"

      # 初回は既存設定を残し、以後は dotfiles の変更時だけ GUI 設定を上書きする。
      if [ -L "$target" ] || [ ! -e "$target" ] || {
        [ -e "$previous" ] && ! ${pkgs.diffutils}/bin/cmp -s "$source" "$previous"
      }; then
        run ${pkgs.coreutils}/bin/install -Dm600 "$source" "$target"
      fi
      run ${pkgs.coreutils}/bin/install -Dm600 "$source" "$previous"
    done
  '';

  # Agent設定もRepository内で直接編集し、各Agentへ即時反映する。
  home.file = {
    ".zshenv".source = oos "${configRoot}/zsh/.zshenv";
    ".zprofile" = {
      source = oos "${configRoot}/zsh/.zprofile";
      force = true;
    };
    ".zshrc" = {
      source = oos "${configRoot}/zsh/.zshrc";
      force = true;
    };
    ".agents/.skill-lock.json".source = oos "${configRoot}/agents/.skill-lock.json";
    ".codex/agents".source = oos "${configRoot}/codex/agents";
    ".codex/hooks".source = oos "${configRoot}/codex/hooks";
    ".codex/hooks.json".source = oos "${configRoot}/codex/hooks.json";
    ".codex/AGENTS.md".source = oos "${configRoot}/codex/AGENTS.md";
    ".codex/config.toml".source = oos "${configRoot}/codex/config.toml";
  };
}
