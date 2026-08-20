{
  config,
  lib,
  local,
  pkgs,
  ...
}:
let
  configRoot = "${local.dotfilesRoot}/config";
  oos = config.lib.file.mkOutOfStoreSymlink;
  claudeMcpConfig = "${configRoot}/claude/mcp.json";
in
{
  xdg.configFile = {
    aerospace.source = oos "${configRoot}/aerospace/work";
  };
  home.file = {
    ".codex/config.toml".source = oos "${configRoot}/codex/work/config.toml";
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
