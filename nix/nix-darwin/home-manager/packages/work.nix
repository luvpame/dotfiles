{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  cclens = inputs.cclens.packages.${system}.default;
  claudeWithCclens = pkgs.writeShellScriptBin "claude" ''
    exec ${pkgs.claude-code}/bin/claude \
      --plugin-dir ${inputs.cclens}/plugins/cclens \
      "$@"
  '';
in
[
  pkgs.awscli2
  inputs.crit.packages.${system}.default
  cclens
  claudeWithCclens
]
