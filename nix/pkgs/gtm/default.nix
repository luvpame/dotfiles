{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
}:
stdenvNoCC.mkDerivation rec {
  pname = "gtm";
  version = "0.2.96";

  src = fetchurl {
    url = "https://github.com/prjctimg/gtm/releases/download/v${version}/gtm-aarch64-darwin.tar.gz";
    hash = "sha256-Svj49Cj8olhCFxfCwmMhauxS4uYGPeZquCx1IXVZ3qE=";
  };

  nativeBuildInputs = [ installShellFiles ];
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/gtm bin/gtmd -t "$out/bin"
    installManPage man/man1/*.1
    installShellCompletion completions/gtm.fish completions/gtmd.fish \
      completions/gtm.bash completions/gtmd.bash completions/_gtm completions/_gtmd
    install -Dm644 LICENSE "$out/share/licenses/gtm/LICENSE"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/gtm" --version
    "$out/bin/gtmd" --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Terminal music player with a background audio daemon";
    homepage = "https://github.com/prjctimg/gtm";
    license = licenses.gpl3Only;
    mainProgram = "gtm";
    platforms = [ "aarch64-darwin" ];
  };
}
