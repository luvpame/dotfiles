# Crit Claude Code Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crit CLI を Home Manager で配布し、Claude Code は wrapper を使わず標準の Marketplace plugin フローで Crit を有効にする。

**Architecture:** Crit の公式 flake input から CLI を仕事用 Home Manager package に追加する。
Claude Code は通常の `pkgs.claude-code` を使い、`extraKnownMarketplaces` と `enabledPlugins` から Marketplace と plugin の信頼確認を標準フローへ委ねる。

**Tech Stack:** Nix flakes、nix-darwin、Home Manager、Claude Code Marketplace、Crit CLI、JSON

## Global Constraints

- Crit を導入するエージェントは Claude Code だけとし、Codex の設定を変更しない。
- Crit CLI と Claude Code は仕事用 Home Manager profile に限定する。
- Claude Code wrapper と `--plugin-dir` を使わない。
- `brew install`、`claude plugin marketplace add`、`claude plugin install`、`just switch` を実行しない。
- Claude Code が表示する Marketplace と plugin の信頼確認を迂回しない。
- `mo` の plan 表示 hook と cleanup hook は削除するが、`mo` 自体はアンインストールしない。
- `~/.crit.config.json`、Share、認証、セルフホスト、`agent_cmd` は設定しない。
- 未追跡の `nix/local.nix` は編集、stage、commit しない。

---

## File Structure

- Modify: `docs/superpowers/specs/2026-07-10-crit-claude-code-design.md`
  - 通常の Claude Code plugin 導入フローを設計の正とする。
- Modify: `docs/superpowers/plans/2026-07-10-crit-claude-code.md`
  - wrapper を削除する実装手順へ更新する。
- Modify: `nix/nix-darwin/home-manager/packages/work.nix`
  - Crit CLI と通常の Claude Code を仕事用 package にする。
- Modify: `config/claude/settings.json`
  - Crit Marketplace source と plugin の有効状態を宣言する。

### Task 1: 設計書と計画を標準 plugin フローへ修正する

**Files:**

- Modify: `docs/superpowers/specs/2026-07-10-crit-claude-code-design.md`
- Modify: `docs/superpowers/plans/2026-07-10-crit-claude-code.md`

**Interfaces:**

- Consumes: ユーザー指定の「Claude wrapper は使わず、通常どおりのフローにする」制約
- Produces: Home Manager の Crit CLI と Claude Marketplace 標準フローを正とする設計と手順

- [ ] **Step 1: wrapper と `--plugin-dir` を実装対象から外す**

Expected: 文書が通常の `pkgs.claude-code`、`extraKnownMarketplaces`、`enabledPlugins` を実装方式として示す。

- [ ] **Step 2: 文書を自己レビューする**

Run:

```sh
rg -n 'TBD|TODO|FIXME|writeShellScriptBin|--plugin-dir' \
  docs/superpowers/specs/2026-07-10-crit-claude-code-design.md \
  docs/superpowers/plans/2026-07-10-crit-claude-code.md
```

Expected: wrapper を禁止する制約と削除検査以外に実装指示がなく、プレースホルダーがない。

- [ ] **Step 3: 文書修正だけをコミットする**

Run:

```sh
git add docs/superpowers/specs/2026-07-10-crit-claude-code-design.md docs/superpowers/plans/2026-07-10-crit-claude-code.md
git diff --staged --check
git commit -m "docs(crit): 標準plugin導入フローへ修正"
```

Expected: 2文書だけを含む Conventional Commit が作成される。

### Task 2: Claude wrapper を通常 package と Marketplace 設定へ置き換える

**Files:**

- Modify: `nix/nix-darwin/home-manager/packages/work.nix:1-20`
- Modify: `config/claude/settings.json:75-115`

**Interfaces:**

- Consumes: `inputs.crit.packages.${system}.default`、`pkgs.claude-code`、Crit の Marketplace repository
- Produces: PATH 上の `crit` と通常の `claude`、Claude Code が信頼確認できる Marketplace 宣言

- [ ] **Step 1: 変更前の宣言検査が失敗することを確認する**

Run:

