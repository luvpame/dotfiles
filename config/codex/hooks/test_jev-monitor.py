import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('monitor', Path(__file__).with_name('jev-monitor.py'))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)


class MonitorTests(unittest.TestCase):
    def test_incremental_transcript_and_private_reasoning(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'rollout.jsonl'
            rows = [
                {'type': 'response_item', 'payload': {'type': 'message', 'role': 'user', 'content': [{'type': 'input_text', 'text': 'Fix the login bug.'}]}},
                {'type': 'response_item', 'payload': {'type': 'reasoning', 'summary': 'PRIVATE'}},
                {'type': 'response_item', 'payload': {'type': 'message', 'role': 'assistant', 'channel': 'analysis', 'content': [{'type': 'output_text', 'text': 'PRIVATE'}]}},
                {'type': 'token_usage_record', 'payload': {'usage': {'total_tokens': 500}, 'thread_token_usage': {'total_tokens': 900}}},
            ]
            path.write_text(''.join(json.dumps(r) + '\n' for r in rows))
            hook = {'transcript_path': str(path)}
            memory = {}
            first = m.build_state(hook, memory)
            second = m.build_state(hook, memory)
            self.assertNotIn('PRIVATE', json.dumps(first))
            self.assertEqual(len(second['latest_user_messages']), 1)
            self.assertEqual(second['measured_token_usage'][0]['total_token_usage']['total_tokens'], 900)
            self.assertEqual(memory['offset'], path.stat().st_size)

    def test_partial_record_is_retried(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'rollout'
            row = json.dumps({'type': 'response_item', 'payload': {'type': 'function_call', 'name': 'test', 'arguments': '{}'}})
            path.write_text(row[:30])
            memory = {}
            m.observe(str(path), memory)
            path.write_text(row + '\n')
            m.observe(str(path), memory)
            self.assertEqual(memory['activity'][0]['name'], 'test')

    def test_state_is_bounded_and_credential_redacted(self):
        memory = {'requests': [{'text': '日' * 600}] * 5,
                  'rules': [{'text': '日' * 600}] * 3,
                  'initial_requests': [{'text': '日' * 600}] * 4,
                  'usage': [{'unusual': 'x' * 100_000}]}
        with patch.dict(os.environ, {'TYPESAFE_API_KEY': 'test-secret'}):
            state = m.build_state({'tool_response': 'test-secret' + '日' * 50_000}, memory)
        self.assertLessEqual(len(m.compact(state).encode()), m.STATE_BYTES)
        self.assertNotIn('test-secret', m.compact(state))

    def test_advice_is_advisory_and_suppressed_then_repeated(self):
        memory = {}
        high = {'direction': .96, 'token_waste': .99}
        first = m.steer(high, memory)
        self.assertEqual(set(first), {'hookSpecificOutput'})
        self.assertIsNone(m.steer(high, memory))
        self.assertIsNone(m.steer(high, memory))
        self.assertIsNotNone(m.steer(high, memory))
        self.assertIsNone(m.steer({'direction': .1, 'token_waste': .1}, memory))

    def test_api_failure_persists_metadata_without_blocking(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ, {'JEV_MONITOR_STATE_DIR': directory}), patch.object(m, 'evaluate', side_effect=TimeoutError('secret body')):
            stdout, stderr = io.StringIO(), io.StringIO()
            with contextlib.redirect_stdout(stdout), contextlib.redirect_stderr(stderr):
                m.run({'session_id': 's', 'hook_event_name': 'PostToolUse'})
            self.assertEqual(stdout.getvalue(), '')
            self.assertNotIn('secret body', stderr.getvalue())
            result = json.loads(next(Path(directory).glob('*.json')).read_text())
            self.assertEqual(result['last_result']['error'], 'TimeoutError')

    def test_invalid_api_answers_are_rejected(self):
        class Response(io.BytesIO):
            pass
        for value in (True, float('nan'), 1.5, '0.9'):
            response = {'answers': {k: {'type': 'noul', 'noul': value} for k in m.QUESTIONS}}
            with patch.dict(os.environ, {'TYPESAFE_API_KEY': 'fake'}), patch.object(m.urllib.request, 'urlopen', return_value=Response(json.dumps(response).encode())):
                with self.assertRaises(ValueError):
                    m.evaluate({})

    def test_dry_run_does_not_write_or_call_api(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ, {'JEV_MONITOR_STATE_DIR': directory}), patch.object(m, 'evaluate') as api, contextlib.redirect_stdout(io.StringIO()):
            m.run({'session_id': 's', 'hook_event_name': 'PostToolUse'}, dry_run=True)
            api.assert_not_called()
            self.assertEqual(list(Path(directory).iterdir()), [])


if __name__ == '__main__':
    unittest.main()
