{ config, ... }:
{
  launchd.agents.ollama = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/bash"
        "${config.home.homeDirectory}/.dotfiles/script/start-ollama.sh"
      ];
      EnvironmentVariables.PATH = "/usr/bin:/bin";
      RunAtLoad = true;
      ProcessType = "Background";
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/ollama-launch.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/ollama-launch.log";
    };
  };
}
