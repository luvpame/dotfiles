{
  inputs,
  pkgs,
}:
# 取得元は flake.nix、配布する名前は skills.nix で変更する。
# ここではファイル名を揃え、コピー時からの変更を skill-patches/ で維持する。
# 上流更新後にパッチや置換が適用できなければ、ビルドを止めて差分を確認する。
pkgs.runCommand "external-agent-skill-sources" { nativeBuildInputs = [ pkgs.patch ]; } ''
  mkdir -p "$out"/code-simplifier

  cp ${inputs.anthropic-skills}/plugins/code-simplifier/agents/code-simplifier.md "$out/code-simplifier/SKILL.md"
  cp ${inputs.anthropic-skills}/plugins/code-simplifier/LICENSE "$out/code-simplifier/LICENSE"
  chmod -R u+w "$out"

  substituteInPlace "$out/code-simplifier/SKILL.md" --replace-fail $'model: opus\n' ""

  # コピー済み原本と一致することを検証する。意図して内容を更新するときだけhashも更新する。
  (cd "$out" && sha256sum --check ${./skill-patches/original-skills.sha256})
''
