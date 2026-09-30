{
  buildNpmPackage,
  d2,
  nodejs_24,
  src,
  writeShellApplication,
}:
let
  runtime = buildNpmPackage {
    pname = "explainer-runtime";
    version = "0.1.0";
    inherit src;
    nodejs = nodejs_24;
    npmDepsHash = "sha256-GNk88rkMiS8sMJX6KYAY94OpUxQ1x3bi1em1S5BAfBo=";
    dontNpmBuild = true;
    dontNpmPrune = true;

    postPatch = ''
      cp ${./package.json} package.json
      cp ${./package-lock.json} package-lock.json
      patch --batch --fuzz=0 --no-backup-if-mismatch -p1 < ${./runtime-instructions.patch}
      substituteInPlace skills/explainer/scripts/figure-check.mjs \
        --replace-fail 'const root = findUp' 'const root = process.env.EXPLAINER_RUNTIME ?? findUp'
      substituteInPlace skills/explainer/scripts/figure-variants.mjs \
        --replace-fail 'const root = (() =>' 'const root = process.env.EXPLAINER_RUNTIME ?? (() =>'
      substituteInPlace skills/explainer/scripts/verify-doc.mjs \
        --replace-fail "join(repoRoot, 'node_modules'" "join(process.env.EXPLAINER_RUNTIME ?? repoRoot, 'node_modules'" \
        --replace-fail "join(repoRoot, 'node_modules/@mizchi" "join(process.env.EXPLAINER_RUNTIME ?? repoRoot, 'node_modules/@mizchi"
      substituteInPlace skills/explainer/scripts/build-html.mjs \
        --replace-fail "join(process.cwd(), 'package.json')" "join(process.env.EXPLAINER_RUNTIME ?? process.cwd(), 'package.json')" \
        --replace-fail "join(process.cwd(), 'node_modules/" "join(process.env.EXPLAINER_RUNTIME ?? process.cwd(), 'node_modules/"
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/skills"
      cp -R node_modules package.json "$out/"
      cp -R skills/explainer "$out/skills/"
      cp LICENSE "$out/"
      runHook postInstall
    '';
  };
in
writeShellApplication {
  name = "explainer";
  runtimeInputs = [
    nodejs_24
    d2
  ];
  derivationArgs.passthru = { inherit runtime; };
  text = ''
    export EXPLAINER_RUNTIME=${runtime}
    export PLAYWRIGHT_BROWSERS_PATH="''${XDG_CACHE_HOME:-$HOME/.cache}/explainer/playwright"
    export PATH="$EXPLAINER_RUNTIME/node_modules/.bin:$PATH"
    command="''${1:-help}"
    if [ "$#" -gt 0 ]; then shift; fi
    case "$command" in
      setup)
        exec playwright install chromium "$@"
        ;;
      run)
        script="''${1:-}"
        if [ "$#" -gt 0 ]; then shift; fi
        case "$script" in
          figure-check.mjs|figure-variants.mjs|verify-doc.mjs|build-html.mjs|tlc-to-scene.mjs)
            exec node "$EXPLAINER_RUNTIME/skills/explainer/scripts/$script" "$@"
            ;;
          *) printf 'Unsupported explainer script: %s\n' "$script" >&2; exit 2 ;;
        esac
        ;;
      vlmkit|vlmkit-anim)
        exec "$EXPLAINER_RUNTIME/node_modules/.bin/$command" "$@"
        ;;
      help)
        printf '%s\n' 'explainer setup [--dry-run]' 'explainer run <script.mjs> <args...>' 'explainer vlmkit|vlmkit-anim <args...>'
        ;;
      *) printf 'Unknown explainer command: %s\n' "$command" >&2; exit 2 ;;
    esac
  '';
}
