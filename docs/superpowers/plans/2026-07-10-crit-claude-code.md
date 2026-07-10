# Crit Claude Code Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Claude Code の計画とコード変更を Crit でレビューできるようにし、既存の `mo` plan hook を Crit の承認ループへ置き換える。

**Architecture:** Crit CLI は仕事用 Homebrew profile で宣言する。
Claude Code には公式 Marketplace plugin をユーザースコープで導入し、dotfiles では plugin の有効状態と既存 hook の削除だけを管理する。

**Tech Stack:** nix-darwin、Homebrew、Claude Code plugin、Crit CLI、JSON

## Global Constraints

- Crit を導入するエージェントは Claude Code だけとし、Codex の設定を変更しない。
- Crit CLI は Claude Code と同じ仕事用 profile に限定する。
- 公式 `crit@crit` plugin を使い、plugin や skills をリポジトリへ複製しない。
- `mo` の plan 表示 hook と cleanup hook は削除するが、`mo` 自体はアンインストールしない。
- `~/.crit.config.json`、Share、認証、セルフホスト、`agent_cmd` は設定しない。
- 未追跡の `nix/local.nix` は編集、stage、commit しない。

---

## File Structure

- Modify: `nix/nix-darwin/homebrew/work.nix`
  - 仕事用 profile に Crit CLI を宣言する。
- Modify: `config/claude/settings.json`
  - `mo` の plan 関連 hook を削除し、`crit@crit` plugin を有効にする。
- User state: `~/.claude/plugins/`
  - Claude Code が Marketplace checkout、plugin cache、インストール記録を管理する。

### Task 1: dotfiles に Crit の CLI と Claude Code plugin 設定を追加する

**Files:**

- Modify: `nix/nix-darwin/homebrew/work.nix:1-4`
- Modify: `config/claude/settings.json:29-66`
- Modify: `config/claude/settings.json:90-115`

**Interfaces:**

- Consumes: `homebrew/common.nix` が import する仕事用 profile attrset、Claude Code の `settings.json` schema
- Produces: Homebrew formula 名 `crit`、有効 plugin key `crit@crit`、Crit と競合しない hook 集合

- [ ] **Step 1: 変更前の設定検査が失敗することを確認する**

Run:

```sh
nix eval --impure --json --expr '(import ./nix/nix-darwin/homebrew/work.nix).brews' | jq -e 'index("crit") != null'
jq -e '
  ([.hooks.PreToolUse[]? | select(.matcher == "ExitPlanMode")] | length == 0)
  and (.hooks.SessionEnd == null)
  and (.enabledPlugins["crit@crit"] == true)
' config/claude/settings.json
```

Expected: どちらも exit code 1 で失敗する。

- [ ] **Step 2: Crit の宣言と plugin 設定を最小差分で追加する**

Apply this Nix change:

```diff
 {
   # 仕事用だけで入れたい Homebrew CLI はここに追加する。
-  brews = [ ];
+  brews = [ "crit" ];
```

Apply these JSON changes:

```diff
       {
         "matcher": ".*",
         "hooks": [
           {
             "type": "command",
             "command": "guard-and-guide"
           }
         ]
-      },
-      {
-        "matcher": "ExitPlanMode",
-        "hooks": [
-          {
-            "type": "command",
-            "command": "PLAN=$(ls -t ~/.claude/plans/*.md 2>/dev/null | head -1); [ -n \"$PLAN\" ] && /opt/homebrew/bin/mo \"$PLAN\" >/dev/null 2>&1 &",
-            "timeout": 15
-          }
-        ]
       },
       {
         "matcher": "Bash",
         "hooks": [
           {
             "type": "command",
             "command": "$HOME/.claude/hooks/rtk-rewrite.sh"
           }
         ]
       }
-    ],
-    "SessionEnd": [
-      {
-        "hooks": [
-          {
-            "type": "command",
-            "command": "mo --shutdown && echo 'Y' | mo --clear",
-            "async": true
-          }
-        ]
-      }
     ],
```

```diff
   "enabledPlugins": {
     "code-review@claude-plugins-official": true,
     "code-simplifier@claude-plugins-official": true,
+    "crit@crit": true,
     "feature-dev@claude-plugins-official": true,
```

