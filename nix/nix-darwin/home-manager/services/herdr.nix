{
  config,
  lib,
  pkgs,
  ...
}:
let
  updaterPath = lib.makeBinPath [
    pkgs.gh
    pkgs.git
    pkgs.herdr
  ];
  mkUpdater = script: interval: {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.python3}/bin/python3"
        "${config.xdg.configHome}/herdr/scripts/${script}"
      ];
      EnvironmentVariables.PATH = updaterPath;
      ProcessType = "Background";
      RunAtLoad = true;
      StartInterval = interval;
    };
  };
in
{
  launchd.agents = {
    herdr-dev-server = mkUpdater "workspace-dev-server.py" 15;
    herdr-git-change-lines = mkUpdater "git-change-lines.py" 60;
    herdr-review-requests = mkUpdater "workspace-review-requests.py" 300;
  };
}
