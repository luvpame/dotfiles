# Herdr の Claude 使用量表示 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Herdr の Claude Agent 行に context、5 時間、7 日間の使用率を表示する。

**Architecture:** Claude Code の status line JSON を既存スクリプトで読み、Herdr 内に限って現在の pane へ custom metadata token を報告する。Herdr の Claude 専用行レイアウトが token を表示し、値がない場合は空文字で古い表示を消す。

**Tech Stack:** Python 3 標準ライブラリ、Herdr CLI、TOML

## Global Constraints

- 新しい依存関係を追加しない。
- Herdr が管理する integration hook を変更しない。
- Herdr 外で status line の出力や副作用を変えない。
- 既存の Nix 作業ツリー変更には触れない。

---

### Task 1: Claude 使用率の pane metadata 報告

**Files:**
- Create: `config/claude/test_statusline.py`
- Modify: `config/claude/statusline.py`
- Modify: `config/herdr/config.toml`

**Interfaces:**
- Consumes: status line JSON の `context_window.used_percentage`、`rate_limits.five_hour.used_percentage`、`rate_limits.seven_day.used_percentage`
- Produces: Herdr token `context`、`five_hour`、`seven_day`

- [ ] **Step 1: 失敗する回帰テストを書く**

`unittest` と一時ディレクトリ内の偽 `herdr` を使い、Herdr 内では `context=42%`、`five_hour=18%`、`seven_day=31%` が報告され、欠損値は空文字で報告され、Herdr 外では偽 CLI が呼ばれないことを検証する。

- [ ] **Step 2: テストが機能未実装を理由に失敗することを確認する**

Run: `python3 -m unittest config/claude/test_statusline.py -v`

Expected: metadata 報告が存在しないため FAIL

- [ ] **Step 3: 最小実装と行レイアウトを追加する**

`statusline.py` で既存 metrics からプレーンな百分率 token を作り、`HERDR_ENV=1` と `HERDR_PANE_ID` がある場合だけ、失敗を無視して次を実行する。

```python
subprocess.run(
    [
        "herdr",
        "pane",
        "report-metadata",
        os.environ["HERDR_PANE_ID"],
        "--source",
        "claude-statusline",
        "--token",
        f"context={tokens['context']}",
        "--token",
        f"five_hour={tokens['five_hour']}",
        "--token",
        f"seven_day={tokens['seven_day']}",
    ],
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
    check=False,
)
```

`config/herdr/config.toml` に Claude 専用の三行目を追加する。

```toml
[ui.sidebar.agents.rows_by_agent]
claude = [
  ["state_icon", "workspace", "tab"],
  ["agent"],
  ["$context", "$five_hour", "$seven_day"],
]
```

- [ ] **Step 4: テストと構文検証を実行する**

Run: `python3 -m unittest config/claude/test_statusline.py -v`

Expected: 全テスト PASS

Run: `python3 -m py_compile config/claude/statusline.py config/claude/test_statusline.py`

Expected: exit 0

- [ ] **Step 5: code-simplifier を適用し、リポジトリ検証を実行する**

変更箇所だけを簡素化した後、Step 4 を再実行し、`just check` を実行する。

- [ ] **Step 6: 機能変更だけをコミットする**

```bash
git add config/claude/statusline.py config/claude/test_statusline.py config/herdr/config.toml docs/superpowers/plans/2026-07-17-herdr-claude-usage.md
git commit -m "feat(herdr): Claude使用量をAgent行に表示"
```
