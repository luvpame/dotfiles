{ config, pkgs, ... }:
let
  stateDir = "${config.home.homeDirectory}/.agent-browser";
  chromeLauncher = pkgs.writeShellApplication {
    name = "agent-browser-chrome";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      state_dir=${pkgs.lib.escapeShellArg stateDir}
      chrome="$(
        for candidate in "$state_dir"/browsers/chrome-*/"Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing"; do
          if [ -x "$candidate" ]; then
            printf '%s\n' "$candidate"
          fi
        done | sort -V | tail -n 1
      )"
      if [ -z "$chrome" ]; then
        printf '%s\n' 'Chrome for Testing is missing. Run: agent-browser install' >&2
        exit 1
      fi

      args=(
        --headless=new
        --remote-debugging-address=127.0.0.1
        --remote-debugging-port=9222
        "--user-data-dir=$state_dir/claude-chrome"
      )
      if [ "''${1:-}" = --dry-run ]; then
        printf '%q ' "$chrome" "''${args[@]}"
        printf '\n'
        exit 0
      fi
      exec "$chrome" "''${args[@]}"
    '';
  };
in
{
  launchd.agents.agent-browser-chrome = {
    enable = true;
    config = {
      ProgramArguments = [ "${chromeLauncher}/bin/agent-browser-chrome" ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      StandardOutPath = "${stateDir}/chrome-launchd.log";
      StandardErrorPath = "${stateDir}/chrome-launchd.log";
    };
  };
}
