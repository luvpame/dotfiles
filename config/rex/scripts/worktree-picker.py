#!/usr/bin/env python3
import json
import subprocess
import sys
from rex_worktrees import open_session, run, worktrees

CLAUDE = ["env", "CLAUDE_CODE_NO_FLICKER=1", "claude", "--model", "opus", "--effort", "high"]


def catalog():
    data = worktrees()
    root = data["source"]["repo_root"]
    checkout = data["source"]["source_checkout_path"]
    items = []
    for entry in data["worktrees"]:
        if entry["path"] in (root, checkout):
            continue
        items.append({
            "id": entry["path"],
            "title": entry.get("branch") or entry["path"],
            "subtitle": entry["path"],
            "icon": "branch",
        })
    return {"repo_root": root, "items": items}


def open_root():
    open_session(worktrees()["source"]["repo_root"], CLAUDE)


def open_path(path):
    open_session(path, CLAUDE)


def create(name):
    name = name.strip()
    if not name:
        return
    root = worktrees()["source"]["repo_root"]
    run("git", "-C", root, "fetch", "--all")
    refs = run("git", "-C", root, "for-each-ref", "--format=%(refname:short)", "refs/heads", "refs/remotes").splitlines()
    create_flag = [] if any(ref == name or ref.endswith("/" + name) for ref in refs) else ["--create"]
    result = json.loads(run(
        "direnv", "exec", root, "wt", "-C", root, "switch", "--no-cd", "--no-hooks",
        *create_flag, name, "--format=json",
    ))
    path = result["path"]
    subprocess.run(["direnv", "exec", root, "wt", "-C", path, "hook", "pre-start", "--foreground"], check=True)
    open_session(path, CLAUDE)


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    if argv == ["--catalog"]:
        json.dump(catalog(), sys.stdout, ensure_ascii=False)
        sys.stdout.write("\n")
        return
    if argv == ["--root"]:
        open_root()
        return
    if len(argv) == 2 and argv[0] == "--open":
        open_path(argv[1])
        return
    if len(argv) == 2 and argv[0] == "--create":
        create(argv[1])
        return
    raise SystemExit("usage: worktree-picker.py --catalog | --root | --open PATH | --create NAME")


if __name__ == "__main__":
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
