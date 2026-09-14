{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # ローカルスキルの内容編集: config/agents/skills/<名前>/SKILL.md や付属ファイルを編集する。
  # 既存ファイルの編集は即時反映されるため、just switch は不要。
  # 追加: 上記ディレクトリを作り、この一覧に名前を追加して just switch を実行する。
  # 配布停止: この一覧から名前を外して just switch。原本はその後で削除または退避できる。
  # 外部へ移行した6スキルの旧原本は、反映後に archive/agents/skills/ へ退避する。
  localSkills = [
    "conventional-commit"
    "eli33"
    "japanese"
    "japanese-end-focus"
    "mo"
    "obsidian"
    "pr-review-assist"
  ];
  skillsRoot = "${config.home.homeDirectory}/.dotfiles/config/agents/skills";
  # ローカルスキルの配布先。変更時は下の programs.agent-skills.targets も揃える。
  targets = [
    ".agents/skills"
    ".claude/skills"
  ];
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  assertions = [
    {
      assertion = lib.intersectLists localSkills config.programs.agent-skills.skills.enable == [ ];
      message = "Local and external agent skills must have distinct names.";
    }
  ];

  home.file =
    lib.genAttrs targets (_: {
      force = lib.mkForce false;
    })
    // lib.listToAttrs (
      lib.concatMap (
        target:
        map (
          name:
          lib.nameValuePair "${target}/${name}" {
            source = config.lib.file.mkOutOfStoreSymlink "${skillsRoot}/${name}";
          }
        ) localSkills
      ) targets
    );

  home.activation.checkAgentSkillParents = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for parent in "$HOME/.agents" "$HOME/.agents/skills" "$HOME/.claude/skills"; do
      if [ -L "$parent" ]; then
        echo "Agent skills migration required: run script/migrate-agent-skills.sh from the dotfiles checkout." >&2
        exit 1
      fi
    done
    for name in ${lib.escapeShellArgs localSkills}; do
      if [ ! -f "${skillsRoot}/$name/SKILL.md" ]; then
        echo "Local agent skill is missing: $name" >&2
        exit 1
      fi
    done
    for target in ${lib.escapeShellArgs targets}; do
      for name in ${lib.escapeShellArgs (localSkills ++ config.programs.agent-skills.skills.enable)}; do
        path="$HOME/$target/$name"
        if [ -e "$path" ] || [ -L "$path" ]; then
          case "$(readlink "$path" || true)" in
            /nix/store/*-home-manager-files/"$target/$name") ;;
            *) echo "Unmanaged agent skill conflicts with Nix: $path" >&2; exit 1 ;;
          esac
        fi
      done
    done
  '';

  programs.agent-skills = {
    enable = true;
    # 外部スキルの取得元。input は nix/flake.nix の入力名、subdir は取得元内の探索場所。
    # 同じ取得元から追加する場合は nameRegex も広げる（例: "(skill-a|skill-b)"）。
    # 新しい取得元なら nix/flake.nix に flake = false の入力を追加し、ここから参照する。
    sources.external = {
      # 既存6スキルのファイル名変換と差分保持は external-skills.nix で行う。
      # この取得元の追加・削除時は、同ファイルのコピー処理と原本hashも更新する。
      path = import ./external-skills.nix { inherit config inputs pkgs; };
      filter.maxDepth = 1;
    };
    # 外部スキルの追加・配布停止はこの一覧で指定する。sources の絞り込み条件にも含める。
    # 変更後は just switch。入力も変更した場合は、その前に nix/ で nix flake lock path:. を実行。
    # 内容の更新は nix/flake.nix の取得リビジョンを変更する（配布済みファイルは編集しない）。
    # コピー済み6件の内容変更は skill-patches/ と external-skills.nix で管理する。
    skills.enable = [
      "code-simplifier"
      "cognitive-rhythm-writing"
      "empirical-prompt-tuning"
      "herdr"
      "japanese-tech-writing"
      "show-me"
    ];
    # 外部スキルの配布先。変更時は上のローカル用 targets も揃える。
    # プラグイン由来のスキル、Codex の .system と chronicle は、それぞれの管理元に任せる。
    targets = {
      agents = {
        enable = true;
        dest = ".agents/skills";
        structure = "link";
      };
      claude = {
        enable = true;
        dest = ".claude/skills";
        structure = "link";
      };
    };
  };
}
