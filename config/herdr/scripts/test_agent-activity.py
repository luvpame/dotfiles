import json
import os
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("agent-activity.py")


class AgentActivityTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.log = self.directory / "calls.jsonl"
        self.config = self.directory / "config.toml"
        self.config.write_text('[ui]\nsidebar_width = 72\nsidebar_max_width = 72\n')
        fake = '''#!/usr/bin/env python3
import json, os, pathlib, sys, time
name = pathlib.Path(sys.argv[0]).name
entry = {"name": name, "args": sys.argv[1:]}
if name == "claude":
    entry["input"] = json.load(sys.stdin)
    entry["herdr_env"] = os.environ.get("HERDR_ENV")
    entry["claudecode"] = os.environ.get("CLAUDECODE")
with open(os.environ["TEST_LOG"], "a") as log:
    log.write(json.dumps(entry) + "\\n")
if name == "claude":
    time.sleep(float(os.environ.get("TEST_DELAY", "0")))
    print(os.environ.get("TEST_SUMMARY", "設定を確認しています。"))
    sys.exit(int(os.environ.get("TEST_EXIT", "0")))
'''
        for name in ("claude", "herdr"):
            path = self.directory / name
            path.write_text(fake)
            path.chmod(0o755)
        self.env = {**os.environ, "PATH": f"{self.directory}{os.pathsep}{os.environ['PATH']}",
                    "HERDR_ENV": "1", "HERDR_PANE_ID": "w1:p1", "CLAUDECODE": "1",
                    "HERDR_CONFIG_PATH": str(self.config),
                    "TEST_LOG": str(self.log)}

    def calls(self):
        return [json.loads(line) for line in self.log.read_text().splitlines()] if self.log.exists() else []

    def run_hook(self, payload, **env):
        return subprocess.run([sys.executable, SCRIPT], input=json.dumps(payload), text=True,
                              env={**self.env, **env}, capture_output=True, check=True, timeout=5)

    def test_summarizes_requests_and_replies_in_isolated_claude(self):
        for event, field in (("UserPromptSubmit", "prompt"), ("Stop", "last_assistant_message")):
            with self.subTest(event=event):
                self.log.unlink(missing_ok=True)
                self.run_hook({"hook_event_name": event, field: "対象の文章"})
                reserve, claude, publish = self.calls()
                self.assertIn("--clear-token", reserve["args"])
                self.assertEqual(claude["input"], {"event": event, "text": "対象の文章", "最大文字数": 32})
                self.assertIn("--safe-mode", claude["args"])
                self.assertEqual(claude["args"][claude["args"].index("--tools") + 1], "")
                self.assertIsNone(claude["herdr_env"])
                self.assertIsNone(claude["claudecode"])
                self.assertIn("activity=設定を確認しています。", publish["args"])
                self.assertEqual(int(publish["args"][publish["args"].index("--seq") + 1]),
                                 int(reserve["args"][reserve["args"].index("--seq") + 1]) + 1)

    def test_reports_one_short_sentence_without_control_characters(self):
        self.run_hook({"hook_event_name": "Stop", "last_assistant_message": "返信"},
                      TEST_SUMMARY='「設定\nを\x1b確認しています。余分な文。」')
        self.assertIn("activity=設定 を確認しています。", self.calls()[-1]["args"])

    def test_fits_japanese_summary_within_sidebar_columns(self):
        self.run_hook({"hook_event_name": "Stop", "last_assistant_message": "返信"},
                      TEST_SUMMARY="あ" * 100)
        token = self.calls()[-1]["args"][-1]
        self.assertLessEqual(len(token.removeprefix("activity=")) * 2 + 5, 72)
        self.assertTrue(token.endswith("…。"))

    def test_fits_mixed_width_text_and_respects_smaller_sidebar_maximum(self):
        self.config.write_text('[ui]\nsidebar_width = 72\nsidebar_max_width = 24\n')
        self.run_hook({"hook_event_name": "Stop", "last_assistant_message": "返信"},
                      TEST_SUMMARY="API設定のtestを実行しています")
        token = self.calls()[-1]["args"][-1].removeprefix("activity=")
        import unicodedata
        cells = sum(2 if unicodedata.east_asian_width(c) in ("W", "F", "A") else 1 for c in token)
        self.assertLessEqual(cells + 5, 24)

    def test_ignores_invalid_events_and_subagents(self):
        for payload in ([], {}, {"hook_event_name": []},
                        {"hook_event_name": "Stop", "last_assistant_message": ""},
                        {"hook_event_name": "Stop", "last_assistant_message": "返信", "agent_id": "child"}):
            self.run_hook(payload)
        self.run_hook({"hook_event_name": "Stop", "last_assistant_message": "返信"}, HERDR_ENV="")
        self.assertEqual(self.calls(), [])

    def test_failed_summary_does_not_publish_text(self):
        self.run_hook({"hook_event_name": "Stop", "last_assistant_message": "返信"}, TEST_EXIT="1")
        self.assertEqual(len(self.calls()), 2)
        self.assertIn("--clear-token", self.calls()[0]["args"])

    def test_new_request_reserves_a_sequence_above_an_older_slow_reply(self):
        old = subprocess.Popen([sys.executable, SCRIPT], stdin=subprocess.PIPE,
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                               env={**self.env, "TEST_DELAY": "0.4", "TEST_SUMMARY": "古い作業です。"})
        old.stdin.write(json.dumps({"hook_event_name": "Stop", "last_assistant_message": "古い返信"}))
        old.stdin.close()
        deadline = time.monotonic() + 3
        while not any(call["name"] == "claude" for call in self.calls()):
            self.assertLess(time.monotonic(), deadline)
            time.sleep(0.01)
        self.run_hook({"hook_event_name": "UserPromptSubmit", "prompt": "新しい依頼"},
                      TEST_SUMMARY="新しい作業です。")
        self.assertEqual(old.wait(timeout=3), 0)
        old.stdout.close()
        old.stderr.close()
        reports = [call["args"] for call in self.calls() if call["name"] == "herdr"]
        newest = max(reports, key=lambda args: int(args[args.index("--seq") + 1]))
        self.assertIn("activity=新しい作業です。", newest)
        self.assertIn("activity=古い作業です。", reports[-1])


if __name__ == "__main__":
    unittest.main()
