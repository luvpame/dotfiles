import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


REPORTER = Path(__file__).with_name("agent-git-metadata.py")


class AgentGitMetadataTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary_directory.name)
        self.repo = self.directory / "repo"
        self.bin = self.directory / "bin"
        self.cache = self.directory / "cache"
        self.herdr_log = self.directory / "herdr.log"
        self.gh_log = self.directory / "gh.log"
        self.repo.mkdir()
        self.bin.mkdir()

        self.git("init", "-b", "main")
        self.git("config", "user.name", "Test User")
        self.git("config", "user.email", "test@example.com")
        (self.repo / "tracked.txt").write_text("one\ntwo\n")
        self.git("add", "tracked.txt")
        self.git("commit", "-m", "initial")
        self.git("checkout", "-b", "feature/sidebar")
        self.write_fake_commands()

    def tearDown(self):
        self.temporary_directory.cleanup()

    def git(self, *args):
        return subprocess.run(
            ["git", "-C", self.repo, *args],
            capture_output=True,
            text=True,
            check=True,
        )

    def write_fake_commands(self):
        herdr = self.bin / "herdr"
        herdr.write_text(
            "#!/bin/sh\n"
            "if [ \"$1 $2\" = \"pane get\" ]; then\n"
            "  printf '{\"result\":{\"pane\":{\"foreground_cwd\":\"%s\"}}}\\n' \"$TEST_REPO\"\n"
            "elif [ \"$1 $2\" = \"workspace get\" ]; then\n"
            "  printf '{\"result\":{\"workspace\":{\"label\":\"%s\"}}}\\n' \"$WORKSPACE_LABEL\"\n"
            "elif [ \"$1 $2\" = \"agent list\" ]; then\n"
            "  printf '%s\\n' \"$HERDR_AGENTS\"\n"
            "else\n"
            "  printf '%s\\n' \"$*\" >> \"$HERDR_LOG\"\n"
            "fi\n"
        )
        herdr.chmod(0o755)

        gh = self.bin / "gh"
        gh.write_text(
            "#!/bin/sh\n"
            "printf 'query\\n' >> \"$GH_LOG\"\n"
            "if [ \"${GH_EXIT:-0}\" -ne 0 ]; then exit \"$GH_EXIT\"; fi\n"
            "printf '%s\\n' \"$GH_RESPONSE\"\n"
        )
        gh.chmod(0o755)

    def run_reporter(
        self,
        pull_requests,
        *,
        agents=None,
        gh_exit=0,
        workspace_label="workspace",
    ):
        if agents is None:
            agents = [{"workspace_id": "w1"}]
        env = {
            **os.environ,
            "PATH": f"{self.bin}{os.pathsep}{os.environ['PATH']}",
            "HERDR_ENV": "1",
            "HERDR_PANE_ID": "w1:p1",
            "HERDR_WORKSPACE_ID": "w1",
            "HERDR_AGENTS": json.dumps({"result": {"agents": agents}}),
            "HERDR_LOG": str(self.herdr_log),
            "GH_LOG": str(self.gh_log),
            "GH_RESPONSE": json.dumps(pull_requests),
            "GH_EXIT": str(gh_exit),
            "TEST_REPO": str(self.repo),
            "WORKSPACE_LABEL": workspace_label,
            "XDG_CACHE_HOME": str(self.cache),
        }
        subprocess.run([REPORTER], env=env, check=True)
        return self.herdr_log.read_text().strip()

    def test_reports_branch_and_open_pull_request(self):
        report = self.run_reporter(
            [
                {
                    "number": 42,
                    "state": "OPEN",
                    "isDraft": False,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T10:00:00Z",
                    "reviewDecision": "APPROVED",
                    "statusCheckRollup": [
                        {"status": "COMPLETED", "conclusion": "SUCCESS"}
                    ],
                }
            ]
        )

        self.assertEqual(
            report.splitlines()[0],
            "pane report-metadata w1:p1 --source agent-git "
            "--token git_branch=\ue0a0 feature/sidebar "
            "--token pr_open=\uf407 #42 --token pr_draft= "
            "--token pr_merged= --token pr_closed= "
            "--clear-token git_additions --clear-token git_deletions",
        )
        self.assertEqual(
            report.splitlines()[1],
            "workspace report-metadata w1 --source workspace-git "
            "--token agent_summary=1 agent "
            "--token git_branch=\ue0a0 feature/sidebar "
            "--token pr_open=\uf407 #42 --token pr_draft= "
            "--token pr_merged= --token pr_closed= "
            "--token ci_status=✓ CI --token review_status=✓ approved "
            "--clear-token git_additions --clear-token git_deletions",
        )

    def test_hides_repeated_branch_and_counts_workspace_agents(self):
        report = self.run_reporter(
            [],
            agents=[{"workspace_id": "w1"}, {"workspace_id": "w1"}],
            workspace_label="feature/sidebar",
        )

        workspace_report = report.splitlines()[1]
        self.assertIn("--token agent_summary=2 agents", workspace_report)
        self.assertIn("--token git_branch= ", workspace_report)

    def test_reports_failed_ci_and_requested_changes(self):
        report = self.run_reporter(
            [
                {
                    "number": 42,
                    "state": "OPEN",
                    "isDraft": False,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T10:00:00Z",
                    "reviewDecision": "CHANGES_REQUESTED",
                    "statusCheckRollup": [
                        {"status": "COMPLETED", "conclusion": "FAILURE"}
                    ],
                }
            ]
        )

        workspace_report = report.splitlines()[1]
        self.assertIn("--token ci_status=× CI", workspace_report)
        self.assertIn("--token review_status=× changes", workspace_report)

    def test_hides_pull_request_when_github_query_fails(self):
        report = self.run_reporter([], gh_exit=1)

        self.assertIn("--token git_branch=\ue0a0 feature/sidebar", report)
        self.assertIn("--token pr_open= --token pr_draft=", report)

    def test_hides_git_branch_and_pull_request_for_detached_head(self):
        self.git("checkout", "--detach")

        report = self.run_reporter([])

        self.assertIn("--token git_branch=", report)
        self.assertFalse(self.gh_log.exists())

    def test_prefers_latest_open_pull_request_and_maps_draft_icon(self):
        report = self.run_reporter(
            [
                {
                    "number": 10,
                    "state": "MERGED",
                    "isDraft": False,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T12:00:00Z",
                },
                {
                    "number": 11,
                    "state": "OPEN",
                    "isDraft": False,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T10:00:00Z",
                },
                {
                    "number": 12,
                    "state": "OPEN",
                    "isDraft": True,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T11:00:00Z",
                },
            ]
        )

        self.assertIn("--token pr_draft=\uf4dd #12", report)
        self.assertIn("--token pr_open=", report)

    def test_caches_successful_pull_request_query_for_sixty_seconds(self):
        pull_requests = [
            {
                "number": 42,
                "state": "OPEN",
                "isDraft": False,
                "baseRefName": "main",
                "updatedAt": "2026-08-03T10:00:00Z",
            }
        ]

        self.run_reporter(pull_requests)
        self.run_reporter(pull_requests)

        self.assertEqual(self.gh_log.read_text().splitlines(), ["query"])


if __name__ == "__main__":
    unittest.main()
