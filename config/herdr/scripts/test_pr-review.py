#!/usr/bin/env python3
"""Offline checks: selection gates writes, stale checkouts never launch agents."""

import importlib.util
import json
from pathlib import Path
import subprocess
import sys
from unittest.mock import patch


sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location("pr_review", Path(__file__).with_name("pr-review.py"))
review = importlib.util.module_from_spec(spec)
spec.loader.exec_module(review)


def check(cancel=False, existing=False, stale=False, empty_tabs=False, no_prs=False):
    calls = []

    def run(*args, cwd=None):
        calls.append(args)
        if args[:3] == ("gh", "pr", "list"):
            return json.dumps([] if no_prs else [{"number": 42, "title": "A PR"}])
        if args[:3] == ("gh", "pr", "view"):
            return json.dumps(dict(headRefName="feature", headRefOid="head", baseRefOid="base"))
        if args[0] == "direnv":
            return '{"path":"/repo review"}'
        if args[0] == "git":
            if "rev-parse" in args:
                return "old" if stale else "head"
            return "" if "status" in args else "feature"
        assert args[0] == "herdr", args
        action = args[1:3]
        if action == ("worktree", "list"):
            result = dict(source=dict(repo_root="/repo"), worktrees=[dict(branch="feature", path="/repo review")] if existing else [])
        elif action == ("worktree", "open"):
            result = dict(workspace=dict(workspace_id="w2"))
        elif action == ("tab", "list"):
            result = dict(tabs=[dict(label="code review", tab_id="w2:t1")] if empty_tabs else [])
        elif action == ("pane", "list"):
            result = dict(panes=[dict(tab_id="w2:t1", pane_id="w2:p1")])
        elif action == ("tab", "create"):
            result = dict(root_pane=dict(pane_id=f"w2:p{len(calls)}"))
        elif action == ("pane", "process-info"):
            result = dict(process_info=dict(shell_pid=1, foreground_processes=[dict(pid=1)]))
        else:
            assert action == ("agent", "start"), args
            result = {}
        return json.dumps(dict(result=result))

    selection = subprocess.CompletedProcess([], 130 if cancel else 0, stdout="42\tA PR\n")
    with patch.dict(review.os.environ, HERDR_ACTIVE_WORKSPACE_ID="w1"), \
            patch.object(review, "run", side_effect=run), \
            patch.object(review.subprocess, "run", return_value=selection) as select, \
            patch("builtins.input", return_value="") as acknowledge:
        try:
            review.main()
        except RuntimeError:
            assert stale
        else:
            assert not stale
    if no_prs:
        acknowledge.assert_called_once()
        select.assert_not_called()
        assert len(calls) == 2, calls
        return
    acknowledge.assert_not_called()
    starts = [args for args in calls if args[:3] == ("herdr", "agent", "start")]
    creates = [args for args in calls if args[0] == "direnv"]
    assert len(creates) == (0 if cancel or existing else 1)
    assert len(starts) == (0 if cancel or stale else 2)
    if starts:
        assert "code-review:code-review" in starts[0][-1]
        assert "pr-review-assist" in starts[1][-1]
    if cancel or stale:
        assert not any(args[:3] == ("herdr", "worktree", "open") for args in calls)


check(no_prs=True)
check(cancel=True)
check(existing=True, stale=True)
check(existing=True)
check()
check(existing=True, empty_tabs=True)
print("PR Review checks passed")
