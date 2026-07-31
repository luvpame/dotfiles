import json
import os
import re
import subprocess
import tempfile
import unittest
from pathlib import Path


STATUSLINE = Path(__file__).with_name("statusline.py")
ANSI_ESCAPE = re.compile(r"\033\[[0-9;]*m")


class StatuslineTest(unittest.TestCase):
    def run_statusline(self, data, *, in_herdr=True):
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            log = directory / "herdr.log"
            herdr = directory / "herdr"
            herdr.write_text('#!/bin/sh\nprintf "%s\\n" "$*" > "$HERDR_LOG"\n')
            herdr.chmod(0o755)

            env = {
                **os.environ,
                "PATH": f"{directory}{os.pathsep}{os.environ['PATH']}",
                "HERDR_LOG": str(log),
                "TZ": "Asia/Tokyo",
            }
            if in_herdr:
                env.update(HERDR_ENV="1", HERDR_PANE_ID="w1:p1")
            else:
                env.pop("HERDR_ENV", None)
                env.pop("HERDR_PANE_ID", None)

            result = subprocess.run(
                [str(STATUSLINE)],
                input=json.dumps(data),
                capture_output=True,
                text=True,
                env=env,
                check=True,
            )
            return result.stdout, log.read_text().strip() if log.exists() else None

    def test_reports_claude_usage_to_herdr(self):
        output, report = self.run_statusline(
            {
                "model": {"display_name": "Opus 4.7"},
                "effort": {"level": "xhigh"},
                "context_window": {"used_percentage": 42},
                "rate_limits": {
                    "five_hour": {"used_percentage": 18},
                    "seven_day": {"used_percentage": 31},
                },
            }
        )

        self.assertIn("ctx:", output)
        self.assertEqual(
            report,
            "pane report-metadata w1:p1 --source claude-statusline "
            "--token context=ctx: ⣿⣿⣿⣄     (42%) "
            "--token model=󰚩 Opus 4.7 --token effort=󰓅 xhigh",
        )

    def test_clears_missing_usage(self):
        _, report = self.run_statusline({})

        self.assertEqual(
            report,
            "pane report-metadata w1:p1 --source claude-statusline "
            "--token context= --token model=󰚩 Claude --token effort=",
        )

    def test_displays_five_hour_reset_time(self):
        output, _ = self.run_statusline(
            {
                "rate_limits": {
                    "five_hour": {
                        "used_percentage": 18,
                        "resets_at": 1738425600,
                    }
                }
            }
        )

        self.assertIn("↻ 01:00", output)

    def test_aligns_usage_columns(self):
        output, _ = self.run_statusline(
            {
                "context_window": {"used_percentage": 9},
                "rate_limits": {
                    "five_hour": {"used_percentage": 42},
                    "seven_day": {"used_percentage": 100},
                },
            }
        )
        lines = ANSI_ESCAPE.sub("", output).splitlines()

        self.assertIn("ctx: ⣶        (  9%)", lines)
        self.assertIn("5h:  ⣿⣿⣿⣄     ( 42%)", lines)
        self.assertIn("7d:  ⣿⣿⣿⣿⣿⣿⣿⣿ (100%)", lines)

    def test_does_not_report_outside_herdr(self):
        _, report = self.run_statusline({}, in_herdr=False)

        self.assertIsNone(report)


if __name__ == "__main__":
    unittest.main()
