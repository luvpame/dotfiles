{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  cclens = inputs.cclens.packages.${system}.default;
in
[
  pkgs.awscli2
  inputs.crit.packages.${system}.default
  cclens
  pkgs.claude-code
]
