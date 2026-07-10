{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
[
  pkgs.awscli2
  inputs.crit.packages.${system}.default
  pkgs.claude-code
]
