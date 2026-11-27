{
  config,
  lib,
  pkgs,
  ...
}:
let
  configRoot = "${config.home.homeDirectory}/.dotfiles/config";
  devinRoot = "${config.home.homeDirectory}/.config/devin";
  oos = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    "devin/agents/poteto-swe-agent.md".source = oos "${configRoot}/devin/agents/poteto-swe-agent.md";
    "devin/hooks/swe-subagent-guard.py".source = oos "${configRoot}/devin/hooks/swe-subagent-guard.py";
  };

  # config.json は org_id などの local state を持つため link せず、hook 登録だけを冪等に反映する。
  home.activation.devinSweSubagentHook = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${pkgs.python3}/bin/python3 "${configRoot}/devin/scripts/upsert-swe-subagent-hook.py" \
      --config "$HOME/.config/devin/config.json" \
      --hook-command "${devinRoot}/hooks/swe-subagent-guard.py"
  '';
}
