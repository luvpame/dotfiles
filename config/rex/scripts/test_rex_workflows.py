import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
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
            if '--search' in args:
                return json.dumps([{'number': 42, 'title': 'test', 'baseRefName': 'main'}])
            return '[]'
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(review, 'worktrees', return_value={'source': {'repo_root': '/repo'}, 'worktrees': []}), patch.object(review, 'run', side_effect=run), patch.object(review.subprocess, 'run', return_value=subprocess.CompletedProcess([], 130, stdout='')):
            review.main()
        self.assertEqual(len(calls), 2)
        self.assertTrue(all(call[:3] == ('gh', 'pr', 'list') for call in calls))

    def test_review_picker_identifies_branch_relationships_and_escapes_display_fields(self):
        review = load('review', 'pr-review.py')
        open_prs = [
            {'number': 1, 'headRefName': 'root', 'baseRefName': 'main', 'isCrossRepository': False},
            {'number': 2, 'headRefName': 'middle', 'baseRefName': 'root', 'isCrossRepository': False},
            {'number': 3, 'headRefName': 'leaf', 'baseRefName': 'middle', 'isCrossRepository': False},
            {'number': 4, 'headRefName': 'regular', 'baseRefName': 'release', 'isCrossRepository': False},
            {'number': 5, 'headRefName': 'outside-review', 'baseRefName': 'main', 'isCrossRepository': False},
            {'number': 6, 'headRefName': 'child', 'baseRefName': 'outside-review', 'isCrossRepository': True},
            {'number': 7, 'headRefName': 'fork-only', 'baseRefName': 'main', 'isCrossRepository': True},
            {'number': 8, 'headRefName': 'unrelated', 'baseRefName': 'fork-only', 'isCrossRepository': False},
            {'number': 9, 'headRefName': 'controls', 'baseRefName': 'base\n\x1b[31m', 'isCrossRepository': False},
            {'number': 10, 'headRefName': 'other-child', 'baseRefName': 'root', 'isCrossRepository': False},
            {'number': 11, 'headRefName': 'root', 'baseRefName': 'main', 'isCrossRepository': True},
        ]
        for pr in open_prs:
            pr['title'] = 'test'
        requested = [{'number': pr['number'], 'title': 'title\t\n\x1b[31m' if pr['number'] == 9 else 'test',
                      'baseRefName': pr['baseRefName']} for pr in open_prs if pr['number'] not in (5, 7, 10, 11)]
        def run(*args, **kwargs):
            self.assertEqual(args[:3], ('gh', 'pr', 'list'))
            self.assertEqual(kwargs['cwd'], '/repo')
            if '--search' in args:
                self.assertIn('review-requested:@me', args)
                return json.dumps(requested)
            self.assertIn('number,title,headRefName,baseRefName,isCrossRepository', args)
            return json.dumps(open_prs)
        with patch.dict(os.environ, {'REX_SESSION': 's'}), \
                patch.object(review, 'worktrees', return_value={'source': {'repo_root': '/repo'}, 'worktrees': []}), \
                patch.object(review, 'run', side_effect=run), \
                patch.object(review.subprocess, 'run', return_value=subprocess.CompletedProcess([], 130, stdout='')) as fzf:
            review.main()
        rows = fzf.call_args.kwargs['input'].splitlines()
        self.assertEqual(rows, [
            '1\t#1 "test" base "main"',
            '2\t├─ #2 "test" base "root"',
            '3\t│  └─ #3 "test" base "middle"',
            '10\t└─ #10 "test" base "root" [参考]',
            '4\t#4 "test" base "release"',
            '5\t#5 "test" base "main" [参考]',
            '6\t└─ #6 "test" base "outside-review"',
            '8\t#8 "test" base "fork-only"',
            '9\t#9 "title\\t\\n\\u001b[31m" base "base\\n\\u001b[31m"',
        ])
        for option in ('--delimiter=\t', '--with-nth=2..', '--no-sort'):
            self.assertIn(option, fzf.call_args.args[0])

    def test_review_tree_keeps_requested_pr_missing_from_open_list(self):
        review = load('review', 'pr-review.py')
        requested = [{'number': 42, 'title': 'missing', 'baseRefName': 'main'}]
        self.assertEqual(review.review_rows(requested, []), ['42\t#42 "missing" base "main"'])

    def test_review_tree_visits_cycles_and_multiple_parents_once(self):
        review = load('review', 'pr-review.py')
        cases = [
            [('a', 'b'), ('b', 'a'), ('c', 'a')],
            [('a', 'main'), ('a', 'main'), ('b', 'a'), ('c', 'b')],
        ]
        for branches in cases:
            with self.subTest(branches=branches):
                prs = [{'number': number, 'title': 'test', 'headRefName': head,
                        'baseRefName': base, 'isCrossRepository': False}
                       for number, (head, base) in enumerate(branches, 1)]
                rows = review.review_rows([prs[-1]], prs)
                numbers = [int(row.split('\t', 1)[0]) for row in rows]
                self.assertCountEqual(numbers, range(1, len(prs) + 1))

    def test_review_tree_handles_a_thousand_nested_prs(self):
        review = load('review', 'pr-review.py')
        prs = [{'number': number, 'title': 'test', 'headRefName': str(number),
                'baseRefName': str(number - 1), 'isCrossRepository': False}
               for number in range(1, 1001)]
        rows = review.review_rows([prs[-1]], prs)
        self.assertEqual([int(row.split('\t', 1)[0]) for row in rows], list(range(1, 1001)))

    def test_reference_selection_returns_to_picker_without_fetching_or_launching(self):
        review = load('review', 'pr-review.py')
        prs = [
            {'number': 1, 'title': 'parent', 'headRefName': 'parent', 'baseRefName': 'main', 'isCrossRepository': False},
            {'number': 2, 'title': 'child', 'headRefName': 'child', 'baseRefName': 'parent', 'isCrossRepository': False},
        ]
        selections = [subprocess.CompletedProcess([], 0, stdout='1\t#1 "parent" [参考]'),
                      subprocess.CompletedProcess([], 130, stdout='')]
        with patch.dict(os.environ, {'REX_SESSION': 's'}), \
                patch.object(review, 'worktrees', return_value={'source': {'repo_root': '/repo'}, 'worktrees': []}), \
                patch.object(review, 'run', side_effect=[json.dumps([prs[1]]), json.dumps(prs)]) as run, \
                patch.object(review.subprocess, 'run', side_effect=selections) as fzf:
            review.main()
        self.assertEqual(run.call_count, 2)
        self.assertEqual(fzf.call_count, 2)
        self.assertTrue(all(call.args[0][0] == 'fzf' for call in fzf.call_args_list))
        self.assertIn('--header=PR #1 はレビュー対象外です。レビュー依頼のある PR を選択してください',
                      fzf.call_args.args[0])

    def test_review_rejects_a_number_outside_the_picker(self):
        review = load('review', 'pr-review.py')
        requested = [{'number': 42, 'title': 'test', 'baseRefName': 'main'}]
        with patch.dict(os.environ, {'REX_SESSION': 's'}), \
                patch.object(review, 'worktrees', return_value={'source': {'repo_root': '/repo'}, 'worktrees': []}), \
                patch.object(review, 'run', side_effect=[json.dumps(requested), '[]']) as run, \
                patch.object(review.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, stdout='99\tforged')):
            with self.assertRaisesRegex(RuntimeError, '選択された PR が一覧にありません'):
                review.main()
        self.assertEqual(run.call_count, 2)

    def test_review_launches_each_agent_in_its_own_pane(self):
        review = load('review', 'pr-review.py')
        splits = []
        def run(*args, **kwargs):
            if args[:3] == ('gh', 'pr', 'list'):
                if '--search' in args:
                    return json.dumps([{'number': 42, 'title': 't', 'baseRefName': 'main'}])
                return json.dumps([{'number': 42, 'title': 't', 'headRefName': 'topic', 'baseRefName': 'main',
                                    'isCrossRepository': False}])
            if args[:3] == ('gh', 'pr', 'view'):
                return json.dumps({'headRefName': 'topic', 'headRefOid': 'h', 'baseRefName': 'main',
                                   'baseRefOid': 'b', 'url': 'https://github.com/o/r/pull/42'})
            if '--git-path' in args:
                return '/repo/.git/worktrees/wt/rex-dev-server.md'
            if args[-2:] == ('rev-parse', 'HEAD'):
                return 'h'
            if args[-1] == '--show-current':
                return 'topic'
            if args[:2] == ('rex', 'new'):
                return json.dumps({'session_id': 's2', 'initial_windows': [{'block_ids': ['p0']}], 'launcher': args[-1]})
            if args[:3] == ('rex', 'window', 'new'):
                splits.append(args[-1])
                return json.dumps({'block_ids': [f'p{len(splits)}']})
            return ''
        source = {'source': {'repo_root': '/repo'}, 'worktrees': [{'path': '/repo/wt', 'branch': 'topic'}]}
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        mkdtemp = tempfile.mkdtemp
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(review, 'worktrees', return_value=source), \
                patch.object(review, 'run', side_effect=run) as mocked, \
                patch.object(review.tempfile, 'mkdtemp', side_effect=lambda prefix: mkdtemp(prefix=prefix, dir=temporary.name)), \
                patch.object(review.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, stdout='42\t"t"')):
            review.main()
        orchestrator = next(c.args[-1] for c in mocked.call_args_list if c.args[:2] == ('rex', 'new'))
        scripts = [Path(path).read_text(encoding='utf-8') for path in (orchestrator, *splits)]
        expected = [('opus', '/rex '), ('opus', '/code-review medium'), ('opus', '/code-review-with-patterns'),
                    ('sonnet', '/agent-browser 開発サーバーを起動'), ('sonnet', '/agent-browser レビューで出た')]
        for script, (model, command) in zip(scripts, expected, strict=True):
            self.assertIn(f'--model {model} ', script)
            self.assertIn(command, script)
        results = Path(scripts[1].split('最終レビュー全体を ')[1].split(' に保存')[0]).parent
        for name in ('review-1.md', 'review-2.md', 'qa.md', 'repro.md'):
            self.assertIn(str(results / name), scripts[0])
        self.assertIn(str(results / 'review-2.md'), scripts[4])
        self.assertIn('サマリーのコメントには、動作確認コメントへのリンクだけを添える', scripts[0])
        self.assertIn('-R o/r ', scripts[3])
        self.assertIn('/repo/.git/worktrees/wt/rex-dev-server.md.lock', scripts[3])

    def test_invalid_picker_action_does_not_execute(self):
        picker = load('picker', 'worktree-picker.py')
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(picker, 'select', return_value='unexpected'), patch.object(picker, 'worktrees') as worktrees:
            with self.assertRaises(RuntimeError):
                picker.main()
        worktrees.assert_not_called()

    def test_picker_launches_claude_for_root_existing_and_new_worktrees(self):
        picker = load('picker', 'worktree-picker.py')
        source = {'source': {'repo_root': '/repo', 'source_checkout_path': '/repo'},
                  'worktrees': [{'path': '/repo'}, {'path': '/repo/topic', 'branch': 'topic'}]}
        cases = [(['Original Root'], '/repo'),
                 (['Worktree 作成・移動', '0\t["topic", "/repo/topic"]'], '/repo/topic'),
                 (['Worktree 作成・移動', 'New Worktree'], '/repo/new-topic')]
        for selections, path in cases:
            with self.subTest(selections=selections), \
                    patch.dict(os.environ, {'REX_SESSION': 's'}), \
                    patch.object(picker, 'select', side_effect=selections), \
                    patch.object(picker, 'worktrees', return_value=source), \
                    patch.object(picker, 'run', side_effect=['', 'main', '{"path":"/repo/new-topic"}']), \
                    patch.object(picker.subprocess, 'run'), \
                    patch('builtins.input', return_value='new-topic'), \
                    patch.object(rex_worktrees, 'worktrees', return_value=source), \
                    patch.object(rex_worktrees, 'run', return_value='{"session_id":"new"}') as run:
                picker.main()
                run.assert_any_call('rex', 'new', os.path.basename(path), '-c', path, '--json', '--',
                                    'env', 'CLAUDE_CODE_NO_FLICKER=1', 'claude', '--model', 'opus', '--effort', 'high')

    def test_open_worktree_is_excluded_from_removal(self):
        remove = load('remove', 'worktree-remove.py')
        source = {'source': {'repo_root': '/repo', 'source_checkout_path': '/repo'},
                  'worktrees': [{'path': '/repo'}, {'path': '/repo/active', 'open_workspace_id': 's'}]}
        with patch.dict(os.environ, {'REX_SESSION': 's'}), patch.object(remove, 'worktrees', return_value=source), patch.object(remove, 'clean_head') as clean, patch('builtins.input', return_value=''):
            remove.main()
        clean.assert_not_called()


if __name__ == '__main__':
    unittest.main()