- [ ] **Step 3: 変更した設定を整形する**

Run:

```sh
nixfmt nix/nix-darwin/homebrew/work.nix
jq empty config/claude/settings.json
```

Expected: どちらも出力なしで exit code 0 になる。

- [ ] **Step 4: `code-simplifier` skill で変更差分を確認する**

Review only these files and preserve the approved behavior:

```text
nix/nix-darwin/homebrew/work.nix
config/claude/settings.json
```

Expected: 追加の抽象化や別ファイルを作らず、この2ファイルの最小差分を維持する。

- [ ] **Step 5: 設定検査が成功することを確認する**

Run:

```sh
nix eval --impure --json --expr '(import ./nix/nix-darwin/homebrew/work.nix).brews' | jq -e 'index("crit") != null'
jq -e '
  ([.hooks.PreToolUse[]? | select(.matcher == "ExitPlanMode")] | length == 0)
  and (.hooks.SessionEnd == null)
  and (.enabledPlugins["crit@crit"] == true)
' config/claude/settings.json
```

Expected: どちらも `true` を出力し、exit code 0 になる。

- [ ] **Step 6: Nix 構成を検証する**

Run:

```sh
just check
```

Expected: `nix flake check` が exit code 0 で終了する。

- [ ] **Step 7: 実装差分だけをコミットする**

Run:

```sh
git add nix/nix-darwin/homebrew/work.nix config/claude/settings.json
git diff --staged --check
git commit -m "feat(claude): Critによる計画レビューを導入"
```

Expected: 2ファイルだけを含む Conventional Commit が作成される。

### Task 2: Crit CLI と Claude Code plugin をユーザー環境へ導入する

**Files:**

- Modify outside repository: `~/.claude/plugins/known_marketplaces.json`
- Modify outside repository: `~/.claude/plugins/installed_plugins.json`
- Create outside repository: `~/.claude/plugins/marketplaces/crit/`
- Create outside repository: `~/.claude/plugins/cache/crit/crit/`

**Interfaces:**

- Consumes: Homebrew formula `crit`、Marketplace repository `tomasz-tomczyk/crit`、有効 plugin key `crit@crit`
- Produces: `crit` executable、`/crit` skill、`crit-cli` skill、`PermissionRequest: ExitPlanMode` hook

- [ ] **Step 1: Crit CLI を現在のユーザー環境へ導入する**

Run:

```sh
brew install crit
crit --version
```

Expected: Homebrew が Crit をインストールし、`crit --version` がバージョンを表示して exit code 0 になる。

- [ ] **Step 2: 公式 Marketplace と plugin をユーザースコープで導入する**

Run:

```sh
claude plugin marketplace add tomasz-tomczyk/crit
claude plugin install crit@crit --scope user
```

Expected: Marketplace `crit` と plugin `crit@crit` のインストール成功メッセージが表示される。

- [ ] **Step 3: plugin が有効であることを確認する**

Run:

```sh
claude plugin list | rg -A4 'crit@crit'
```

Expected: `Scope: user` と `Status: ✔ enabled` が表示される。

- [ ] **Step 4: インストールされた plan hook を検査する**

Run:

```sh
install_path=$(jq -r '.plugins["crit@crit"][] | select(.scope == "user") | .installPath' ~/.claude/plugins/installed_plugins.json)
jq -e '
  .hooks.PermissionRequest[0].matcher == "ExitPlanMode"
  and .hooks.PermissionRequest[0].hooks[0].command == "crit plan-hook"
' "$install_path/hooks/hooks.json"
```

Expected: `true` を出力して exit code 0 になる。

- [ ] **Step 5: plugin installer が追跡ファイルへ追加変更を残していないことを確認する**

Run:

```sh
git status --short
```

Expected: 既存の未追跡 `nix/local.nix` だけが表示される。

- [ ] **Step 6: Plan mode のレビューを手動確認する**

Run:

```sh
claude --permission-mode plan "README.md を変更せず、空行を1行追加するだけの計画を作り、ExitPlanMode を要求してください"
```

Expected: Crit がブラウザで計画を開き、コメントがある間は Plan mode を継続し、コメントなしで承認すると Plan mode を終了する。
