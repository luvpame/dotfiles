{ config, local, ... }:
let
  configRoot = "${local.dotfilesRoot}/config";
  oos = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    aerospace.source = oos "${configRoot}/aerospace/work";
  };
  home.file = {
    ".codex/config.toml".source = oos "${configRoot}/codex/work/config.toml";
  };
}
