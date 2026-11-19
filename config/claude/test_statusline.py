import json
import os
import re
import subprocess
import unittest
from pathlib import Path


STATUSLINE = Path(__file__).with_name("statusline.py")
ANSI_ESCAPE = re.compile(r"\033\[[0-9;]*m")


class StatuslineTest(unittest.TestCase):
    def run_statusline(self, data):
        env = {
            **os.environ,
            "TZ": "Asia/Tokyo",
        }
        result = subprocess.run(
            [str(STATUSLINE)],
            input=json.dumps(data),
            capture_output=True,
            text=True,
            env=env,
            check=True,
        )
        return result.stdout

    def test_displays_model_and_effort(self):
        output = self.run_statusline(
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
        self.assertIn(
            "\uf444 Opus 4.7 \U000f04c5 xhigh",
            ANSI_ESCAPE.sub("", output),
        )

    def test_displays_five_hour_reset_time(self):
        output = self.run_statusline(
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

    def test_displays_seven_day_reset_date_and_time(self):
        output = self.run_statusline(
            {
                "rate_limits": {
                    "seven_day": {
                        "used_percentage": 31,
                        "resets_at": 1738425600,
                    }
                }
            }
        )

        self.assertIn("↻ 02/02 01:00", output)

    def test_aligns_usage_columns(self):
        output = self.run_statusline(
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


if __name__ == "__main__":
    unittest.main()
