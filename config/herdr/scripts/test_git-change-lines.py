import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


UPDATER = Path(__file__).with_name("git-change-lines.py")


class GitChangeLinesTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary_directory.name)
        self.repo = self.directory / "repo"
        self.bin = self.directory / "bin"
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
            "if [ \"$1 $2\" = \"workspace list\" ]; then\n"
            "  printf '%s\\n' \"$HERDR_WORKSPACES\"\n"
            "elif [ \"$1 $2\" = \"agent list\" ]; then\n"
            "  printf '%s\\n' \"$HERDR_AGENTS\"\n"
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
            "printf '%s\\n' \"$GH_BASE_BRANCH\"\n"
        )
        gh.chmod(0o755)

    def run_updater(self, *, gh_exit=0):
        workspaces = {
            "result": {
                "workspaces": [
                    {
                        "workspace_id": "w1",
                        "worktree": {"checkout_path": str(self.repo)},
                    },
                    {"workspace_id": "w2"},
                ]
            }
        }
        agents = {
            "result": {
                "agents": [
                    {"pane_id": "w1:p1", "foreground_cwd": str(self.repo)},
                    {"pane_id": "w2:p2", "cwd": str(self.repo)},
                ]
            }
        }
        panes = {
            "result": {
                "panes": [
                    {"foreground_cwd": str(self.repo), "cwd": str(self.repo)}
                ]
            }
        }
        env = {
            **os.environ,
            "PATH": f"{self.bin}{os.pathsep}{os.environ['PATH']}",
            "HERDR_WORKSPACES": json.dumps(workspaces),
            "HERDR_AGENTS": json.dumps(agents),
            "HERDR_PANES": json.dumps(panes),
            "HERDR_LOG": str(self.herdr_log),
            "GH_LOG": str(self.gh_log),
            "GH_BASE_BRANCH": "main",
            "GH_EXIT": str(gh_exit),
        }
        subprocess.run([UPDATER], env=env, check=True)

    def test_updates_spaces_and_agents_and_deduplicates_checkout(self):
        self.run_updater()

        self.assertEqual(
            self.herdr_log.read_text().splitlines(),
            [
                "workspace report-metadata w1 --source git-change-lines "
                "--token git_additions=+5 --token git_deletions=-1",
                "workspace report-metadata w2 --source git-change-lines "
                "--token git_additions=+5 --token git_deletions=-1",
                "pane report-metadata w1:p1 --source git-change-lines "
                "--token git_additions=+5 --token git_deletions=-1",
                "pane report-metadata w2:p2 --source git-change-lines "
                "--token git_additions=+5 --token git_deletions=-1",
            ],
        )
        self.assertEqual(
            self.gh_log.read_text().splitlines(),
            ["pr view --json baseRefName --jq .baseRefName"],
        )

    def test_uses_merge_base_when_remote_base_advances(self):
        base_worktree = self.directory / "base"
        self.git("worktree", "add", base_worktree, "main")
        (base_worktree / "base-only.txt").write_text("base change\n")
        self.git_at(base_worktree, "add", "base-only.txt")
        self.git_at(base_worktree, "commit", "-m", "advance base")
        advanced_base = self.git_at(base_worktree, "rev-parse", "HEAD").stdout.strip()
        self.git("update-ref", "refs/remotes/origin/main", advanced_base)

        self.run_updater()

        for report in self.herdr_log.read_text().splitlines():
            self.assertIn("--token git_additions=+5", report)
            self.assertIn("--token git_deletions=-1", report)

    def test_uses_remote_default_branch_when_pr_lookup_fails(self):
        self.run_updater(gh_exit=1)

        for report in self.herdr_log.read_text().splitlines():
            self.assertIn("--token git_additions=+5", report)
            self.assertIn("--token git_deletions=-1", report)

    def test_clears_lines_for_detached_checkout(self):
        self.git("checkout", "--detach")

        self.run_updater()

        for report in self.herdr_log.read_text().splitlines():
            self.assertIn("--token git_additions= --token git_deletions=", report)
        self.assertFalse(self.gh_log.exists())


if __name__ == "__main__":
    unittest.main()
