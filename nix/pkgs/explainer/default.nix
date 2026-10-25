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
    npmDepsHash = "sha256-e0NJ0lPr8GLpq4E5/sbqq+1120LrjGUjq+8nIhtRQO0=";
    dontNpmBuild = true;
    dontNpmPrune = true;

    postPatch = ''
      cp ${./package.json} package.json
      cp ${./package-lock.json} package-lock.json
      patch --batch --fuzz=0 --no-backup-if-mismatch -p1 < ${./runtime-instructions.patch}
      substituteInPlace skills/explainer/scripts/figure-check.mjs \
        --replace-fail 'const root = [dir, process.cwd(), here]' 'const root = process.env.EXPLAINER_RUNTIME ?? [dir, process.cwd(), here]'
      substituteInPlace skills/explainer/scripts/figure-variants.mjs \
        --replace-fail 'const root = (() =>' 'const root = process.env.EXPLAINER_RUNTIME ?? (() =>'
      substituteInPlace skills/explainer/scripts/verify-doc.mjs \
        --replace-fail "join(repoRoot, 'node_modules'" "join(process.env.EXPLAINER_RUNTIME ?? repoRoot, 'node_modules'"
      substituteInPlace skills/explainer/scripts/build-html.mjs \
        --replace-fail "join(process.cwd(), 'package.json')" "join(process.env.EXPLAINER_RUNTIME ?? process.cwd(), 'package.json')"
      substituteInPlace skills/explainer/scripts/icons.mjs \
        --replace-fail 'const roots = [' 'const roots = [process.env.EXPLAINER_RUNTIME, '
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
          figure-check.mjs|figure-variants.mjs|verify-doc.mjs|build-html.mjs|tlc-to-mermaid.mjs|icons.mjs)
            exec node "$EXPLAINER_RUNTIME/skills/explainer/scripts/$script" "$@"
            ;;
          *) printf 'Unsupported explainer script: %s\n' "$script" >&2; exit 2 ;;
        esac
        ;;
      vlmkit|vlmkit-anim)
        exec node "$EXPLAINER_RUNTIME/node_modules/.bin/$command" "$@"
        ;;
      help)
        printf '%s\n' 'explainer setup [--dry-run]' 'explainer run <script.mjs> <args...>' 'explainer vlmkit|vlmkit-anim <args...>'
        ;;
      *) printf 'Unknown explainer command: %s\n' "$command" >&2; exit 2 ;;
    esac
  '';
}
