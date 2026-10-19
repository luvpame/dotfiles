#!/usr/bin/env python3
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
PATCHES = ROOT / "nix/nix-darwin/home-manager/skill-patches"
LOCAL = ("eli33", "evidence-code-review", "japanese", "japanese-end-focus")
EXTERNAL = {
    "agent-memory-repo": ("agent-memory-repo", "skills/agent-memory-repo"),
    "code-simplifier": (
        "anthropic-skills", "plugins/code-simplifier/agents/code-simplifier.md"
    ),
    "cognitive-rhythm-writing": ("cognitive-rhythm-writing", "SKILL.md"),
    "empirical-prompt-tuning": ("mizchi-skills", "empirical-prompt-tuning/SKILL.md"),
    "japanese-tech-writing": ("japanese-tech-writing", "SKILL.md"),
    "no-ai-slop": ("no-ai-slop", "skills/no-ai-slop"),
    "show-me": ("humanlayer-skills", "plugins/show-me/skills/show-me/SKILL.md"),
    "yomiyasu": ("yomiyasu", "skills/yomiyasu"),
}


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def replace(path, old, new):
    text = path.read_text()
    if old not in text:
        raise ValueError(f"置換対象がありません: {path}: {old}")
    path.write_text(text.replace(old, new))


def patch(path, name):
    subprocess.run(
        ["patch", "-f", "-F", "0", str(path), str(PATCHES / f"{name}.patch")],
        check=True,
    )


def fetch(locked, target):
    if locked["type"] == "github":
        url = f"https://github.com/{locked['owner']}/{locked['repo']}.git"
    elif locked["type"] == "git" and locked["url"].startswith("https://gist.github.com/"):
        url = locked["url"]
    else:
        raise ValueError(f"未対応の取得元: {locked}")
    rev = locked["rev"]
    if not re.fullmatch(r"[0-9a-f]{40}", rev):
        raise ValueError(f"固定コミットではありません: {rev}")
    git = ["git", "-c", "core.hooksPath=/dev/null", "-c", "init.templateDir="]
    subprocess.run([*git, "init", "--quiet", str(target)], check=True)
    git += ["-C", str(target)]
    subprocess.run([*git, "fetch", "--quiet", "--depth=1", url, rev], check=True)
    subprocess.run([*git, "checkout", "--quiet", "--detach", "FETCH_HEAD"], check=True)


def files(root):
    return {
        p.relative_to(root).as_posix(): p.read_bytes()
        for p in sorted(root.rglob("*"))
        if p.is_file() and "__pycache__" not in p.parts and p.suffix != ".pyc"
    }


