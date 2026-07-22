# Herdr Agent メタデータ表示 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Herdr サイドバーに Claude と Codex の model、effort、および Codex の fast mode を表示する。

**Architecture:** Claude の既存 status line 入力と Codex の既存 rollout JSONL parser を拡張し、Herdr の custom metadata token として報告する。既存の context 表示は残し、5時間、7日間の token を置き換える。

**Tech Stack:** Python 3 標準ライブラリ、`unittest`、Herdr CLI、TOML

## Global Constraints

- 新しい依存関係を追加しない。
- context 使用率は残す。
- fast mode は Codex だけに表示する。
- 欠損値と無効な fast mode は空文字にする。
- ユーザー所有の `config/herdr/.plugins.lock` と `nix/local.nix` には触れない。

---

### Task 1: Agent メタデータの報告と表示

**Files:**
- Modify: `config/claude/test_statusline.py`
- Modify: `config/claude/statusline.py`
- Modify: `config/codex/hooks/test_herdr-usage.py`
- Modify: `config/codex/hooks/herdr-usage.py`
- Modify: `config/herdr/config.toml`

**Interfaces:**
- Consumes: Claude status line JSON の `model.display_name` と `effort.level`
- Consumes: Codex rollout JSONL の `turn_context.payload.model`、`turn_context.payload.effort`、`thread_settings_applied.payload.thread_settings.service_tier`
- Produces: Herdr metadata token `model`、`effort`、Codex 専用 `fast_mode`

- [ ] **Step 1: 失敗するテストへ期待値を変更する**

Claude の入力へ `model.display_name = "Opus 4.7"` と `effort.level = "xhigh"` を追加し、報告値に `model=󰚩 Opus 4.7`、`effort=󰓅 xhigh` を期待する。欠損テストでは両 token の空文字を期待する。

Codex の rollout へ次を追加する。

```json
{"type":"turn_context","payload":{"model":"gpt-5.6-sol","effort":"low"}}
{"type":"event_msg","payload":{"type":"thread_settings_applied","thread_settings":{"service_tier":"priority"}}}
```

報告値に `model=󰚩 gpt-5.6-sol`、`effort=󰓅 low`、`fast_mode=󱐋 fast` を期待する。`service_tier = "default"` では `fast_mode=` を期待する。

- [ ] **Step 2: テストが期待どおり失敗することを確認する**

Run:

```bash
python3 -m unittest config/claude/test_statusline.py config/codex/hooks/test_herdr-usage.py -v
```

Expected: 新しい metadata token が未実装のため FAIL

- [ ] **Step 3: 最小実装を追加する**

Claude の `tokens` に次を加える。

```python
tokens.update(
    {
        "model": f"󰚩 {model}" if model else "",
        "effort": f"󰓅 {data.get('effort', {}).get('level')}"
        if data.get("effort", {}).get("level")
        else "",
    }
)
```

Codex は `tail` の結果を一度だけ走査して、usage に加えて最新の turn context と thread settings を返す。metadata 値を次の形で報告する。

```python
"model": f"󰚩 {model}" if model else "",
"effort": f"󰓅 {effort}" if effort else "",
"fast_mode": "󱐋 fast" if service_tier in {"fast", "priority"} else "",
```

Herdr の Claude 行を `$context`, `$model`, `$effort`、Codex 行を `$context`, `$model`, `$effort`, `$fast_mode` に変更する。

- [ ] **Step 4: 対象テストと構文検証を通す**

Run:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest config/claude/test_statusline.py config/codex/hooks/test_herdr-usage.py -v
python3 -m py_compile config/claude/statusline.py config/codex/hooks/herdr-usage.py
```

Expected: 全テスト PASS、構文検証 exit 0

- [ ] **Step 5: code-simplifier を適用して再検証する**

変更したコードだけを簡素化し、Step 4 と `just check`、`git diff --check` を再実行する。

- [ ] **Step 6: Hunk セッションを更新する**

Run:

```bash
hunk session reload --repo . -- diff
hunk session review --repo . --json
```

Expected: 変更対象だけが Hunk のレビューに表示される。
