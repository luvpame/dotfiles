import importlib.util
import json
import os
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch

import rex_worktrees


def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, Path(__file__).with_name(filename))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class RexWorkflowsTest(unittest.TestCase):
    def test_session_with_nested_cwd_protects_worktree(self):
        output = b'worktree /repo\0branch refs/heads/main\0\0worktree /repo/wt\0branch refs/heads/topic\0\0'
        def run(*args):
            if args[:2] == ('git', 'rev-parse'):
                return '/repo'
            if args[:2] == ('rex', 'ls'):
                return json.dumps({'sessions': [{'session_id': 's'}]})
            if args[:3] == ('rex', 'block', 'ls'):
                return json.dumps({'blocks': [{'block_id': 'b', 'creator_name': 'com.superlogical.terminal'}]})
            return json.dumps({'foreground': {'cwd': '/repo/wt/subdir'}})
        with patch.object(rex_worktrees, 'run', side_effect=run), patch.object(rex_worktrees.subprocess, 'check_output', return_value=output):
            result = rex_worktrees.worktrees()['worktrees']
        self.assertNotIn('open_workspace_id', result[0])
        self.assertEqual(result[1]['open_workspace_id'], 's')

    def test_unknown_pane_directory_prevents_deletion_check(self):
        def run(*args):
            if args[0] == 'git':
                return '/repo'
            if args[1] == 'ls':
                return '{"sessions":[{"session_id":"s"}]}'
            if args[2] == 'ls':
                return '{"blocks":[{"block_id":"b","creator_name":"com.superlogical.terminal"}]}'
            return '{}'
        with patch.object(rex_worktrees, 'run', side_effect=run), patch.object(rex_worktrees.subprocess, 'check_output', return_value=b'worktree /repo\0\0'):
            with self.assertRaises(RuntimeError):
                rex_worktrees.worktrees()

    def test_review_cancel_does_not_fetch_or_launch(self):
        review = load('review', 'pr-review.py')
        calls = []
        def run(*args, **kwargs):
            calls.append(args)
            return json.dumps([{'number': 42, 'title': 'test'}])
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(review, 'worktrees', return_value={'source': {'repo_root': '/repo'}, 'worktrees': []}), patch.object(review, 'run', side_effect=run), patch.object(review.subprocess, 'run', return_value=subprocess.CompletedProcess([], 130, stdout='')):
            review.main()
        self.assertEqual(len(calls), 1)
        self.assertEqual(calls[0][:3], ('gh', 'pr', 'list'))

    def test_invalid_picker_action_does_not_execute(self):
        picker = load('picker', 'worktree-picker.py')
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(picker, 'select', return_value='unexpected'), patch.object(picker, 'worktrees') as worktrees:
            with self.assertRaises(RuntimeError):
                picker.main()
        worktrees.assert_not_called()

    def test_open_worktree_is_excluded_from_removal(self):
        remove = load('remove', 'worktree-remove.py')
        source = {'source': {'repo_root': '/repo', 'source_checkout_path': '/repo'},
                  'worktrees': [{'path': '/repo'}, {'path': '/repo/active', 'open_workspace_id': 's'}]}
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(remove, 'worktrees', return_value=source), patch.object(remove, 'clean_head') as clean, patch('builtins.input', return_value=''):
            remove.main()
        clean.assert_not_called()


if __name__ == '__main__':
    unittest.main()
