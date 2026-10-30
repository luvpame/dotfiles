#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from rex_worktrees import open_session, run, worktrees


def select(rows, prompt):
    result = subprocess.run(['fzf', '--no-sort', '--layout=reverse', f'--prompt={prompt}'],
                            input='\n'.join(rows), text=True, stdout=subprocess.PIPE)
    if result.returncode in (1, 130):
        return None
    result.check_returncode()
    return result.stdout.rstrip('\n')


def main():
    if not os.environ.get('REX_SESSION'):
        raise RuntimeError('Rex のカスタムコマンドから実行してください。')
    actions = ['PR Review', 'Worktree 作成・移動', 'Original Root',
               'Worktree 削除', 'マージ済み PR の Worktree を一括削除']
    action = select(actions, 'repo action> ')
    if not action:
        return
    if action not in actions:
        raise RuntimeError('選択された操作が一覧にありません。')
    scripts = os.path.dirname(os.path.abspath(__file__))
    if action == 'PR Review':
        subprocess.run([sys.executable, os.path.join(scripts, 'pr-review.py')], check=True)
        return
    if action in ('Worktree 削除', 'マージ済み PR の Worktree を一括削除'):
        args = [sys.executable, os.path.join(scripts, 'worktree-remove.py')]
        if action != 'Worktree 削除':
            args.append('--merged')
        subprocess.run(args, check=True)
        return
    data = worktrees()
    root = data['source']['repo_root']
    if action == 'Original Root':
        open_session(root, ['cc'])
        return
    entries = [entry for entry in data['worktrees'] if entry['path'] not in
               (root, data['source']['source_checkout_path'])]
    rows = ['New Worktree'] + [f'{i}\t{json.dumps([x.get("branch"), x["path"]], ensure_ascii=False)}'
                               for i, x in enumerate(entries)]
    selection = select(rows, 'worktree> ')
    if not selection:
        return
    if selection == 'New Worktree':
        name = input('Worktree name: ').strip()
        if not name:
            return
        run('git', '-C', root, 'fetch', '--all')
        refs = run('git', '-C', root, 'for-each-ref', '--format=%(refname:short)', 'refs/heads', 'refs/remotes').splitlines()
        create = [] if any(ref == name or ref.endswith('/' + name) for ref in refs) else ['--create']
        result = json.loads(run('direnv', 'exec', root, 'wt', '-C', root, 'switch', '--no-cd',
                                '--no-hooks', *create, name, '--format=json'))
        path = result['path']
        subprocess.run(['direnv', 'exec', root, 'wt', '-C', path, 'hook', 'pre-start', '--foreground'], check=True)
    else:
        if selection not in rows:
            raise RuntimeError('選択された worktree が一覧にありません。')
        path = entries[int(selection.split('\t', 1)[0])]['path']
    open_session(path, ['cc'])


if __name__ == '__main__':
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        print(error, file=sys.stderr)
        if sys.stdin.isatty():
            input('Enter で閉じます。')
        sys.exit(1)
