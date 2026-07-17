import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("herdr-usage.py")


class HerdrUsageTest(unittest.TestCase):
    def test_reports_context_and_rate_limits(self):
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            transcript = directory / "rollout.jsonl"
            transcript.write_text(
                json.dumps(
                    {
                        "type": "event_msg",
                        "payload": {
                            "type": "token_count",
                            "info": {
                                "last_token_usage": {"total_tokens": 188031},
                                "model_context_window": 258400,
                            },
                            "rate_limits": {
                                "primary": {
                                    "used_percent": 3,
                                    "window_minutes": 10080,
                                },
                                "secondary": {
                                    "used_percent": 18,
                                    "window_minutes": 300,
                                },
                            },
                        },
                    }
                )
                + "\n"
            )
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

            self.assertEqual(
                log.read_text().strip(),
                "pane report-metadata w1:p1 --source codex-usage "
                "--token context=ctx: ⣿⣿⣿⣿⣿⣶   (73%) "
                "--token five_hour=5h: ⣿⣤       (18%) "
                "--token seven_day=7d: ⣀        (3%)",
            )


if __name__ == "__main__":
    unittest.main()
