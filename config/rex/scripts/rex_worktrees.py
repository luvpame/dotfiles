import json
import os
import subprocess


def run(*args):
    return subprocess.check_output(args, text=True).strip()


def worktrees():
    checkout = run('git', 'rev-parse', '--show-toplevel')
    raw = subprocess.check_output(['git', 'worktree', 'list', '--porcelain', '-z'])
    entries = []
    item = {}
    for field in raw.split(b'\0'):
        if not field:
            if item:
                entries.append(item)
                item = {}
        elif field.startswith(b'worktree '):
            item['path'] = os.fsdecode(field[9:])
        elif field.startswith(b'branch '):
            item['branch'] = os.fsdecode(field[7:]).removeprefix('refs/heads/')
    if item:
        entries.append(item)
    sessions = json.loads(run('rex', 'ls', '--json'))['sessions']
    for session in sessions:
        sid = session['session_id']
        blocks = json.loads(run('rex', 'block', 'ls', '-s', sid, '--json'))['blocks']
        for block in blocks:
            if block.get('creator_name') != 'com.superlogical.terminal':
                continue
            process = json.loads(run('rex', 'block', 'call', '-s', sid, '-b', block['block_id'], 'process'))
            cwd = (process.get('foreground') or {}).get('cwd') or (process.get('child') or {}).get('cwd')
            if not cwd:
                raise RuntimeError(f"Rex ペインの作業ディレクトリを確認できません: {block['block_id']}")
            for entry in sorted(entries, key=lambda x: len(x['path']), reverse=True):
                if os.path.commonpath((os.path.realpath(cwd), os.path.realpath(entry['path']))) == os.path.realpath(entry['path']):
                    entry.setdefault('open_workspace_id', sid)
                    break
    return {'source': {'repo_root': entries[0]['path'], 'source_checkout_path': checkout}, 'worktrees': entries}


def open_session(path, command=None):
    data = worktrees()
    existing = next((x.get('open_workspace_id') for x in data['worktrees'] if x['path'] == path), None)
    if existing:
        run('rex', 'do', 'session.select', f'session_id={existing}')
        return existing
    args = ['rex', 'new', os.path.basename(path), '-c', path, '--json']
    if command:
        args += ['--', *command]
    session = json.loads(run(*args))['session_id']
    run('rex', 'do', 'session.select', f'session_id={session}')
    return session
