{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  updaterPath = lib.makeBinPath [
    pkgs.gh
    pkgs.git
    inputs.herdr.packages.${system}.default
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
    herdr-git-change-lines = mkUpdater "git-change-lines.py" 60;
    herdr-review-requests = mkUpdater "workspace-review-requests.py" 300;
  };
}
