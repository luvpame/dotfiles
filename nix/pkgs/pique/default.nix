{
  fetchurl,
  lib,
  libarchive,
  runCommand,
  xar,
}:
let
  version = "0.1.0b5";
in
runCommand "pique-${version}"
  {
    nativeBuildInputs = [
      libarchive
      xar
    ];
    src = fetchurl {
      url = "https://github.com/macadmins/pique/releases/download/v${version}/Pique-${version}.pkg";
      hash = "sha256-bxzC1Yr7cg8m2pQqMu+o2tNXxdl1aD7OhbommYrqsHU=";
    };
    meta = {
      description = "Quick Look extension for syntax-highlighted configuration file previews";
      homepage = "https://github.com/macadmins/pique";
      license = lib.licenses.asl20;
      platforms = lib.platforms.darwin;
    };
  }
  ''
    xar -xf "$src"
    bsdtar -xf Pique-${version}.pkg/Payload
    mkdir -p "$out/Applications"
    mv Pique.app "$out/Applications/"
  ''
