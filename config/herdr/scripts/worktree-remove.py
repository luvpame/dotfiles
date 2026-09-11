#!/usr/bin/env python3
"""Confirm removal of selected or PR-merged worktrees in the current repo."""

from contextlib import contextmanager
from itertools import cycle
import json
import os
import subprocess
import sys
from threading import Event, Thread


@contextmanager
def loading(message):
    if not sys.stderr.isatty():
        print(f"⏳ {message}", flush=True)
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


def worktrees(workspace):
    with loading("worktree 一覧を取得中…"):
        return json.loads(run("herdr", "worktree", "list", "--workspace", workspace, "--json"))['result']


def merged_pr(root, branch, head):
    with loading(f"PR を取得中… {json.dumps(branch, ensure_ascii=False)}"):
        prs = json.loads(run(
            "gh", "pr", "list", "--head", branch,
            "--state", "all", "--limit", "1000", "--json", "number,state,headRefName,headRefOid", cwd=root,
        ))
    prs = [pr for pr in prs if pr['headRefName'] == branch]
    latest = max(prs, key=lambda pr: pr['number'], default=None)
    return latest if latest and latest['state'] == 'MERGED' and latest['headRefOid'] == head else None


def clean_head(path):
    if not os.path.isdir(path):
        raise RuntimeError("ディレクトリが存在しません")
    try:
        if run("git", "-C", path, "status", "--porcelain", "--untracked-files=all"):
            raise RuntimeError("未コミットの変更があります")
        return run("git", "-C", path, "rev-parse", "HEAD")
    except subprocess.CalledProcessError as error:
        raise RuntimeError("Git で worktree の状態を確認できません") from error


def main(merged=False):
    workspace = os.environ.get('HERDR_ACTIVE_WORKSPACE_ID')
    if not workspace:
        raise RuntimeError("Herdr のカスタムコマンドから実行してください。")
    source = worktrees(workspace)
    root = source['source']['repo_root']
    protected = {root, source['source']['source_checkout_path']}
    candidates = []
    for index, item in enumerate(source['worktrees'], start=1):
        path = item['path']
        if path in protected or item.get('open_workspace_id') == workspace:
            continue
        try:
            with loading(f"worktree を確認中… {index}/{len(source['worktrees'])}"):
                head = clean_head(path)
            pr = None
            if merged:
                if not item.get('branch'):
                    continue
                pr = merged_pr(root, item['branch'], head)
                if not pr:
                    continue
            candidates.append(dict(item, head=head, pr=pr))
        except RuntimeError as error:
            if os.path.isdir(path):
                print(f"対象外: {json.dumps(path, ensure_ascii=False)} — {error}")
    print(f"取得完了: 削除候補 {len(candidates)} 件", flush=True)
    if not candidates:
        input("削除対象の worktree はありません。Enter で閉じます。")
        return
    if not merged:
        rows = '\n'.join(f"{index}\t{json.dumps([item.get('branch'), item['path']], ensure_ascii=False)}"
                         for index, item in enumerate(candidates))
        selection = subprocess.run(
            ['fzf', '--no-height', '--multi', '--layout=reverse', '--prompt=Worktree 削除> ', '--with-nth=2..',
             '--header=Tab: 選択・解除 / Enter: 選択した worktree の削除確認 / Esc: キャンセル'],
            input=rows, text=True, stdout=subprocess.PIPE,
        )
        if selection.returncode in (1, 130):
            return
        selection.check_returncode()
        selected = list(dict.fromkeys(row.split('\t', 1)[0] for row in selection.stdout.splitlines()))
        if not selected:
            return
        if not set(selected) <= {str(i) for i in range(len(candidates))}:
            raise RuntimeError('選択された worktree が一覧にありません。')
        candidates = [candidates[int(index)] for index in selected]
    print('削除対象（開いている workspace のエディタ・エージェントも終了します）:')
    for item in candidates:
        label = json.dumps(item.get('branch') or 'detached HEAD', ensure_ascii=False)
        path = json.dumps(item['path'], ensure_ascii=False)
        details = ' / workspace も終了' if item.get('open_workspace_id') else ''
        if item['pr']:
            details += f" / PR #{item['pr']['number']}"
        print(f"  {label} — {path}{details}")
    print('ブランチは Worktrunk がマージ済みと確認できる場合のみ削除します。')
    if input('削除するには delete と入力: ').strip() != 'delete':
        return
    for item in candidates:
        path = item['path']
        try:
            current = worktrees(workspace)
            matches = [entry for entry in current['worktrees'] if entry['path'] == path]
            if (path in {current['source']['repo_root'], current['source']['source_checkout_path']}
                    or len(matches) != 1
                    or matches[0].get('branch') != item.get('branch')
                    or matches[0].get('open_workspace_id') != item.get('open_workspace_id')
                    or clean_head(path) != item['head']):
                raise RuntimeError('確認後に worktree の状態が変わりました')
            if merged and not merged_pr(root, item['branch'], item['head']):
                raise RuntimeError('マージ済み PR との一致を確認できません')
            if item.get('open_workspace_id'):
                run('herdr', 'workspace', 'close', item['open_workspace_id'])
            result = json.loads(run('wt', '-C', root, 'remove', '--foreground', '--no-hooks', '--format=json', path))
            branch_status = '削除' if result[0]['branch_outcome'] == 'deleted' else '保持'
            print(f"削除しました: {json.dumps(path, ensure_ascii=False)}（ブランチ: {branch_status}）")
        except (subprocess.CalledProcessError, RuntimeError) as error:
            print(f"削除中止: {json.dumps(path, ensure_ascii=False)} — {error}")
            break
    input('Enter で閉じます。')


if __name__ == '__main__':
    try:
        main(merged='--merged' in sys.argv[1:])
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        print(str(error), file=sys.stderr)
        input('Enter で閉じます。')
        sys.exit(1)
    except (EOFError, KeyboardInterrupt):
        sys.exit(0)
