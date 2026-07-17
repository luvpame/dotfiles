import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


STATUSLINE = Path(__file__).with_name("statusline.py")


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
            "--token context=ctx 42% --token five_hour=5h 18% "
            "--token seven_day=7d 31%",
        )

    def test_clears_missing_usage(self):
        _, report = self.run_statusline({})

        self.assertEqual(
            report,
            "pane report-metadata w1:p1 --source claude-statusline "
            "--token context= --token five_hour= --token seven_day=",
        )

    def test_does_not_report_outside_herdr(self):
        _, report = self.run_statusline({}, in_herdr=False)

        self.assertIsNone(report)


if __name__ == "__main__":
    unittest.main()
