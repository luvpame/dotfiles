{
  inputs,
  pkgs,
}:
# 取得元は flake.nix、配布する名前は skills.nix で変更する。
# ここではファイル名を揃え、コピー時からの変更を skill-patches/ で維持する。
# 上流更新後にパッチや置換が適用できなければ、ビルドを止めて差分を確認する。
pkgs.runCommand "external-agent-skill-sources" { nativeBuildInputs = [ pkgs.patch ]; } ''
  mkdir -p "$out"/{show-me,code-simplifier,empirical-prompt-tuning,herdr}

  cp ${inputs.humanlayer-skills}/plugins/show-me/skills/show-me/SKILL.md "$out/show-me/SKILL.md"
  cp ${inputs.humanlayer-skills}/LICENSE "$out/show-me/LICENSE"
  cp ${inputs.anthropic-skills}/plugins/code-simplifier/agents/code-simplifier.md "$out/code-simplifier/SKILL.md"
  cp ${inputs.anthropic-skills}/plugins/code-simplifier/LICENSE "$out/code-simplifier/LICENSE"
  cp ${inputs.mizchi-skills}/empirical-prompt-tuning/SKILL.md "$out/empirical-prompt-tuning/SKILL.md"
  cp ${inputs.mizchi-skills}/README.md "$out/empirical-prompt-tuning/UPSTREAM.md"
  cp ${inputs.herdr-skills}/skills/herdr/SKILL.md "$out/herdr/SKILL.md"
  cp ${inputs.herdr-skills}/LICENSE "$out/herdr/LICENSE"
  chmod -R u+w "$out"

  patch --batch --fuzz=0 --no-backup-if-mismatch "$out/empirical-prompt-tuning/SKILL.md" < ${./skill-patches/empirical-prompt-tuning.patch}
  patch --batch --fuzz=0 --no-backup-if-mismatch "$out/herdr/SKILL.md" < ${./skill-patches/herdr.patch}
  substituteInPlace "$out/code-simplifier/SKILL.md" --replace-fail $'model: opus\n' ""

  # コピー済み原本と一致することを検証する。意図して内容を更新するときだけhashも更新する。
  (cd "$out" && sha256sum --check ${./skill-patches/original-skills.sha256})
''
