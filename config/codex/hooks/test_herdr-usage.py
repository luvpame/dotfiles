import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("herdr-usage.py")


class HerdrUsageTest(unittest.TestCase):
    def run_hook(self, events):
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            transcript = directory / "rollout.jsonl"
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

    def test_reports_context_percentage_only(self):
        events = [
            {
                "type": "event_msg",
                "payload": {
                    "type": "token_count",
                    "info": {
                        "last_token_usage": {"total_tokens": 188031},
                        "model_context_window": 258400,
                    },
                },
            }
        ]

        self.assertEqual(
            self.run_hook(events),
            "pane report-metadata w1:p1 --source codex-usage "
            "--token context=73% --clear-token model "
            "--clear-token effort --clear-token fast_mode",
        )

    def test_clears_unavailable_and_retired_metadata(self):
        self.assertEqual(
            self.run_hook([]),
            "pane report-metadata w1:p1 --source codex-usage "
            "--clear-token context --clear-token model "
            "--clear-token effort --clear-token fast_mode",
        )


if __name__ == "__main__":
    unittest.main()
