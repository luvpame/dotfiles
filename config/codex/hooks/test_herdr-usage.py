import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("herdr-usage.py")


class HerdrUsageTest(unittest.TestCase):
    def run_hook(self, service_tier):
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            transcript = directory / "rollout.jsonl"
            events = [
                {
                    "type": "turn_context",
                    "payload": {"model": "gpt-5.6-sol", "effort": "low"},
                },
                {
                    "type": "event_msg",
                    "payload": {
                        "type": "thread_settings_applied",
                        "thread_settings": {"service_tier": service_tier},
                    },
                },
                {
                    "type": "event_msg",
                    "payload": {
                        "type": "token_count",
                        "info": {
                            "last_token_usage": {"total_tokens": 188031},
                            "model_context_window": 258400,
                        },
                    },
                },
            ]
            transcript.write_text("\n".join(map(json.dumps, events)) + "\n")
            log = directory / "herdr.log"
            herdr = directory / "herdr"
            herdr.write_text('#!/bin/sh\nprintf "%s\\n" "$*" > "$HERDR_LOG"\n')
            herdr.chmod(0o755)
            env = {
                **os.environ,
                "PATH": f"{directory}{os.pathsep}{os.environ['PATH']}",
                "HERDR_ENV": "1",
                "HERDR_PANE_ID": "w1:p1",
                "HERDR_LOG": str(log),
            }

            subprocess.run(
                [str(SCRIPT)],
                input=json.dumps({"transcript_path": str(transcript)}),
                text=True,
                env=env,
                check=True,
            )

            return log.read_text().strip()

    def test_reports_agent_metadata_with_fast_mode(self):
        self.assertEqual(
            self.run_hook("priority"),
            "pane report-metadata w1:p1 --source codex-usage "
            "--token context=ctx: ⣿⣿⣿⣿⣿⣶   (73%) "
            "--token model=󰚩 gpt-5.6-sol --token effort=󰓅 low "
            "--token fast_mode=󱐋 fast",
        )

    def test_omits_disabled_fast_mode(self):
        self.assertEqual(
            self.run_hook("default"),
            "pane report-metadata w1:p1 --source codex-usage "
            "--token context=ctx: ⣿⣿⣿⣿⣿⣶   (73%) "
            "--token model=󰚩 gpt-5.6-sol --token effort=󰓅 low "
            "--token fast_mode=",
        )


if __name__ == "__main__":
    unittest.main()