def generate(work):
    lock = json.loads((ROOT / "nix/flake.lock").read_text())
    inputs = lock["nodes"][lock["root"]]["inputs"]
    sources = {}
    for name in sorted({source for source, _ in EXTERNAL.values()}):
        locked = lock["nodes"][inputs[name]]["locked"]
        print(f"取得: {name} @ {locked['rev']}", flush=True)
        fetch(locked, work / name)
        sources[name] = locked

    bundle = work / "plugin"
    skills = bundle / "skills"
    skills.mkdir(parents=True)
    for name in LOCAL:
        shutil.copytree(ROOT / "config/agents/skills" / name, skills / name)
    for name, (source, subdir) in EXTERNAL.items():
        origin = work / source / subdir
        dest = skills / name
        if origin.is_dir():
            shutil.copytree(
                origin, dest,
                ignore=shutil.ignore_patterns(".claude-plugin", "agents", "__pycache__"),
            )
        else:
            dest.mkdir()
            shutil.copyfile(origin, dest / "SKILL.md")

    for name, source, license_path in (
        ("agent-memory-repo", "agent-memory-repo", "LICENSE"),
        ("code-simplifier", "anthropic-skills", "plugins/code-simplifier/LICENSE"),
        ("no-ai-slop", "no-ai-slop", "LICENSE"),
        ("show-me", "humanlayer-skills", "LICENSE"),
        ("empirical-prompt-tuning", "mizchi-skills", "README.md"),
    ):
        filename = "UPSTREAM.md" if license_path == "README.md" else "LICENSE"
        shutil.copyfile(work / source / license_path, skills / name / filename)

    patch(skills / "empirical-prompt-tuning/SKILL.md", "empirical-prompt-tuning")
    replace(skills / "code-simplifier/SKILL.md", "model: opus\n", "")
    replace(
        skills / "cognitive-rhythm-writing/SKILL.md",
        "作業前に `../japanese-tech-writing/SKILL.md` を読む。",
        "作業前に `../japanese-tech-writing/SKILL.md` と `../japanese-end-focus/SKILL.md` を読む。",
    )
    # ローカル配布と同じ原本・パッチを使い、クラウド向けの差分だけを後で加える。
    for line in (PATCHES / "original-skills.sha256").read_text().splitlines():
        digest, name = line.split()
        if name.split("/")[0] in EXTERNAL:
            actual = hashlib.sha256((skills / name).read_bytes()).hexdigest()
            if actual != digest:
                raise ValueError(f"原本のハッシュが一致しません: {name}")
    for name in ("japanese-tech-writing", "cognitive-rhythm-writing"):
        patch(skills / name / "SKILL.md", name)

    for name in ("japanese", "japanese-end-focus", "cognitive-rhythm-writing"):
        path = skills / name / "SKILL.md"
        text = path.read_text()
        text = text.replace("~/.agents/skills/", "${CLAUDE_PLUGIN_ROOT}/skills/")
        text = re.sub(
            r"\.\./(japanese-tech-writing|japanese-end-focus)/SKILL\.md",
            r"${CLAUDE_PLUGIN_ROOT}/skills/\1/SKILL.md", text,
        )
        path.write_text(text)
    replace(
        skills / "show-me/SKILL.md",
        "Then open it for the user:\n\n```\nBash(open path/to/show-me-{description}.html)\n```",
        "Then provide the user with the path or link to the generated HTML file.",
    )
    replace(skills / "eli33/SKILL.md", "/eli33 <topic>", "/eli33 {topic}")
    for script in ("yomiyasu_lint.py", "yomiyasu_diff.py"):
        replace(
            skills / "yomiyasu/SKILL.md", f"<スキル配置ディレクトリ>/scripts/{script}",
            f'"${{CLAUDE_PLUGIN_ROOT}}/skills/yomiyasu/scripts/{script}"',
        )

    write_json(bundle / "SOURCES.json", {
        "local": list(LOCAL),
        "external": {name: {"input": source, "path": path} for name, (source, path) in EXTERNAL.items()},
        "locked": sources,
    })
    for name in (*LOCAL, *EXTERNAL):
        path = skills / name / "SKILL.md"
        text = path.read_text()
        if f"\nname: {name}\n" not in text or not text.startswith("---\n"):
            raise ValueError(f"スキル名が一致しません: {name}")
        if "~/.agents/skills/" in text or "/nix/store/" in text:
            raise ValueError(f"ローカル参照が残っています: {name}")
        for ref in re.findall(r"\$\{CLAUDE_PLUGIN_ROOT\}/([^`\s\)\"]+)", text):
            if not (bundle / ref).is_file():
                raise ValueError(f"参照先がありません: {name}: {ref}")
    if any(p.is_symlink() for p in bundle.rglob("*")):
        raise ValueError("配布物にシンボリックリンクが含まれています")

    digest = hashlib.sha256()
    for name, content in files(bundle).items():
        digest.update(name.encode() + b"\0" + content + b"\0")
    write_json(bundle / ".claude-plugin/plugin.json", {
        "name": "dotfiles",
        "version": f"0.0.0-experiment.{digest.hexdigest()[:12]}",
        "description": "Experimental portable skills from dotfiles",
        "author": {"name": "luvpame"},
    })
    return bundle


def main():
    parser = argparse.ArgumentParser(description="flake.lock の固定版から試験用クラウドスキルを生成する")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true", help="再生成と比較し、差分があれば失敗する")
    mode.add_argument("--dry-run", action="store_true", help="再生成して差分を表示し、配布物は変更しない")
    args = parser.parse_args()
    target = HERE / "plugin"
    with tempfile.TemporaryDirectory(prefix="dotfiles-cloud-skills-") as directory:
        bundle = generate(Path(directory))
        old, new = files(target), files(bundle)
        changed = sorted(name for name in old.keys() | new.keys() if old.get(name) != new.get(name))
        if args.check or args.dry_run:
            print("\n".join(changed) if changed else "生成物は最新です")
            return int(args.check and bool(changed))
        if changed:
            if target.exists():
                shutil.rmtree(target)
            shutil.copytree(bundle, target)
        print(f"12件のスキルを生成しました: {target.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