```sh
! rg -q 'writeShellScriptBin "claude"' nix/nix-darwin/home-manager/packages/work.nix
rg -q '^  pkgs\.claude-code$' nix/nix-darwin/home-manager/packages/work.nix
jq -e '.extraKnownMarketplaces.crit.source.repo == "tomasz-tomczyk/crit"' config/claude/settings.json
jq -e '.enabledPlugins["crit@crit"] == true' config/claude/settings.json
```

Expected: 四つとも exit code 1 で失敗する。

- [ ] **Step 2: wrapper を通常の Claude Code package へ置き換える**

Replace `nix/nix-darwin/home-manager/packages/work.nix` with:

```nix
{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
[
  pkgs.awscli2
  inputs.crit.packages.${system}.default
  pkgs.claude-code
]
```

- [ ] **Step 3: Crit Marketplace と plugin の有効状態を宣言する**

Add to `enabledPlugins`:

```json
"crit@crit": true
```

Add beside `enabledPlugins`:

```json
"extraKnownMarketplaces": {
  "crit": {
    "source": {
      "source": "github",
      "repo": "tomasz-tomczyk/crit"
    }
  }
}
```

- [ ] **Step 4: Nix と JSON を整形する**

Run:

```sh
nixfmt nix/nix-darwin/home-manager/packages/work.nix
jq empty config/claude/settings.json
```

Expected: どちらも exit code 0 になる。

- [ ] **Step 5: `code-simplifier` skill で変更差分を確認する**

Review only these files and preserve the approved behavior:

```text
nix/nix-darwin/home-manager/packages/work.nix
config/claude/settings.json
```

Expected: wrapper、生成スクリプト、別ファイルを追加しない。

- [ ] **Step 6: 宣言検査が成功することを確認する**

Run:

```sh
! rg -q 'writeShellScriptBin "claude"' nix/nix-darwin/home-manager/packages/work.nix
rg -q '^  pkgs\.claude-code$' nix/nix-darwin/home-manager/packages/work.nix
jq -e '.extraKnownMarketplaces.crit.source.repo == "tomasz-tomczyk/crit"' config/claude/settings.json
jq -e '.enabledPlugins["crit@crit"] == true' config/claude/settings.json
```

Expected: 四つとも exit code 0 になる。

- [ ] **Step 7: Home Manager package list を評価する**

Run:

```sh
nix eval --impure --json --expr '
  let
    flake = builtins.getFlake (toString ./nix);
    pkgs = import flake.inputs.nixpkgs {
      system = "aarch64-darwin";
      overlays = [ flake.inputs.claude-code-overlay.overlays.default ];
    };
    packages = import ./nix/nix-darwin/home-manager/packages/work.nix {
      inputs = flake.inputs;
      inherit pkgs;
    };
  in map (package: package.name) packages
'
```

Expected: `awscli2`、`crit-0.17.1`、`claude-2.1.205` を含み、`writeShellScriptBin` 由来の wrapper を含まない。

- [ ] **Step 8: flake 全体を検証する**

Run:

```sh
just check
```

Expected: `nix flake check` が exit code 0 で終了する。

- [ ] **Step 9: 実装差分だけをコミットする**

Run:

```sh
git add nix/nix-darwin/home-manager/packages/work.nix config/claude/settings.json
git diff --staged --check
git commit -m "fix(claude): 標準plugin導入フローを使う"
```

Expected: 2ファイルだけを含む Conventional Commit が作成される。

### Task 3: Home Manager 反映後の確認手順を引き渡す

**Files:** None

**Interfaces:**

- Consumes: Home Manager で反映された Crit CLI、通常の Claude Code、Marketplace 宣言
- Produces: 利用者が信頼を承認した Crit plugin

- [ ] **Step 1: 反映コマンドを案内する**

Run by the user:

```sh
just switch
```

Expected: Home Manager generation に Crit CLI と通常の Claude Code が反映される。

- [ ] **Step 2: Claude Code の標準フローを案内する**

Run by the user after `just switch`:

```sh
claude
```

Expected: Claude Code が Crit Marketplace と plugin の信頼確認を表示し、利用者が承認すると `crit@crit` を導入する。

- [ ] **Step 3: Plan mode のレビュー確認を案内する**

Run by the user after plugin approval:

```sh
claude --permission-mode plan "README.md を変更せず、空行を1行追加するだけの計画を作り、ExitPlanMode を要求してください"
```

Expected: Crit がブラウザで計画を開き、コメントなしで承認すると Plan mode を終了する。
