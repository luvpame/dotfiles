import hashlib
import json
import os
import subprocess
import tempfile
import time
import unittest
from pathlib import Path


REPORTER = Path(__file__).with_name("agent-git-metadata.py")


class AgentGitMetadataTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary_directory.name).resolve()
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
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "args = sys.argv[1:]\n"
            "action = ' '.join(args[:2])\n"
            "if action == os.environ.get('HERDR_FAIL'): sys.exit(1)\n"
            "workspaces = json.loads(os.environ['HERDR_WORKSPACES'])\n"
            "panes = json.loads(os.environ['HERDR_PANES'])\n"
            "if action == 'pane get':\n"
            "    result = {'pane': {'foreground_cwd': os.environ['TEST_REPO']}}\n"
            "elif action == 'workspace get':\n"
            "    result = {'workspace': next(w for w in workspaces if w['workspace_id'] == args[2])}\n"
            "elif action == 'workspace list':\n"
            "    result = {'workspaces': workspaces}\n"
            "elif action == 'pane list':\n"
            "    result = {'panes': panes[args[3]]}\n"
            "elif action == 'agent list':\n"
            "    result = json.loads(os.environ['HERDR_AGENTS'])['result']\n"
            "else:\n"
            "    with open(os.environ['HERDR_LOG'], 'a') as file:\n"
            "        file.write(' '.join(args) + '\\n')\n"
            "    sys.exit(0)\n"
            "print(json.dumps({'result': result}))\n"
        )
        herdr.chmod(0o755)

        gh = self.bin / "gh"
        gh.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "args = sys.argv[1:]\n"
            "action = ' '.join(args[:2])\n"
            "with open(os.environ['GH_LOG'], 'a') as file: file.write(action + '\\n')\n"
            "if action.startswith('api '): assert args[args.index('--hostname') + 1] == os.environ['GH_HOST']\n"
            "if action == 'api user':\n"
            "    if int(os.environ['GH_AUTH_EXIT']): sys.exit(1)\n"
            "    print(os.environ['GH_VIEWER'])\n"
            "elif action == 'api graphql':\n"
            "    if int(os.environ['GH_REVIEW_EXIT']): sys.exit(1)\n"
            "    query = args[args.index('-f') + 1]\n"
            "    assert 'viewerDidAuthor' in query\n"
            "    assert 'reviews(author:$login,states:[COMMENTED,APPROVED,CHANGES_REQUESTED,DISMISSED],first:1){totalCount}' in query\n"
            "    assert 'decision:reviews(author:$login,states:[APPROVED,CHANGES_REQUESTED,DISMISSED],last:1){nodes{state}}' in query\n"
            "    assert 'states:[COMMENTED,APPROVED,CHANGES_REQUESTED,DISMISSED]' in args[args.index('-f') + 1]\n"
            "    assert 'login=' + os.environ['GH_VIEWER'] in args\n"
            "    assert '--hostname' in args\n"
            "    reviews = json.loads(os.environ['GH_REVIEWS'])\n"
            "    count = sum(r['author']['login'].lower() == os.environ['GH_VIEWER'].lower() and r['state'] in ('COMMENTED', 'APPROVED', 'CHANGES_REQUESTED', 'DISMISSED') for r in reviews)\n"
            "    decisions = [r for r in reviews if r['author']['login'].lower() == os.environ['GH_VIEWER'].lower() and r['state'] in ('APPROVED', 'CHANGES_REQUESTED', 'DISMISSED')]\n"
            "    nodes = [{'state': r['state']} for r in decisions[-1:]]\n"
            "    response = json.loads(os.environ['GH_REVIEW_RESPONSE'])\n"
            "    print(json.dumps(response if response is not None else {'data': {'node': {'viewerDidAuthor': os.environ['GH_AUTHORED'] == '1', 'reviews': {'totalCount': count}, 'decision': {'nodes': nodes}}}}))\n"
            "else:\n"
            "    if int(os.environ['GH_EXIT']): sys.exit(int(os.environ['GH_EXIT']))\n"
            "    responses = json.loads(os.environ['GH_RESPONSES'])\n"
            "    found = responses.get(os.getcwd(), json.loads(os.environ['GH_RESPONSE']))\n"
            "    for pr in found:\n"
            "        pr.setdefault('id', 'PR_' + str(pr['number']))\n"
            "        pr.setdefault('url', 'https://github.com/example/repo/pull/' + str(pr['number']))\n"
            "    print(json.dumps(found))\n"
        )
        gh.chmod(0o755)

    def run_reporter(
        self,
        pull_requests,
        *,
        agents=None,
        gh_exit=0,
        workspace_label="workspace",
        all_workspaces=False,
        workspaces=None,
        panes=None,
        herdr_fail="",
        gh_responses=None,
        reviews=None,
        viewer_login="me",
        viewer_did_author=False,
        auth_exit=0,
        review_exit=0,
        review_response=None,
        github_host="github.com",
    ):
        if agents is None:
            agents = [{"workspace_id": "w1"}]
        if workspaces is None:
            workspaces = [{"workspace_id": "w1", "label": workspace_label}]
        if panes is None:
            panes = {"w1": [{"pane_id": "w1:p1", "foreground_cwd": str(self.repo)}]}
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
            "GH_RESPONSES": json.dumps(gh_responses or {}),
            "GH_EXIT": str(gh_exit),
            "GH_AUTH_EXIT": str(auth_exit),
            "GH_REVIEW_EXIT": str(review_exit),
            "GH_VIEWER": viewer_login,
            "GH_AUTHORED": "1" if viewer_did_author else "0",
            "GH_REVIEWS": json.dumps(reviews or []),
            "GH_REVIEW_RESPONSE": json.dumps(review_response),
            "GH_HOST": github_host,
            "TEST_REPO": str(self.repo),
            "HERDR_WORKSPACES": json.dumps(workspaces),
            "HERDR_PANES": json.dumps(panes),
            "HERDR_FAIL": herdr_fail,
            "XDG_CACHE_HOME": str(self.cache),
        }
        args = [REPORTER]
        if all_workspaces:
            args.append("--all-workspaces")
            for name in ("HERDR_ENV", "HERDR_PANE_ID", "HERDR_WORKSPACE_ID"):
                env.pop(name, None)
        subprocess.run(args, env=env, check=True, timeout=20)
        return self.herdr_log.read_text().strip() if self.herdr_log.exists() else ""

    def test_reports_branch_and_open_pull_request(self):
        report = self.run_reporter(
            [
                {
                    "number": 42,
                    "state": "OPEN",
                    "isDraft": False,
                    "baseRefName": "main",
                    "updatedAt": "2026-08-03T10:00:00Z",
                }
            ],
            reviews=[{"author": {"login": "me"}, "state": "APPROVED"}],
        )

        self.assertEqual(
            report.splitlines()[0],
            "pane report-metadata w1:p1 --source agent-git "
            "--token git_branch=\ue0a0 feature/sidebar "
            "--token pr_open=\uf407 #42 --token pr_draft= "
            "--token pr_merged= --token pr_closed=",
        )
        self.assertEqual(
            report.splitlines()[1],
            "workspace report-metadata w1 --source workspace-git "
            "--token agent_summary=1 agent "
            "--token git_branch=\ue0a0 feature/sidebar "
            "--token pr_open=\u2800\u2800\uf407 #42 --token pr_draft= "
            "--token pr_merged= --token pr_closed= "
            "--token review_status= --token review_space=",
        )

    def test_marks_review_workspace_with_eye_icon(self):
        report = self.run_reporter([], workspace_label="review-#123")

        self.assertIn("--token review_space=", report)

    def test_does_not_mark_non_review_workspace(self):
        report = self.run_reporter([], workspace_label="review-#123-extra")

        self.assertIn("--token review_space=", report)
        self.assertNotIn("--token review_space=", report)

    def test_hides_repeated_branch_and_counts_workspace_agents(self):
        report = self.run_reporter(
            [],
            agents=[{"workspace_id": "w1"}, {"workspace_id": "w1"}],
            workspace_label="feature/sidebar",
        )

        workspace_report = report.splitlines()[1]
        self.assertIn("--token agent_summary=2 agents", workspace_report)
        self.assertIn("--token git_branch= ", workspace_report)

    def test_marks_own_pull_requests_as_authored_regardless_of_reviews(self):
        for reviews in (
            [],
            [{"author": {"login": "me"}, "state": "COMMENTED"}],
            [{"author": {"login": "other"}, "state": "APPROVED"}],
        ):
            with self.subTest(reviews=reviews):
                self.cache_file().unlink(missing_ok=True)
                report = self.run_reporter(
                    [self.open_pull_request()],
                    all_workspaces=True,
                    viewer_did_author=True,
                    reviews=reviews,
                )
                self.assertIn("--token review_status=● authored", report.splitlines()[-1])

    def test_reports_own_submitted_reviews(self):
        for state in ("COMMENTED", "APPROVED", "CHANGES_REQUESTED", "DISMISSED"):
            with self.subTest(state=state):
                self.cache_file().unlink(missing_ok=True)
                report = self.run_reporter(
                    [self.open_pull_request()],
                    all_workspaces=True,
                    reviews=[
                        {
                            "author": {"login": "Me"},
                            "state": state,
                            "submittedAt": "2026-10-02T07:20:06Z",
                        }
                    ],
                )
                self.assertIn(
                    "--token review_status="
                    + ("✓ approved" if state == "APPROVED" else "✓ reviewed"),
                    report.splitlines()[-1],
                )

    def test_marks_unreviewed_when_only_others_or_pending_or_no_reviews_exist(self):
        for reviews in (
            [],
            [{"author": {"login": "other"}, "state": "APPROVED"}],
            [{"author": {"login": "me"}, "state": "PENDING"}],
        ):
            with self.subTest(reviews=reviews):
                self.cache_file().unlink(missing_ok=True)
                report = self.run_reporter(
                    [self.open_pull_request()], reviews=reviews, all_workspaces=True
                )
                self.assertIn(
                    "--token review_status=○ unreviewed", report.splitlines()[-1]
                )

    def test_pending_review_does_not_hide_previous_submitted_review(self):
        report = self.run_reporter(
            [self.open_pull_request()],
            all_workspaces=True,
            reviews=[
                {"author": {"login": "me"}, "state": "COMMENTED"},
                {"author": {"login": "me"}, "state": "PENDING"},
            ],
        )
        self.assertIn("--token review_status=✓ reviewed", report)

    def test_tracks_latest_own_approval_decision(self):
        for states, expected in (
            (["APPROVED", "COMMENTED"], "✓ approved"),
            (["APPROVED", "PENDING"], "✓ approved"),
            (["APPROVED", "CHANGES_REQUESTED"], "✓ reviewed"),
            (["APPROVED", "DISMISSED"], "✓ reviewed"),
            (["CHANGES_REQUESTED", "APPROVED"], "✓ approved"),
            (["DISMISSED", "APPROVED"], "✓ approved"),
        ):
            with self.subTest(states=states):
                self.cache_file().unlink(missing_ok=True)
                report = self.run_reporter(
                    [self.open_pull_request()],
                    all_workspaces=True,
                    reviews=[
                        {"author": {"login": "me"}, "state": state}
                        for state in states
                    ],
                )
                self.assertIn("--token review_status=" + expected, report.splitlines()[-1])

    def test_other_approval_does_not_approve_own_commented_review(self):
        report = self.run_reporter(
            [self.open_pull_request()],
            all_workspaces=True,
            reviews=[
                {"author": {"login": "me"}, "state": "COMMENTED"},
                {"author": {"login": "other"}, "state": "APPROVED"},
            ],
        )
        self.assertIn("--token review_status=✓ reviewed", report)
        self.assertNotIn("✓ approved", report)

    def test_own_approval_survives_more_than_one_hundred_later_comments(self):
        report = self.run_reporter(
            [self.open_pull_request()],
            all_workspaces=True,
            reviews=[{"author": {"login": "me"}, "state": "APPROVED"}]
            + [{"author": {"login": "me"}, "state": "COMMENTED"}] * 150,
        )
        self.assertIn("--token review_status=✓ approved", report)

    def test_queries_pull_request_host_and_authenticated_user(self):
        report = self.run_reporter(
            [
                {
                    **self.open_pull_request(),
                    "url": "https://github.example.com/team/repo/pull/42",
                }
            ],
            all_workspaces=True,
            github_host="github.example.com",
            viewer_login="enterprise-user",
            reviews=[{"author": {"login": "enterprise-user"}, "state": "COMMENTED"}],
        )
        self.assertIn("--token review_status=✓ reviewed", report)

    def test_finds_own_review_after_more_than_one_hundred_others(self):
        report = self.run_reporter(
            [self.open_pull_request()],
            all_workspaces=True,
            reviews=[{"author": {"login": "other"}, "state": "APPROVED"}] * 150
            + [{"author": {"login": "me"}, "state": "COMMENTED"}],
        )
        self.assertIn("--token review_status=✓ reviewed", report)

    def test_hides_review_status_when_authentication_or_review_query_fails(self):
        for failure in ({"auth_exit": 1}, {"review_exit": 1}):
            with self.subTest(failure=failure):
                self.cache_file().unlink(missing_ok=True)
                report = self.run_reporter(
                    [self.open_pull_request()], all_workspaces=True, **failure
                )
                workspace_report = report.splitlines()[-1]
                self.assertIn("pr_open=⠀⠀ #42", workspace_report)
                self.assertIn(
                    "--token review_status= --token review_space=", workspace_report
                )

    def test_hides_review_status_when_review_response_is_unknown(self):
        for response in (
            *[
                {"data": {"node": {"viewerDidAuthor": value, "reviews": {"totalCount": 1}, "decision": {"nodes": []}}}}
                for value in (None, 1, "true")
            ],
            {"data": {"node": None}},
            {"data": {"node": {"reviews": {"totalCount": None}}}},
            {"data": {"node": {"reviews": {"totalCount": 1}}}},
            *[
                {"data": {"node": {"viewerDidAuthor": False, "reviews": {"totalCount": count}, "decision": {"nodes": nodes}}}}
                for count, nodes in (
                    (None, []),
                    (True, []),
                    (-1, []),
                    (1, None),
                    (1, [None]),
                    (1, [{"state": "COMMENTED"}]),
                    (1, [{"state": []}]),
                    (1, [{"state": "APPROVED"}, {"state": "DISMISSED"}]),
                    (0, [{"state": "APPROVED"}]),
                )
            ],
            {
                "data": {"node": {"reviews": {"totalCount": 0}, "decision": {"nodes": []}}},
                "errors": ["failed"],
            },
        ):
            with self.subTest(response=response):
                self.cache_file().unlink(missing_ok=True)
                report = self.run_reporter(
                    [self.open_pull_request()],
                    all_workspaces=True,
                    review_response=response,
                )
                self.assertIn(
                    "--token review_status= --token review_space=", report.splitlines()[-1]
                )

    def test_hides_review_status_for_missing_closed_and_merged_pull_requests(self):
        for candidates in (
            [],
            [{**self.open_pull_request(), "state": "CLOSED"}],
            [{**self.open_pull_request(), "state": "MERGED"}],
        ):
            with self.subTest(candidates=candidates):
                self.cache_file().unlink(missing_ok=True)
                self.gh_log.unlink(missing_ok=True)
                report = self.run_reporter(candidates, all_workspaces=True)
                self.assertIn(
                    "--token review_status= --token review_space=", report.splitlines()[-1]
                )
                self.assertEqual(self.gh_log.read_text().splitlines(), ["pr list"])

    def open_pull_request(self):
        return {"number": 42, "state": "OPEN", "baseRefName": "main"}

    def cache_file(self):
        key = hashlib.sha256(f"{self.repo}\0feature/sidebar".encode()).hexdigest()
        return self.cache / "herdr" / "agent-git-metadata" / f"{key}.json"

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

    def test_hook_caches_pull_requests_without_waiting_for_review_api(self):
        pull_requests = [
            {
                "number": 42,
                "state": "OPEN",
                "isDraft": False,
                "baseRefName": "main",
                "updatedAt": "2026-08-03T10:00:00Z",
            }
        ]

        report = self.run_reporter(pull_requests)
        self.run_reporter(pull_requests)

        self.assertIn("--token pr_open=⠀⠀ #42", report)
        self.assertIn("--token review_status= --token review_space=", report)
        self.assertEqual(self.gh_log.read_text().splitlines(), ["pr list"])

    def test_poller_enriches_hook_cache_and_hooks_display_cached_review(self):
        for state, expected in (
            ("AUTHORED", "● authored"),
            ("UNREVIEWED", "○ unreviewed"),
            ("REVIEWED", "✓ reviewed"),
            ("APPROVED", "✓ approved"),
        ):
            with self.subTest(state=state):
                self.cache_file().unlink(missing_ok=True)
                self.gh_log.unlink(missing_ok=True)
                self.herdr_log.unlink(missing_ok=True)
                self.run_reporter([self.open_pull_request()])
                cached = json.loads(self.cache_file().read_text())
                self.assertNotIn("viewerReviewState", cached["pull_requests"][0])
                report = self.run_reporter(
                    [self.open_pull_request()],
                    all_workspaces=True,
                    viewer_did_author=state == "AUTHORED",
                    reviews=[] if state == "UNREVIEWED" else [
                        {
                            "author": {"login": "me"},
                            "state": "APPROVED" if state == "APPROVED" else "COMMENTED",
                        }
                    ],
                )
                self.assertIn("--token review_status=" + expected, report.splitlines()[-1])
                self.herdr_log.unlink()
                report = self.run_reporter([], auth_exit=1, review_exit=1)
                self.assertIn("--token pr_open=⠀⠀ #42", report)
                self.assertIn("--token review_status=" + expected, report)
                cached = json.loads(self.cache_file().read_text())
                self.assertEqual(cached["pull_requests"][0]["viewerReviewState"], state)
                self.assertEqual(
                    self.gh_log.read_text().splitlines(),
                    ["pr list", "api user", "api graphql"],
                )

    def test_poller_caches_pull_requests_and_review_for_sixty_seconds(self):
        self.run_reporter([self.open_pull_request()], all_workspaces=True)
        self.run_reporter([self.open_pull_request()], all_workspaces=True)
        self.assertEqual(
            self.gh_log.read_text().splitlines(), ["pr list", "api user", "api graphql"]
        )

    def test_poller_does_not_retry_failed_review_query_within_cache_ttl(self):
        self.run_reporter([self.open_pull_request()])
        self.run_reporter([self.open_pull_request()], all_workspaces=True, review_exit=1)
        cached = json.loads(self.cache_file().read_text())
        self.assertIn("viewerReviewState", cached["pull_requests"][0])
        self.assertIsNone(cached["pull_requests"][0]["viewerReviewState"])
        self.herdr_log.unlink()
        report = self.run_reporter([self.open_pull_request()], all_workspaces=True)
        self.assertIn("--token pr_open=⠀⠀ #42", report)
        self.assertIn("--token review_status= --token review_space=", report)
        self.assertEqual(
            self.gh_log.read_text().splitlines(), ["pr list", "api user", "api graphql"]
        )

    def test_refreshes_old_review_decision_cache(self):
        path = self.cache_file()
        path.parent.mkdir(parents=True)
        path.write_text(
            json.dumps(
                {
                    "queried_at": time.time(),
                    "pull_requests": [
                        {**self.open_pull_request(), "reviewDecision": "APPROVED"}
                    ],
                }
            )
        )
        report = self.run_reporter([self.open_pull_request()], all_workspaces=True)
        self.assertIn("--token review_status=○ unreviewed", report)
        self.assertEqual(
            self.gh_log.read_text().splitlines(), ["pr list", "api user", "api graphql"]
        )

    def test_refreshes_old_boolean_review_cache(self):
        path = self.cache_file()
        path.parent.mkdir(parents=True)
        path.write_text(json.dumps({
            "version": 2,
            "queried_at": time.time(),
            "pull_requests": [{**self.open_pull_request(), "viewerReviewed": True}],
        }))
        report = self.run_reporter(
            [self.open_pull_request()],
            all_workspaces=True,
            reviews=[{"author": {"login": "me"}, "state": "APPROVED"}],
        )
        self.assertIn("--token review_status=✓ approved", report)
        self.assertEqual(
            self.gh_log.read_text().splitlines(), ["pr list", "api user", "api graphql"]
        )
        cached = json.loads(path.read_text())
        self.assertEqual(cached["version"], 4)
        self.assertNotIn("viewerReviewed", cached["pull_requests"][0])
        self.assertEqual(cached["pull_requests"][0]["viewerReviewState"], "APPROVED")

    def test_refreshes_reviewed_cache_for_own_pull_request(self):
        path = self.cache_file()
        path.parent.mkdir(parents=True)
        path.write_text(json.dumps({
            "version": 3,
            "queried_at": time.time(),
            "pull_requests": [{**self.open_pull_request(), "viewerReviewState": "REVIEWED"}],
        }))
        report = self.run_reporter(
            [self.open_pull_request()], all_workspaces=True, viewer_did_author=True
        )
        self.assertIn("--token review_status=● authored", report)
        cached = json.loads(path.read_text())
        self.assertEqual(cached["version"], 4)
        self.assertEqual(cached["pull_requests"][0]["viewerReviewState"], "AUTHORED")

    def test_refreshes_expired_review_result(self):
        self.run_reporter([self.open_pull_request()], all_workspaces=True)
        path = self.cache_file()
        cached = json.loads(path.read_text())
        cached["queried_at"] = time.time() - 61
        path.write_text(json.dumps(cached))
        report = self.run_reporter(
            [self.open_pull_request()],
            all_workspaces=True,
            reviews=[{"author": {"login": "me"}, "state": "COMMENTED"}],
        )
        self.assertIn("--token review_status=✓ reviewed", report.splitlines()[-1])
        self.assertEqual(
            self.gh_log.read_text().splitlines(),
            ["pr list", "api user", "api graphql"] * 2,
        )

    def second_repository(self):
        repo = self.directory / "other-repo"
        subprocess.run(
            ["git", "clone", "--quiet", str(self.repo), str(repo)], check=True
        )
        subprocess.run(
            ["git", "-C", str(repo), "checkout", "--quiet", "-b", "other-branch"],
            check=True,
        )
        return repo

    def test_polls_two_workspaces_without_agent_environment(self):
        other = self.second_repository()
        report = self.run_reporter(
            [],
            all_workspaces=True,
            agents=[],
            workspaces=[
                {"workspace_id": "w1", "label": "workspace"},
                {"workspace_id": "w2", "label": "review-#12"},
            ],
            panes={
                "w1": [{"pane_id": "w1:p1", "cwd": str(self.repo)}],
                "w2": [
                    {"pane_id": "w2:p2", "cwd": str(self.repo)},
                    {
                        "pane_id": "w2:p1",
                        "foreground_cwd": str(self.directory),
                        "cwd": str(other),
                    },
                ],
            },
            gh_responses={
                str(other): [
                    {
                        "number": 12,
                        "state": "OPEN",
                        "baseRefName": "main",
                    }
                ]
            },
            reviews=[{"author": {"login": "me"}, "state": "APPROVED"}],
        )

        lines = report.splitlines()
        self.assertEqual(len(lines), 5)
        self.assertIn("pane report-metadata w1:p1", lines[0])
        self.assertIn("git_branch= feature/sidebar", lines[1])
        self.assertIn("workspace report-metadata w2", lines[4])
        self.assertIn("git_branch= other-branch", lines[4])
        self.assertIn("--token agent_summary= ", lines[4])
        self.assertIn("--token review_space=", lines[4])
        self.assertIn("--token pr_open=⠀⠀ #12", lines[4])
        self.assertIn("--token review_status=✓ approved", lines[4])

    def test_hook_and_poller_use_worktree_instead_of_other_pane_repository(self):
        other = self.second_repository()
        workspaces = [
            {
                "workspace_id": "w1",
                "label": "workspace",
                "worktree": {"checkout_path": str(other)},
            }
        ]
        responses = {
            str(self.repo): [{"number": 42, "state": "OPEN", "baseRefName": "main"}],
            str(other): [{"number": 99, "state": "OPEN", "baseRefName": "main"}],
        }
        for all_workspaces in (False, True):
            with self.subTest(all_workspaces=all_workspaces):
                self.herdr_log.unlink(missing_ok=True)
                report = self.run_reporter(
                    [],
                    all_workspaces=all_workspaces,
                    workspaces=workspaces,
                    gh_responses=responses,
                )
                pane_report, workspace_report = report.splitlines()
                self.assertIn("pr_open= #42", pane_report)
                self.assertIn("git_branch= other-branch", workspace_report)
                self.assertIn("pr_open=⠀⠀ #99", workspace_report)
                self.assertNotIn("#42", workspace_report)

    def test_empty_worktree_workspace_still_reports_git_metadata(self):
        report = self.run_reporter(
            [],
            all_workspaces=True,
            workspaces=[
                {
                    "workspace_id": "w1",
                    "label": "workspace",
                    "worktree": {"checkout_path": str(self.repo)},
                }
            ],
            panes={"w1": []},
        )

        self.assertEqual(len(report.splitlines()), 1)
        self.assertIn("workspace report-metadata w1", report)
        self.assertIn("git_branch= feature/sidebar", report)

    def test_invalid_worktree_does_not_fall_back_to_valid_pane(self):
        other = self.second_repository()
        subprocess.run(["git", "-C", str(other), "checkout", "--detach"], check=True)
        for root in (self.directory, other, self.directory / "missing"):
            with self.subTest(root=root):
                self.herdr_log.unlink(missing_ok=True)
                report = self.run_reporter(
                    [],
                    all_workspaces=True,
                    workspaces=[
                        {
                            "workspace_id": "w1",
                            "label": "workspace",
                            "worktree": {"checkout_path": str(root)},
                        }
                    ],
                )
                pane_report, workspace_report = report.splitlines()
                self.assertIn("git_branch= feature/sidebar", pane_report)
                self.assertIn("git_branch= --token pr_open=", workspace_report)

    def test_non_git_and_detached_panes_clear_metadata(self):
        self.git("checkout", "--detach")
        report = self.run_reporter(
            [],
            all_workspaces=True,
            panes={
                "w1": [
                    {"pane_id": "w1:p1", "cwd": str(self.repo)},
                    {"pane_id": "w1:p2", "cwd": str(self.directory)},
                ]
            },
        )

        self.assertEqual(len(report.splitlines()), 3)
        for line in report.splitlines():
            self.assertIn("git_branch= --token pr_open=", line)
        self.assertFalse(self.gh_log.exists())

    def test_api_failure_does_not_clear_metadata(self):
        for action in ("workspace list", "pane list"):
            with self.subTest(action=action):
                report = self.run_reporter(
                    [], all_workspaces=True, herdr_fail=action
                )
                self.assertEqual(report, "")
        self.assertFalse(self.gh_log.exists())

    def test_hook_pane_api_failure_does_not_clear_pane_metadata(self):
        report = self.run_reporter([], herdr_fail="pane get")

        self.assertEqual(len(report.splitlines()), 1)
        self.assertIn("workspace report-metadata w1", report)

    def test_empty_workspace_clears_git_metadata(self):
        report = self.run_reporter(
            [], all_workspaces=True, panes={"w1": []}, agents=[]
        )

        self.assertEqual(len(report.splitlines()), 1)
        self.assertIn("git_branch= --token pr_open=", report)
        self.assertFalse(self.gh_log.exists())


if __name__ == "__main__":
    unittest.main()
