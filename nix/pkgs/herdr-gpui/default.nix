{
  lib,
  rustPlatform,
  src,
}:
rustPlatform.buildRustPackage {
  pname = "herdr-gpui";
  version = "0.1.0-unstable-2026-09-29";
  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";
  cargoBuildFlags = [
    "-p"
    "herdr-gpui"
  ];
  doCheck = false;

  env.MACOSX_DEPLOYMENT_TARGET = "15.0";

  postInstall = ''
    app="$out/Applications/Herdr.app/Contents"
    mkdir -p "$app/MacOS" "$app/Resources"
    cp "$out/bin/herdr-gpui" "$app/MacOS/Herdr"
    cp "$src/assets/macos/Info.plist" "$app/Info.plist"
    cp "$src/assets/icons/Herdr.icns" "$app/Resources/Herdr.icns"
    cp "$src/assets/icons/Herdr.car" "$app/Resources/Assets.car"
  '';

  meta = {
    description = "Native GUI client for Herdr";
    homepage = "https://github.com/penso/herdr-gpui";
    license = lib.licenses.asl20;
    mainProgram = "herdr-gpui";
    platforms = lib.platforms.darwin;
  };
}
