# Crit Claude Code Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Claude Code の計画とコード変更を Crit でレビューできるようにし、Crit CLI と plugin を Nix と Home Manager だけで配布する。

**Architecture:** Crit の公式 flake を input に追加し、仕事用 Home Manager package へ Crit CLI を含める。
Claude Code は Nix の wrapper から `--plugin-dir` 付きで起動し、同じ flake input 内の公式 plugin を Marketplace install なしで読み込む。

**Tech Stack:** Nix flakes、nix-darwin、Home Manager、Claude Code plugin、Crit CLI、JSON

## Global Constraints

- Crit を導入するエージェントは Claude Code だけとし、Codex の設定を変更しない。
- Crit CLI と Claude Code plugin は仕事用 Home Manager profile に限定する。
- `brew install`、`claude plugin marketplace add`、`claude plugin install`、`just switch` を実行しない。
- 公式 Crit plugin を Nix store から読み込み、plugin や skills をリポジトリへ複製しない。
- `mo` の plan 表示 hook と cleanup hook は削除するが、`mo` 自体はアンインストールしない。
- `~/.crit.config.json`、Share、認証、セルフホスト、`agent_cmd` は設定しない。
- 未追跡の `nix/local.nix` は編集、stage、commit しない。

---

## File Structure

- Modify: `nix/flake.nix`
  - Crit の公式 flake input を宣言する。
- Modify: `nix/flake.lock`
  - Crit の revision と依存関係を固定する。
- Modify: `nix/nix-darwin/home-manager/packages/work.nix`
  - Crit CLI と Crit plugin 付き Claude Code wrapper を仕事用 package にする。
- Modify: `nix/nix-darwin/homebrew/work.nix`
  - Homebrew formula `crit` を削除する。
- Modify: `config/claude/settings.json`
  - Marketplace install を前提とする `crit@crit` entry を削除する。

### Task 1: 設計書と計画を Nix Home Manager 方式へ修正する

**Files:**

- Modify: `docs/superpowers/specs/2026-07-10-crit-claude-code-design.md`
- Modify: `docs/superpowers/plans/2026-07-10-crit-claude-code.md`

**Interfaces:**

- Consumes: ユーザー指定の「直接インストールを実行せず、Nix の Home Manager で入れる」制約
- Produces: flake input、Home Manager package、`--plugin-dir` wrapper を正とする設計と手順

- [ ] **Step 1: Homebrew と Marketplace install の実行手順を削除する**

Expected: 文書が直接インストールを要求せず、Nix と Home Manager だけを実装方式として示す。

- [ ] **Step 2: 文書を自己レビューする**

Run:

```sh
rg -n 'TBD|TODO|FIXME|brew install crit|claude plugin (marketplace add|install)' \
  docs/superpowers/specs/2026-07-10-crit-claude-code-design.md \
  docs/superpowers/plans/2026-07-10-crit-claude-code.md
```

Expected: `Global Constraints` の禁止事項以外に直接インストール手順がなく、プレースホルダーがない。

- [ ] **Step 3: 文書修正だけをコミットする**

Run:

```sh
git add docs/superpowers/specs/2026-07-10-crit-claude-code-design.md docs/superpowers/plans/2026-07-10-crit-claude-code.md
git diff --staged --check
git commit -m "docs(crit): Home Manager導入方式へ修正"
```

Expected: 2文書だけを含む Conventional Commit が作成される。

### Task 2: Crit flake と Claude Code wrapper を Home Manager へ追加する

**Files:**

- Modify: `nix/flake.nix:4-24`
- Modify: `nix/flake.lock`
- Modify: `nix/nix-darwin/home-manager/packages/work.nix:1-14`
- Modify: `nix/nix-darwin/homebrew/work.nix:1-4`
- Modify: `config/claude/settings.json:75-90`

**Interfaces:**

- Consumes: `inputs.crit.packages.${system}.default`、`inputs.crit/integrations/claude-code`、`pkgs.claude-code`
- Produces: PATH 上の `crit`、`--plugin-dir` を常に渡す PATH 上の `claude`

- [ ] **Step 1: 変更前の宣言検査が失敗することを確認する**

Run:

```sh
rg -q 'crit = \{' nix/flake.nix
rg -q 'writeShellScriptBin "claude"' nix/nix-darwin/home-manager/packages/work.nix
! rg -q '"crit"' nix/nix-darwin/homebrew/work.nix
jq -e '.enabledPlugins["crit@crit"] == null' config/claude/settings.json
```

Expected: 四つとも exit code 1 で失敗する。

- [ ] **Step 2: Crit flake input を追加する**

Apply:

