{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  claudeCodeWithCrit = pkgs.writeShellScriptBin "claude" ''
    exec ${pkgs.claude-code}/bin/claude \
      --plugin-dir ${inputs.crit}/integrations/claude-code \
      "$@"
  '';
in
[
  pkgs.awscli2
  inputs.crit.packages.${system}.default
  claudeCodeWithCrit
]
