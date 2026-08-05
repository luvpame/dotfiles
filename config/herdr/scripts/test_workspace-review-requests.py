import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


UPDATER = Path(__file__).with_name("workspace-review-requests.py")


class WorkspaceReviewRequestsTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary_directory.name)
        self.repo = self.directory / "repo"
        self.bin = self.directory / "bin"
        self.herdr_log = self.directory / "herdr.log"
        self.gh_log = self.directory / "gh.log"
        self.repo.mkdir()
        self.bin.mkdir()
        subprocess.run(
            ["git", "-C", self.repo, "init", "-b", "main"],
            capture_output=True,
            check=True,
        )
        self.write_fake_commands()

    def tearDown(self):
        self.temporary_directory.cleanup()

    def write_fake_commands(self):
        herdr = self.bin / "herdr"
        herdr.write_text(
            "#!/bin/sh\n"
            "if [ \"$1 $2\" = \"workspace list\" ]; then\n"
            "  printf '%s\\n' \"$HERDR_WORKSPACES\"\n"
            "elif [ \"$1 $2\" = \"pane list\" ]; then\n"
            "  printf '%s\\n' \"$HERDR_PANES\"\n"
            "else\n"
            "  printf '%s\\n' \"$*\" >> \"$HERDR_LOG\"\n"
            "fi\n"
        )
        herdr.chmod(0o755)

        gh = self.bin / "gh"
        gh.write_text(
            "#!/bin/sh\n"
            "printf '%s\\n' \"$*\" >> \"$GH_LOG\"\n"
            "if [ \"${GH_EXIT:-0}\" -ne 0 ]; then exit \"$GH_EXIT\"; fi\n"
            "printf '%s\\n' \"$GH_REVIEW_COUNT\"\n"
        )
        gh.chmod(0o755)

    def run_updater(self, *, count=4, gh_exit=0):
        workspaces = {
            "result": {
                "workspaces": [
                    {"workspace_id": "w1"},
                    {
                        "workspace_id": "w2",
                        "worktree": {"repo_root": str(self.repo)},
                    },
                ]
            }
        }
        panes = {
            "result": {
                "panes": [
                    {
                        "foreground_cwd": str(self.repo),
                        "cwd": str(self.repo),
                    }
                ]
            }
        }
        env = {
            **os.environ,
            "PATH": f"{self.bin}{os.pathsep}{os.environ['PATH']}",
            "HERDR_WORKSPACES": json.dumps(workspaces),
            "HERDR_PANES": json.dumps(panes),
            "HERDR_LOG": str(self.herdr_log),
            "GH_LOG": str(self.gh_log),
            "GH_REVIEW_COUNT": str(count),
            "GH_EXIT": str(gh_exit),
        }
        subprocess.run([UPDATER], env=env, check=True)

    def test_updates_every_workspace_without_agent_environment(self):
        self.run_updater()

        self.assertEqual(
            self.herdr_log.read_text().splitlines(),
            [
                "workspace report-metadata w1 --source review-requests "
                "--token review_requests=\uf4af Reviews 4",
                "workspace report-metadata w2 --source review-requests "
                "--token review_requests=\uf4af Reviews 4",
            ],
        )
        self.assertEqual(
            self.gh_log.read_text().splitlines(),
            [
                "pr list --state open --search review-requested:@me "
                "--limit 1000 --json number --jq length"
            ],
        )

    def test_keeps_previous_value_when_github_query_fails(self):
        self.run_updater(gh_exit=1)

        self.assertFalse(self.herdr_log.exists())


if __name__ == "__main__":
    unittest.main()
