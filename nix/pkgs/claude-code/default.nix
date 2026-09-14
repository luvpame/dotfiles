{
  lib,
  pkgs,
  stdenv,
  claudeCodeSource,
}:
let
  versionFiles = builtins.readDir "${claudeCodeSource}/versions";
  versionNames = map (lib.removeSuffix ".json") (
    builtins.filter (lib.hasSuffix ".json") (builtins.attrNames versionFiles)
  );
  latestVersion = builtins.head (builtins.sort (a: b: builtins.compareVersions a b > 0) versionNames);
  # upstream が参照する旧属性へ、警告を伴わない値を渡す。
  compatibleStdenv = stdenv // {
    isLinux = stdenv.hostPlatform.isLinux;
  };
in
pkgs.callPackage "${claudeCodeSource}/package.nix" {
  additionalPaths = [
    "${pkgs.gh}/bin"
    "${pkgs.poppler-utils}/bin"
  ];
  sourcesFile = "${claudeCodeSource}/versions/${latestVersion}.json";
  stdenv = compatibleStdenv;
}
