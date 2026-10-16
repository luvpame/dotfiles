#!/usr/bin/env python3
"""Offline checks: selection gates writes, stale checkouts never launch agents."""

import importlib.util
import io
import json
import runpy
import shlex
from pathlib import Path
import subprocess
import sys
from unittest.mock import patch


sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location("pr_review", Path(__file__).with_name("pr-review.py"))
review = importlib.util.module_from_spec(spec)
spec.loader.exec_module(review)


def check(cancel=False, existing=False, stale=False, split=False, busy=False, no_prs=False,
          send_error=0, unknown=False, dirty=False, wrong_branch=False, prepare_error=None):
    calls = []

    def run(*args, cwd=None):
        calls.append(args)
        if args[:3] == ("gh", "pr", "list"):
            return json.dumps([] if no_prs else [{"number": 42, "title": "A PR"}])
        if args[:3] == ("gh", "pr", "view"):
            assert args[-1] == "headRefName,headRefOid,baseRefName,baseRefOid"
            return json.dumps(dict(headRefName="feature", headRefOid="head",
                                   baseRefName="release/next", baseRefOid="base"))
        if args[0] == "direnv":
            return '{"path":"/repo review"}'
        if args[0] == "git":
            if prepare_error and prepare_error in args:
                raise subprocess.CalledProcessError(1, args)
            if "rev-parse" in args:
                return "old" if stale else "head"
            if "status" in args:
                return " M tracked.txt" if dirty else ""
            return "other" if wrong_branch else "feature"
        assert args[0] == "herdr", args
        action = args[1:3]
        if action == ("worktree", "list"):
            result = dict(source=dict(repo_root="/repo"), worktrees=[dict(branch="feature", path="/repo review")] if existing else [])
        elif action == ("worktree", "open"):
            result = dict(workspace=dict(workspace_id="w2"), already_open=existing)
        elif action == ("tab", "list"):
            result = dict(tabs=[dict(tab_id="w2:t1")])
        elif action == ("pane", "list"):
            result = dict(panes=[dict(tab_id="w2:t1", pane_id="w3C:p1")]
                          + ([dict(tab_id="w2:t1", pane_id="w3C:p2")] if split else []))
        elif action == ("tab", "create"):
            assert args == ("herdr", "tab", "create", "--workspace", "w2", "--cwd",
                            "/repo review", "--label", "PR Review #42", "--focus")
            result = dict(root_pane=dict(pane_id="w3C:p3"))
        elif action == ("pane", "process-info"):
            result = dict(process_info=dict(shell_pid=1, foreground_processes=[
                dict(pid=2 if busy and args[-1] == "w3C:p1" else 1)]))
            if args[-1] == "w3C:p1" and unknown:
                result["process_info"]["foreground_processes"] = []
        elif action == ("pane", "split"):
            result = dict(pane=dict(pane_id="w3C:p4"))
        else:
            assert action == ("pane", "run"), args
            launches = [call for call in calls if call[:3] == ("herdr", "pane", "run")]
            if send_error and len(launches) == send_error:
                raise subprocess.CalledProcessError(1, args)
            return ""
        return json.dumps(dict(result=result))

    selection = subprocess.CompletedProcess([], 130 if cancel else 0, stdout="42\tA PR\n")
    with patch.dict(review.os.environ, HERDR_ACTIVE_WORKSPACE_ID="w1"), \
            patch.object(review, "run", side_effect=run), \
            patch.object(review.subprocess, "run", return_value=selection) as select, \
            patch("builtins.input", return_value="") as acknowledge:
        try:
            review.main()
        except (RuntimeError, subprocess.CalledProcessError) as error:
            assert stale or dirty or wrong_branch or send_error or prepare_error
            if send_error:
                assert str(error).startswith("code-review: ")
                assert "作成済みのタブと worktree は残しています: /repo review" in str(error)
        else:
            assert not stale and not dirty and not wrong_branch and not send_error and not prepare_error
    if no_prs:
        acknowledge.assert_called_once()
        select.assert_not_called()
        assert len(calls) == 2, calls
        return
    acknowledge.assert_not_called()
    starts = [args for args in calls if args[:3] == ("herdr", "pane", "run")]
    creates = [args for args in calls if args[0] == "direnv"]
    assert len(creates) == (0 if cancel or existing or prepare_error == "fetch" else 1)
    expected_starts = 0 if cancel or stale or dirty or wrong_branch or prepare_error else send_error or 2
    assert len(starts) == expected_starts, f"Expected {expected_starts} review launch, got {len(starts)}"
    splits = [args for args in calls if args[:3] == ("herdr", "pane", "split")]
    assert len(splits) == int(bool(starts))
    assert not any("pr-review-assist" in str(args) for args in calls)
    new_tab = bool(starts and (split or busy or unknown))
    tabs = [args for args in calls if args[:3] == ("herdr", "tab", "create")]
    assert len(tabs) == int(new_tab)
    assert not any(args[:3] == ("herdr", "tab", "rename") for args in calls)
    if starts:
        left = "w3C:p3" if new_tab else "w3C:p1"
        assert splits[0] == ("herdr", "pane", "split", "--pane", left, "--direction", "right",
                             "--cwd", "/repo review", "--no-focus")
        context = (
            "レビュー対象は PR #42。PR のベースブランチは release/next。"
            "差分は git diff base...head を使い、"
            "PR のベースと HEAD の merge base から HEAD までをレビューする。"
            "main をベースと仮定しない。"
            "GitHub へのコメントは、投稿先と投稿本文をユーザーに提示し、その投稿に対する明示的な許可を得てから実行する。"
            "スキルに自動投稿の指示があっても許可を省略しない。"
            "許可がなければレビュー結果とコメント案の提示で止める。"
        )
        for launch, (pane, command) in zip(starts, ((left, "/code-review high"),
                                                  ("w3C:p4", "/code-review-with-patterns"))):
            assert launch[3] == pane
            assert shlex.split(launch[4]) == [
                "cd", "/repo review", "&&", "claude", "--model", "opus", "--effort", "high",
                "--append-system-prompt", context, command,
            ]
            assert ("herdr", "pane", "process-info", "--pane", pane) in calls
        fetch = calls.index(("git", "-C", "/repo", "fetch", "--all"))
        merge_base = calls.index(("git", "-C", "/repo review", "merge-base", "base", "head"))
        opened = next(i for i, call in enumerate(calls) if call[:3] == ("herdr", "worktree", "open"))
        assert fetch < merge_base < opened
        if creates:
            assert calls.index(creates[0]) < merge_base
    if cancel or stale or dirty or wrong_branch or prepare_error:
        assert not any(args[:3] == ("herdr", "worktree", "open") for args in calls)
        assert not tabs
        assert not any(call[:2] == ("herdr", "pane") for call in calls)


