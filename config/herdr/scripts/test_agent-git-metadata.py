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
        self.main_commit = self.git("rev-parse", "HEAD").stdout.strip()
        self.git("checkout", "-b", "feature/sidebar")
        (self.repo / "tracked.txt").write_text("one\ntwo\nthree\n")
        self.git("add", "tracked.txt")
        self.git("commit", "-m", "feature")
        (self.repo / "tracked.txt").write_text("one\nthree\nfour\n")
        self.git("add", "tracked.txt")
        (self.repo / "tracked.txt").write_text("one\nthree\nfour\nfive\n")
        (self.repo / "untracked.txt").write_text("new\nlines\n")
        (self.repo / "binary.dat").write_bytes(b"\0binary\n")

        self.git("update-ref", "refs/remotes/origin/main", self.main_commit)
        self.git(
            "symbolic-ref",
            "refs/remotes/origin/HEAD",
            "refs/remotes/origin/main",
        )
        self.write_fake_commands()

    def tearDown(self):
        self.temporary_directory.cleanup()

    def git(self, *args):
        return self.git_at(self.repo, *args)

    def git_at(self, directory, *args):
        return subprocess.run(
            ["git", "-C", directory, *args],
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
            "else\n"
            "  printf '%s\\n' \"$*\" > \"$HERDR_LOG\"\n"
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

    def run_reporter(self, pull_requests, *, gh_exit=0):
        env = {
            **os.environ,
            "PATH": f"{self.bin}{os.pathsep}{os.environ['PATH']}",
            "HERDR_ENV": "1",
            "HERDR_PANE_ID": "w1:p1",
            "HERDR_LOG": str(self.herdr_log),
            "GH_LOG": str(self.gh_log),
            "GH_RESPONSE": json.dumps(pull_requests),
            "GH_EXIT": str(gh_exit),
            "TEST_REPO": str(self.repo),
            "XDG_CACHE_HOME": str(self.cache),
        }
        subprocess.run([REPORTER], env=env, check=True)
        return self.herdr_log.read_text().strip()

    def test_reports_branch_full_checkout_diff_and_open_pull_request(self):
        report = self.run_reporter(
            [
                {
                    "number": 42,
                    "state": "OPEN",
                    "isDraft": False,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T10:00:00Z",
                }
            ]
        )

        self.assertEqual(
            report,
            "pane report-metadata w1:p1 --source agent-git "
            "--token git_branch=\ue0a0 feature/sidebar "
            "--token git_additions=+5 --token git_deletions=-1 "
            "--token pr_open=\uf407 #42 --token pr_draft= "
            "--token pr_merged= --token pr_closed=",
        )

    def test_uses_remote_default_branch_when_no_pull_request_exists(self):
        report = self.run_reporter([])

        self.assertIn("--token git_additions=+5", report)
        self.assertIn("--token git_deletions=-1", report)
        self.assertIn("--token pr_open=", report)

    def test_ignores_changes_added_to_base_after_branching(self):
        base_worktree = self.directory / "base"
        self.git("worktree", "add", base_worktree, "main")
        (base_worktree / "base-only.txt").write_text("base change\n")
        self.git_at(base_worktree, "add", "base-only.txt")
        self.git_at(base_worktree, "commit", "-m", "advance base")
        advanced_base = self.git_at(base_worktree, "rev-parse", "HEAD").stdout.strip()
        self.git("update-ref", "refs/remotes/origin/main", advanced_base)

        report = self.run_reporter([])

        self.assertIn("--token git_additions=+5", report)
        self.assertIn("--token git_deletions=-1", report)

    def test_hides_diff_and_pull_request_when_github_query_fails(self):
        report = self.run_reporter([], gh_exit=1)

        self.assertIn("--token git_branch=\ue0a0 feature/sidebar", report)
        self.assertIn("--token git_additions= --token git_deletions=", report)
        self.assertIn("--token pr_open= --token pr_draft=", report)

    def test_hides_all_git_metadata_for_detached_head(self):
        self.git("checkout", "--detach")

        report = self.run_reporter([])

        self.assertIn("--token git_branch=", report)
        self.assertIn("--token git_additions= --token git_deletions=", report)
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
