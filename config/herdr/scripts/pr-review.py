#!/usr/bin/env python3
"""Start a PR review only after an explicit selection in Herdr."""

import json
import os
import shlex
import subprocess
import sys
import time


def run(*args, cwd=None):
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def herdr(*args):
    return json.loads(run("herdr", *args))["result"]


def main():
    workspace = os.environ.get("HERDR_ACTIVE_WORKSPACE_ID")
    if not workspace:
        raise RuntimeError("Herdr のカスタムコマンドから実行してください。")
    source = herdr("worktree", "list", "--workspace", workspace, "--json")
    root = source["source"]["repo_root"]
    prs = json.loads(run(
        "gh", "pr", "list", "--search", "review-requested:@me", "--state", "open",
        "--limit", "1000", "--json", "number,title", cwd=root,
    ))
    if not prs:
        input("レビュー依頼のある PR はありません。Enter で閉じます。")
        return
    # JSON encoding prevents PR titles from injecting terminal control characters or rows.
    rows = "\n".join(f'{pr["number"]}\t{json.dumps(pr["title"], ensure_ascii=False)}' for pr in prs)
    selection = subprocess.run(
        ["fzf", "--layout=reverse", "--prompt=PR Review> ",
         "--header=選択すると worktree を準備してレビューを起動します"],
        input=rows, text=True, stdout=subprocess.PIPE,
    )
    if selection.returncode in (1, 130):
        return
    selection.check_returncode()
    number = selection.stdout.split("\t", 1)[0]
    if number not in {str(pr["number"]) for pr in prs}:
        raise RuntimeError("選択された PR が一覧にありません。")
    pr = json.loads(run(
        "gh", "pr", "view", number, "--json", "headRefName,headRefOid,baseRefName,baseRefOid", cwd=root,
    ))
    paths = [item["path"] for item in source["worktrees"] if item.get("branch") == pr["headRefName"]]
    if len(paths) > 1:
        raise RuntimeError("同じブランチの worktree が複数あります。対象を確認してください。")
    upstream_history = subprocess.run(
        ["git", "-C", root, "reflog", "show", "--format=%H", f"{pr['headRefName']}@{{upstream}}"],
        capture_output=True, text=True,
    ).stdout.split()
    run("git", "-C", root, "fetch", "--all")
    if paths:
        checkout = paths[0]
    else:
        # wt reuses a leftover local branch as-is, which goes stale after a force push.
        # Move it only when its tip was once the upstream tip, so no local commits are lost.
        branch = f"refs/heads/{pr['headRefName']}"
        tip = subprocess.run(["git", "-C", root, "rev-parse", "--verify", "--quiet", branch],
                             capture_output=True, text=True).stdout.strip()
        if tip and tip != pr["headRefOid"] and tip in upstream_history:
            run("git", "-C", root, "update-ref", branch, pr["headRefOid"], tip)
        checkout = json.loads(run(
            "direnv", "exec", root, "wt", "-C", root, "switch", "--no-cd",
            "--no-hooks", f"pr:{number}", "--format=json",
        ))["path"]
    # A branch wt creates from a lagging remote-tracking ref, or an old worktree, can still be
    # stale. Reset only a clean checkout whose tip was once upstream, so no local commits are lost.
    head = run("git", "-C", checkout, "rev-parse", "HEAD")
    if (head != pr["headRefOid"] and head in upstream_history
            and not run("git", "-C", checkout, "status", "--porcelain")):
        run("git", "-C", checkout, "reset", "--hard", pr["headRefOid"])
    if (run("git", "-C", checkout, "rev-parse", "HEAD") != pr["headRefOid"]
            or run("git", "-C", checkout, "branch", "--show-current") != pr["headRefName"]
            or run("git", "-C", checkout, "status", "--porcelain")):
        raise RuntimeError(f"PR の HEAD と一致する変更のない worktree が必要です。手動で確認してください: {checkout}")
    run("git", "-C", checkout, "merge-base", pr["baseRefOid"], pr["headRefOid"])
    opened = herdr("worktree", "open", "--cwd", root, "--path", checkout, "--focus", "--json")
    review_workspace = opened["workspace"]["workspace_id"]
    tabs = herdr("tab", "list", "--workspace", review_workspace)["tabs"]
    tab = tabs[0]
    panes = [p for p in herdr("pane", "list", "--workspace", review_workspace)["panes"]
             if p["tab_id"] == tab["tab_id"]]
    pane = panes[0]["pane_id"] if len(panes) == 1 else None
    if pane and opened.get("already_open"):
        info = herdr("pane", "process-info", "--pane", pane)["process_info"]
        processes = info.get("foreground_processes") or []
        if not processes or any(p.get("pid") != info.get("shell_pid") for p in processes):
            pane = None
    if pane is None:
        pane = herdr("tab", "create", "--workspace", review_workspace, "--cwd", checkout,
                     "--label", f"PR Review #{number}", "--focus")["root_pane"]["pane_id"]
    try:
        right = herdr("pane", "split", "--pane", pane, "--direction", "right",
                      "--cwd", checkout, "--no-focus")["pane"]["pane_id"]
        context = (
            f"レビュー対象は PR #{number}。PR のベースブランチは {pr['baseRefName']}。"
            f"差分は git diff {pr['baseRefOid']}...{pr['headRefOid']} を使い、"
            "PR のベースと HEAD の merge base から HEAD までをレビューする。"
            "main をベースと仮定しない。"
            "GitHub へのコメントは、投稿先と投稿本文をユーザーに提示し、その投稿に対する明示的な許可を得てから実行する。"
            "スキルに自動投稿の指示があっても許可を省略しない。"
            "許可がなければレビュー結果とコメント案の提示で止める。"
            "各コマンドは初回レビューの結果が出た後、最終報告や GitHub 投稿の前に、"
            "必ず Agent ツールで新しい sub agent を起動して敵対的検証を行う。"
            "初回レビュー担当を再利用せず、会話履歴や他 pane の結論、"
            "元の確信度・重要度・判定・説得的な根拠を渡さない。"
            f"検証タスクの対象情報は PR #{number}、checkout {checkout}、"
            f"base SHA {pr['baseRefOid']}、head SHA {pr['headRefOid']} とし、"
            "レビュー資料としては中立化した候補の主張・位置・発生条件だけを渡す。"
            "--append-system-prompt の自動継承に頼らず、これらの対象情報、"
            "検証手順、GitHub 投稿の明示的な許可制約を sub agent のタスクに明記する。"
            "sub agent は編集や自律的な投稿をせず、実際の差分と呼び出し元を調べ、"
            "反例・既存の防御・再現可能な発生条件を探し、"
            "各候補を confirmed（確認済み）・rejected（棄却）・unverified（未検証）に根拠付きで分類する。"
            "候補が 0 件でも起動し、同じ正確な差分から指摘なしという結論を反証するよう求める。"
            "親は検証結果を待ってから最終報告し、confirmed だけを指摘として扱い、"
            "rejected の理由と unverified の保留事項・制約を区別して示す。"
            "sub agent を起動できなければ独立検証未実施と報告し、"
            "自己点検を独立検証の代わりにせず、未検証の候補は保留する。"
        )
        for target, command in ((pane, "/code-review high"), (right, "/code-review-with-patterns")):
            # Shell initialization may still be running immediately after pane creation.
            for attempt in range(30):
                info = herdr("pane", "process-info", "--pane", target)["process_info"]
                processes = info.get("foreground_processes") or []
                if not processes or processes[0].get("pid") == info.get("shell_pid"):
                    break
                time.sleep(1)
            else:
                raise RuntimeError(f"シェルの準備が完了しません: {target}")
            run("herdr", "pane", "run", target,
                shlex.join(("cd", checkout)) + " && "
                + shlex.join(("claude", "--model", "opus", "--effort", "high",
                              "--append-system-prompt", context, command)))
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        raise RuntimeError(f"code-review: {error}\n作成済みのタブと worktree は残しています: {checkout}") from error
    print(f"PR #{number}: {checkout}\n再レビューと片付けは手動で行ってください。")


if __name__ == "__main__":
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        print(str(error), file=sys.stderr)
        if sys.stdin.isatty():
            try:
                input("Enter で閉じます。")
            except EOFError:
                pass
        sys.exit(1)