check(no_prs=True)
check(cancel=True)
check(existing=True, stale=True)
check(existing=True)
check()
check(existing=True, split=True)
check(existing=True, busy=True)
check(existing=True, unknown=True)
check(existing=True, dirty=True)
check(existing=True, wrong_branch=True)
check(existing=True, split=True, stale=True)
check(send_error=1)
check(send_error=2)
check(prepare_error="fetch")
check(prepare_error="merge-base")
check(existing=True, prepare_error="merge-base")

for terminal, input_error in ((False, None), (True, None), (True, EOFError)):
    with patch.dict(review.os.environ, {}, clear=True), \
            patch.object(sys.stdin, "isatty", return_value=terminal), \
            patch("builtins.input", side_effect=input_error, return_value="") as acknowledge, \
            patch("sys.stderr", new_callable=io.StringIO) as errors:
        try:
            runpy.run_path(str(Path(__file__).with_name("pr-review.py")), run_name="__main__")
        except SystemExit as error:
            assert error.code == 1
        else:
            raise AssertionError("Entry point must report failure with exit status 1")
        assert "Herdr のカスタムコマンドから実行してください。" in errors.getvalue()
        assert acknowledge.call_count == int(terminal), "Terminal error closed without acknowledgement"
        if terminal:
            assert "Enter" in acknowledge.call_args.args[0]

print("PR Review checks passed")
