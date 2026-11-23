#!/usr/bin/env python3
"""Confirm removal of selected or PR-merged worktrees in the current repo."""

from contextlib import contextmanager
from itertools import cycle
import json
import os
import subprocess
import sys
from threading import Event, Thread
from rex_worktrees import worktrees as rex_worktrees


@contextmanager
def loading(message):
    if not sys.stderr.isatty():
        print(f"⏳ {message}", file=sys.stderr, flush=True)
        yield
        return
    stopped = Event()

    def animate():
        for frame in cycle('⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'):
            print(f"\r\033[2K{frame} {message}", end='', file=sys.stderr, flush=True)
            if stopped.wait(0.08):
                break

    spinner = Thread(target=animate, daemon=True)
    spinner.start()
    try:
        yield
    finally:
        stopped.set()
        spinner.join()
        print('\r\033[2K', end='', file=sys.stderr, flush=True)


def run(*args, cwd=None):
    return subprocess.check_output(args, text=True, cwd=cwd).strip()


def worktrees():
    with loading("worktree 一覧を取得中…"):
        return rex_worktrees()


def merged_pr(root, branch, head):
    with loading(f"PR を取得中… {json.dumps(branch, ensure_ascii=False)}"):
        prs = json.loads(run(
            "gh", "pr", "list", "--head", branch,
            "--state", "all", "--limit", "1000", "--json", "number,state,headRefName,headRefOid", cwd=root,
        ))
    prs = [pr for pr in prs if pr['headRefName'] == branch]
    latest = max(prs, key=lambda pr: pr['number'], default=None)
    return latest if latest and latest['state'] == 'MERGED' and latest['headRefOid'] == head else None


def merged_index(root):
    with loading("マージ済み PR を取得中…"):
        prs = json.loads(run(
            "gh", "pr", "list", "--state", "merged", "--limit", "1000",
            "--json", "number,state,headRefName,headRefOid", cwd=root,
        ))
    by_branch = {}
    for pr in prs:
        current = by_branch.get(pr["headRefName"])
        if current is None or pr["number"] > current["number"]:
            by_branch[pr["headRefName"]] = pr
    return by_branch


def head_state(path):
    if not os.path.isdir(path):
        raise RuntimeError("ディレクトリが存在しません")
    try:
        dirty = bool(run("git", "-C", path, "status", "--porcelain", "--untracked-files=all"))
        return run("git", "-C", path, "rev-parse", "HEAD"), dirty
    except subprocess.CalledProcessError as error:
        raise RuntimeError("Git で worktree の状態を確認できません") from error


def collect(merged=False):
    source = worktrees()
    root = source['source']['repo_root']
    protected = {root, source['source']['source_checkout_path']}
    merged_prs = merged_index(root) if merged else {}
    candidates = []
    for index, item in enumerate(source['worktrees'], start=1):
        path = item['path']
        if path in protected or item.get('open_workspace_id'):
            continue
        try:
            with loading(f"worktree を確認中… {index}/{len(source['worktrees'])}"):
                head, dirty = head_state(path)
            pr = None
            if merged:
                if not item.get('branch'):
                    continue
                pr = merged_prs.get(item['branch'])
                if not pr or pr['headRefOid'] != head or pr['state'] != 'MERGED':
                    continue
            candidates.append(dict(item, head=head, dirty=dirty, pr=pr))
        except RuntimeError as error:
            if os.path.isdir(path):
                print(f"対象外: {json.dumps(path, ensure_ascii=False)} — {error}", file=sys.stderr)
    return root, candidates


def catalog(merged=False):
    root, candidates = collect(merged)
    items = []
    for item in candidates:
        entry = {
            "id": item["path"],
            "title": item.get("branch") or "detached HEAD",
            "subtitle": item["path"],
            "icon": "branch",
        }
        if item.get("pr"):
            entry["title"] += f" / PR #{item['pr']['number']}"
        if item["dirty"]:
            entry["detail"] = "未コミットの変更あり"
            entry["dirty"] = True
        items.append(entry)
    return {"repo_root": root, "items": items}


def remove_paths(paths, merged=False):
    root, candidates = collect(merged)
    by_path = {item["path"]: item for item in candidates}
    missing = [path for path in paths if path not in by_path]
    if missing:
        raise RuntimeError("選択された worktree が一覧にありません。")
    chosen = [by_path[path] for path in paths]
    print(f"取得完了: 削除候補 {len(chosen)} 件", flush=True)
    for item in chosen:
        path = item['path']
        try:
            current = worktrees()
            matches = [entry for entry in current['worktrees'] if entry['path'] == path]
            if (path in {current['source']['repo_root'], current['source']['source_checkout_path']}
                    or len(matches) != 1
                    or matches[0].get('branch') != item.get('branch')
                    or matches[0].get('open_workspace_id') != item.get('open_workspace_id')
                    or head_state(path) != (item['head'], item['dirty'])):
                raise RuntimeError('確認後に worktree の状態が変わりました')
            if merged and not merged_pr(root, item['branch'], item['head']):
                raise RuntimeError('マージ済み PR との一致を確認できません')
            if item.get('open_workspace_id'):
                raise RuntimeError('開いている Rex セッションがあります')
            # 常に --force を付けると、確認画面で警告していない変更まで黙って破棄してしまう。
            force = ['--force'] if item['dirty'] else []
            result = json.loads(run('wt', '-C', root, 'remove', '--foreground', '--no-hooks', '--format=json',
                                    *force, path))
            branch_status = '削除' if result[0]['branch_outcome'] == 'deleted' else '保持'
            print(f"削除しました: {json.dumps(path, ensure_ascii=False)}（ブランチ: {branch_status}）")
        except (subprocess.CalledProcessError, RuntimeError) as error:
            print(f"削除中止: {json.dumps(path, ensure_ascii=False)} — {error}")
            break


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    merged = "--merged" in argv
    rest = [arg for arg in argv if arg != "--merged"]
    if rest == ["--catalog"]:
        json.dump(catalog(merged), sys.stdout, ensure_ascii=False)
        sys.stdout.write("\n")
        return
    if rest and rest[0] == "--remove":
        remove_paths(rest[1:], merged)
        return
    raise SystemExit("usage: worktree-remove.py --catalog [--merged] | --remove [--merged] PATH...")


if __name__ == '__main__':
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
    except (EOFError, KeyboardInterrupt):
        sys.exit(0)
