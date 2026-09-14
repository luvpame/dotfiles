#!/usr/bin/env python3
"""Start a PR review only after an explicit selection in Herdr."""

import json
import os
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
         "--header=選択すると worktree を準備して両方のレビューを起動します"],
        input=rows, text=True, stdout=subprocess.PIPE,
    )
    if selection.returncode in (1, 130):
        return
    selection.check_returncode()
    number = selection.stdout.split("\t", 1)[0]
    if number not in {str(pr["number"]) for pr in prs}:
        raise RuntimeError("選択された PR が一覧にありません。")
    pr = json.loads(run(
        "gh", "pr", "view", number, "--json", "headRefName,headRefOid,baseRefOid", cwd=root,
    ))
    paths = [item["path"] for item in source["worktrees"] if item.get("branch") == pr["headRefName"]]
    if len(paths) > 1:
        raise RuntimeError("同じブランチの worktree が複数あります。対象を確認してください。")
    if paths:
        checkout = paths[0]
    else:
        run("git", "-C", root, "fetch", "--all")
        checkout = json.loads(run(
            "direnv", "exec", root, "wt", "-C", root, "switch", "--no-cd",
            "--no-hooks", f"pr:{number}", "--format=json",
        ))["path"]
    if (run("git", "-C", checkout, "rev-parse", "HEAD") != pr["headRefOid"]
            or run("git", "-C", checkout, "branch", "--show-current") != pr["headRefName"]
            or run("git", "-C", checkout, "status", "--porcelain")):
        raise RuntimeError(f"PR の HEAD と一致する変更のない worktree が必要です。手動で確認してください: {checkout}")
    opened = herdr("worktree", "open", "--cwd", root, "--path", checkout, "--focus", "--json")
    review_workspace = opened["workspace"]["workspace_id"]
    tabs = herdr("tab", "list", "--workspace", review_workspace)["tabs"]
    tab = tabs[0]
    panes = [p for p in herdr("pane", "list", "--workspace", review_workspace)["panes"]
             if p["tab_id"] == tab["tab_id"]]
    if len(panes) != 1:
        print("既存の pane 構成を残しました。再レビューは各 pane から指示してください。")
        return
    left = panes[0]["pane_id"]
    if opened.get("already_open"):
        info = herdr("pane", "process-info", "--pane", left)["process_info"]
        processes = info.get("foreground_processes") or []
        if not processes or any(p.get("pid") != info.get("shell_pid") for p in processes):
            print("使用中の pane を残しました。再レビューはその pane から指示してください。")
            return
    right = herdr("pane", "split", left, "--direction", "right", "--cwd", checkout,
                  "--no-focus")["pane"]["pane_id"]
    prompts = {
        "code review": (
            "opus",
            f"code-review:code-review スキルを使い PR #{number} を敵対的に検証してください。"
            f'差分の基準は {pr["baseRefOid"]}...{pr["headRefOid"]}。'
            "読み取り専用で実施し、結果をこのセッションに返してください。外部サービスへ投稿しないでください。",
        ),
        "pr-review-assist": ("sonnet", f"pr-review-assist スキルを PR #{number} に対して実行してください。"),
    }
    failures = []
    for pane, (label, (model, prompt)) in zip((left, right), prompts.items()):
        try:
            # Shell initialization may still be running immediately after pane creation.
            for attempt in range(30):
                info = herdr("pane", "process-info", "--pane", pane)["process_info"]
                processes = info.get("foreground_processes") or []
                if not processes or processes[0].get("pid") == info.get("shell_pid"):
                    break
                time.sleep(1)
            else:
                raise RuntimeError(f"シェルの準備が完了しません: {pane}")
            name = "review-" + pane.replace(":", "-")
            herdr("agent", "start", name, "--kind", "claude", "--pane", pane,
                  "--", "--model", model, prompt)
        except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
            failures.append(f"{label}: {error}")
    if failures:
        raise RuntimeError("\n".join(failures) + f"\n作成済みのタブと worktree は残しています: {checkout}")
    print(f"PR #{number}: {checkout}\n再レビューと片付けは手動で行ってください。")


if __name__ == "__main__":
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError, KeyError, ValueError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
