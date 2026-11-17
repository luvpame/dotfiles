{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "heygen";
  version = "0.12.1";

  src = fetchurl {
    url = "https://static.heygen.ai/cli/releases/v${version}/heygen_v${version}_darwin_arm64.tar.gz";
    hash = "sha256-81bB6TBYF265bP40lauGaSD41xX0HN34q98uFYSl/og=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -m 0755 heygen "$out/bin/heygen"
    runHook postInstall
  '';

  meta = {
    description = "HeyGen CLI";
    homepage = "https://developers.heygen.com/cli";
    license = lib.licenses.unfree;
    mainProgram = "heygen";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
