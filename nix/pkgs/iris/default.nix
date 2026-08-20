{
  fetchurl,
  lib,
  stdenv,
}:
let
  version = "0.4.1";
in
stdenv.mkDerivation {
  pname = "iris-screenshot";
  inherit version;

  src = fetchurl {
    url = "https://github.com/brijr/iris/releases/download/v${version}/iris-aarch64-apple-darwin.tar.gz";
    hash = "sha256-Wvk9n3TtuqIbpg/EqtWIMZzJBwbULfHxPbUZBAzhA38=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm755 iris "$out/bin/iris"
  '';

  meta = with lib; {
    description = "A camera for coding agents that captures live websites";
    homepage = "https://github.com/brijr/iris";
    license = licenses.mit;
    mainProgram = "iris";
    platforms = [ "aarch64-darwin" ];
  };
}
