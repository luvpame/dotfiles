# Herdr diff pane Toggle Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `prefix+d` で現在のタブにある Hunk 差分 pane を開閉できるようにする。

**Architecture:** `config/herdr/config.toml` の既存シェルコマンドだけを変更する。`herdr pane list` の JSON から現在のタブにある対象 pane を抽出し、対象があればすべて閉じ、なければ既存処理で作成する。

**Tech Stack:** Herdr CLI、POSIX shell、jq、TOML

## Global Constraints

- 対象は `HERDR_ACTIVE_PANE_ID` から特定したタブ内の pane に限定する。
- `label` が `diff view`、または `terminal_title` に `hunk diff` を含む pane を閉じる。
- 新しい依存関係、スクリプト、テストファイルは追加しない。

---

### Task 1: `prefix+d` のトグル化

**Files:**
- Modify: `config/herdr/config.toml:21`
- Test: コマンドラインによる設定内容と JSON 抽出条件の確認

**Interfaces:**
- Consumes: `HERDR_ACTIVE_PANE_ID`、`herdr pane list` の JSON
- Produces: `prefix+d` の開閉トグル動作

- [ ] **Step 1: 変更前の設定にトグル条件がないことを確認する**

Run:

```bash
rg -F '.result.panes as $panes' config/herdr/config.toml
```

Expected: exit 1。現在の設定は対象 pane を調べず、常に新規 pane を作成する。

- [ ] **Step 2: 最小のトグル処理を実装する**

`prefix+d` の `command` を次の一行へ置換する。

```toml
command = "pane_ids=$(herdr pane list | jq -r --arg pane_id \"$HERDR_ACTIVE_PANE_ID\" '.result.panes as $panes | ($panes[] | select(.pane_id == $pane_id).tab_id) as $tab_id | $panes[] | select(.tab_id == $tab_id and (.label == \"diff view\" or (.terminal_title // \"\" | contains(\"hunk diff\")))) | .pane_id'); if [ -n \"$pane_ids\" ]; then for pane_id in $pane_ids; do herdr pane close \"$pane_id\"; done; else pane_id=$(herdr pane split \"$HERDR_ACTIVE_PANE_ID\" --direction right --focus --ratio 0.66 | jq -r '.result.pane.pane_id') && herdr pane rename \"$pane_id\" \"diff view\" && herdr pane run \"$pane_id\" 'hunk diff'; fi"
```

- [ ] **Step 3: 設定にトグル条件が入ったことを確認する**

Run:

```bash
rg -F '.result.panes as $panes' config/herdr/config.toml
```

Expected: exit 0。変更した `command` の一行が表示される。

- [ ] **Step 4: JSON 抽出条件を fixture で確認する**

Run:

```bash
printf '%s\n' '{"result":{"panes":[{"pane_id":"current","tab_id":"active"},{"pane_id":"label-match","tab_id":"active","label":"diff view"},{"pane_id":"title-match","tab_id":"active","terminal_title":"repo: hunk diff - hunk"},{"pane_id":"other-tab","tab_id":"other","label":"diff view"},{"pane_id":"unrelated","tab_id":"active","terminal_title":"fish"}]}}' | jq -r --arg pane_id current '.result.panes as $panes | ($panes[] | select(.pane_id == $pane_id).tab_id) as $tab_id | $panes[] | select(.tab_id == $tab_id and (.label == "diff view" or (.terminal_title // "" | contains("hunk diff")))) | .pane_id'
```

Expected:

```text
label-match
title-match
```

- [ ] **Step 5: リポジトリ検証を実行する**

Run:

```bash
just check
```

Expected: exit 0。

- [ ] **Step 6: 変更をコミットする**

```bash
git add config/herdr/config.toml docs/superpowers/plans/2026-07-16-herdr-diff-pane-toggle.md
git commit -m "feat(herdr): diff paneをトグル可能にする"
```