```diff
     claude-code-overlay = {
       url = "github:ryoppippi/claude-code-overlay";
       inputs.nixpkgs.follows = "nixpkgs";
     };
+    crit = {
+      url = "github:tomasz-tomczyk/crit";
+      inputs.nixpkgs.follows = "nixpkgs";
+    };
```

- [ ] **Step 3: 仕事用 Home Manager package を置き換える**

Replace `nix/nix-darwin/home-manager/packages/work.nix` with:

```nix
{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  claudeCodeWithCrit = pkgs.writeShellScriptBin "claude" ''
    exec ${pkgs.claude-code}/bin/claude \
      --plugin-dir ${inputs.crit}/integrations/claude-code \
      "$@"
  '';
in
[
  pkgs.awscli2
  inputs.crit.packages.${system}.default
  claudeCodeWithCrit
]
```

- [ ] **Step 4: Homebrew と Marketplace 前提の設定を削除する**

Apply:

```diff
 {
   # 仕事用だけで入れたい Homebrew CLI はここに追加する。
-  brews = [ "crit" ];
+  brews = [ ];
```

```diff
   "enabledPlugins": {
     "code-review@claude-plugins-official": true,
     "code-simplifier@claude-plugins-official": true,
-    "crit@crit": true,
     "feature-dev@claude-plugins-official": true,
```

- [ ] **Step 5: Crit input を lock file へ追加する**

Run:

```sh
cd nix
nix flake update crit
```

Expected: `flake.lock` に `crit` node が追加され、既存 input の revision は変わらない。

- [ ] **Step 6: Nix と JSON を整形する**

Run:

```sh
nixfmt nix/flake.nix nix/nix-darwin/home-manager/packages/work.nix nix/nix-darwin/homebrew/work.nix
jq empty config/claude/settings.json
```

Expected: すべて exit code 0 になる。

- [ ] **Step 7: `code-simplifier` skill で変更差分を確認する**

Review only these files and preserve the approved behavior:

```text
nix/flake.nix
nix/flake.lock
nix/nix-darwin/home-manager/packages/work.nix
nix/nix-darwin/homebrew/work.nix
config/claude/settings.json
```

Expected: wrapper 以外の抽象化や別ファイルを追加しない。

- [ ] **Step 8: 宣言検査が成功することを確認する**

Run:

```sh
rg -q 'crit = \{' nix/flake.nix
rg -q 'writeShellScriptBin "claude"' nix/nix-darwin/home-manager/packages/work.nix
! rg -q '"crit"' nix/nix-darwin/homebrew/work.nix
jq -e '.enabledPlugins["crit@crit"] == null' config/claude/settings.json
```

Expected: 四つとも exit code 0 になる。

- [ ] **Step 9: Crit plugin の manifest と plan hook を検査する**

Run:

```sh
crit_source=$(nix eval --impure --raw --expr '(builtins.getFlake (toString ./nix)).inputs.crit.outPath')
jq -e '.name == "crit"' "$crit_source/integrations/claude-code/.claude-plugin/plugin.json"
jq -e '
  .hooks.PermissionRequest[0].matcher == "ExitPlanMode"
  and .hooks.PermissionRequest[0].hooks[0].command == "crit plan-hook"
' "$crit_source/integrations/claude-code/hooks/hooks.json"
```

Expected: 二つの `jq` が `true` を出力する。

- [ ] **Step 10: flake 全体を検証する**

Run:

```sh
just check
```

Expected: `nix flake check` が exit code 0 で終了する。

- [ ] **Step 11: 実装差分だけをコミットする**

Run:

```sh
git add nix/flake.nix nix/flake.lock \
  nix/nix-darwin/home-manager/packages/work.nix \
  nix/nix-darwin/homebrew/work.nix \
  config/claude/settings.json
git diff --staged --check
git commit -m "fix(claude): CritをHome Managerで導入"
```

Expected: 5ファイルだけを含む Conventional Commit が作成される。

### Task 3: Home Manager 反映後の確認手順を引き渡す

**Files:** None

**Interfaces:**

- Consumes: Home Manager で反映された `crit` と `claude` wrapper
- Produces: Crit plan review が有効な Claude Code session

- [ ] **Step 1: 反映コマンドを案内する**

Run by the user:

```sh
just switch
```

Expected: Home Manager generation に Crit CLI と Claude Code wrapper が反映される。

- [ ] **Step 2: Plan mode のレビュー確認を案内する**

Run by the user after `just switch`:

```sh
claude --permission-mode plan "README.md を変更せず、空行を1行追加するだけの計画を作り、ExitPlanMode を要求してください"
```

Expected: Crit がブラウザで計画を開き、コメントなしで承認すると Plan mode を終了する。
