{
  config,
  lib,
  pkgs,
  ...
}:
let
  updaterPath = lib.makeBinPath [
    pkgs.herdr
    pkgs.git
    pkgs.gh
  ];
  mkUpdater = script: args: interval: {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.python3}/bin/python3"
        "${config.xdg.configHome}/herdr/scripts/${script}"
      ]
      ++ args;
      EnvironmentVariables.PATH = updaterPath;
      ProcessType = "Background";
      RunAtLoad = true;
      StartInterval = interval;
    };
  };
in
{
  launchd.agents = {
    herdr-dev-server = mkUpdater "workspace-dev-server.py" [ ] 15;
    herdr-git-metadata = mkUpdater "agent-git-metadata.py" [ "--all-workspaces" ] 60;
  };
}
