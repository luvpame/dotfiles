#!/usr/bin/env python3
"""Offline checks for confirmation, PR matching and deletion guards."""

import importlib.util
import io
import json
from pathlib import Path
import subprocess
import sys
from threading import Event
from unittest.mock import patch

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('remove', Path(__file__).with_name('worktree-remove.py'))
remove = importlib.util.module_from_spec(spec)
spec.loader.exec_module(remove)


def check(merged=True, confirm='delete', state='MERGED', tip='head', dirty=False, changed=False,
          cancel=False, newer=False, failure=False, missing=False, multiple=False):
    calls = []
    acknowledged = False
    listings = 0
    source = dict(source=dict(repo_root='/repo', source_checkout_path='/repo/current'), worktrees=[
        dict(path='/repo', branch='main'),
        dict(path='/repo/current', branch='current', open_workspace_id='w1'),
        dict(path='/repo/feature', branch='feature', open_workspace_id='w2'),
    ])

    if missing:
        source['worktrees'].insert(2, dict(path='/repo/missing', branch='missing'))
    if multiple:
        source['worktrees'].append(dict(path='/repo/second', branch='feature'))

    def run(*args, cwd=None):
        nonlocal listings
        calls.append(args)
        if args[:3] == ('herdr', 'worktree', 'list'):
            assert '一覧を取得中' in messages.call_args.args[0]
            assert messages.call_args.kwargs.get('flush') is True
            listings += 1
            return json.dumps(dict(result=source))
        if args[0] == 'git':
            if args[2] == '/repo/missing':
                raise subprocess.CalledProcessError(128, args)
            assert args[2] in ('/repo/feature', '/repo/second'), args
            if 'status' in args:
                return ' M file' if dirty else ''
            return 'new-head' if changed and listings > 1 else 'head'
        if args[:3] == ('gh', 'pr', 'list'):
            assert 'PR を取得中' in messages.call_args.args[0]
            assert messages.call_args.kwargs.get('flush') is True
            assert cwd == '/repo'
            prs = [dict(number=1, state=state, headRefName='feature', headRefOid=tip)]
            if newer:
                prs.append(dict(number=2, state='OPEN', headRefName='feature', headRefOid='head'))
            return json.dumps(prs)
        assert acknowledged, 'mutation before confirmation'
        if args[:3] == ('herdr', 'workspace', 'close'):
            assert args[3] == 'w2'
            return '{}'
        assert args[:-1] == ('wt', '-C', '/repo', 'remove', '--foreground', '--no-hooks', '--format=json'), args
        assert args[-1] in ('/repo/feature', '/repo/second'), args
        if failure:
            raise subprocess.CalledProcessError(1, args)
        return '[{"branch_outcome":"deleted"}]'

    def answer(prompt):
        nonlocal acknowledged
        if 'delete' in prompt:
            acknowledged = confirm == 'delete'
            return confirm
        return ''

    selection = subprocess.CompletedProcess([], 130 if cancel else 0, stdout='0\tfeature\n1\tsecond\n' if multiple else '0\tfeature\n')
    with patch.dict(remove.os.environ, HERDR_ACTIVE_WORKSPACE_ID='w1'), \
            patch.object(remove, 'run', side_effect=run), \
            patch.object(remove.subprocess, 'run', return_value=selection) as fzf, \
            patch.object(remove.os.path, 'isdir', side_effect=lambda path: path != '/repo/missing'), \
            patch('builtins.input', side_effect=answer), patch('builtins.print') as messages:
        remove.main(merged=merged)
    if missing:
        assert not any('/repo/missing' in str(call) for call in messages.call_args_list)
    if dirty:
        assert any('未コミット' in str(call) for call in messages.call_args_list)
    deletes = [args for args in calls if args[0] == 'wt']
    expected = (confirm == 'delete' and not dirty and not changed
                and (not merged and not cancel or merged and state == 'MERGED' and tip == 'head' and not newer))
    assert len(deletes) == int(expected) * (2 if multiple else 1), calls
    if multiple and not merged:
        assert '--multi' in fzf.call_args.args[0]
        assert '--no-height' in fzf.call_args.args[0]
    closes = [args for args in calls if args[:3] == ('herdr', 'workspace', 'close')]
    assert len(closes) == int(expected)


check(missing=True)
check(merged=False, missing=True)
check(merged=False, multiple=True)
check(multiple=True)
check()
check(merged=False)
check(confirm='no')
check(state='OPEN')
check(state='CLOSED')
check(tip='old')
check(dirty=True)
check(changed=True)
check(newer=True)
check(merged=False, cancel=True)
check(failure=True)
# A checkout disappearing between the directory check and git must also be skipped.
with patch.object(remove.os.path, 'isdir', return_value=True), \
        patch.object(remove, 'run', side_effect=subprocess.CalledProcessError(128, ['git'])):
    try:
        remove.clean_head('/repo/missing')
    except RuntimeError as error:
        assert 'Git' in str(error)
    else:
        raise AssertionError('unreadable checkout was accepted')
# Both completion and failure clear the animated line before the next screen.
class Terminal(io.StringIO):
    def __init__(self):
        super().__init__()
        self.advanced = Event()

    def isatty(self):
        return True

    def write(self, text):
        result = super().write(text)
        if '⠙' in text:
            self.advanced.set()
        return result


for fail in (False, True):
    terminal = Terminal()
    with patch.object(remove.sys, 'stderr', terminal):
        try:
            with remove.loading('取得中'):
                assert terminal.advanced.wait(2), 'spinner did not advance'
                if fail:
                    raise RuntimeError('test failure')
        except RuntimeError:
            assert fail
    assert '⠋ 取得中' in terminal.getvalue()
    assert '⠙ 取得中' in terminal.getvalue()
    assert terminal.getvalue().endswith('\r\033[2K')
print('Worktree removal checks passed')
