# Hunk Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (\`- [ ]\`) syntax for tracking.

**Goal:** Git、Lazygit、Neovim の delta 利用を hunk に置き換え、git-delta の依存を削除する。

**Architecture:** Homebrew で hunk を導入し、各クライアントから公式の \`hunk pager\` を直接呼び出す。delta 固有設定は削除し、hunk がない Neovim 環境では既存の標準表示へ戻す。

**Tech Stack:** Nix、Homebrew、Git config、Lazygit YAML、Lua、Neovim、hunk

## Global Constraints

- Git、Lazygit、Neovim のすべての delta 利用箇所を移行する。
- delta 専用のオプションと実行可能判定を残さない。
- hunk がない Neovim 環境では各プラグインの標準表示へ戻す。
- 既存の無関係な作業ツリー変更を編集またはコミットしない。

---

### Task 1: パッケージと Git クライアント設定の移行

**Files:**
- Modify: \`nix/nix-darwin/homebrew/common.nix:28-35\`
- Modify: \`config/git/config:26-38\`
- Modify: \`config/lazygit/config.yml:39-40\`

**Interfaces:**
- Consumes: Homebrew の公式 \`hunk\` formula と \`hunk pager\`
- Produces: Git と Lazygit が参照する \`hunk pager\`

- [ ] **Step 1: 置換前の参照を確認する**

Run: \`rg -n 'git-delta|pager.*delta|diff.*delta|diffFilter.*delta|\[delta\]' nix/nix-darwin/homebrew/common.nix config/git/config config/lazygit/config.yml\`

Expected: パッケージ、Git 設定、Lazygit ページャーの delta 参照が表示される。

- [ ] **Step 2: パッケージとページャーを置換する**

\`common.nix\` の \`"git-delta"\` を \`"hunk"\` に変更する。
\`config/git/config\` は次の形にし、\`[interactive]\` と \`[delta]\` を削除する。

\`\`\`gitconfig
[core]
  editor = nvim
  pager  = hunk pager
\`\`\`

\`config/lazygit/config.yml\` のページャーを次へ変更する。

\`\`\`yaml
  pagers:
    - pager: hunk pager
\`\`\`

- [ ] **Step 3: 設定を検証する**

\`\`\`bash
nixfmt nix/nix-darwin/homebrew/common.nix
git config --file config/git/config --get core.pager
ruby -e 'require "yaml"; YAML.load_file("config/lazygit/config.yml")'
\`\`\`

Expected: Git が \`hunk pager\` を出力し、全コマンドが終了コード 0 になる。

### Task 2: Neovim 差分プレビューの移行

**Files:**
- Modify: \`config/nvim/lua/plugins/telescope.nvim.lua:1-42\`
- Modify: \`config/nvim/lua/plugins/pr.nvim.lua:1-122\`

**Interfaces:**
- Consumes: 標準入力から unified diff を受け取る \`hunk pager\`
- Produces: Telescope の端末プレビューで動く hunk コマンド

- [ ] **Step 1: delta 固有ロジックを確認する**

Run: \`rg -n 'delta_command|git_status_delta_previewer|executable\("delta"\)|Git Delta Preview' config/nvim/lua/plugins/telescope.nvim.lua config/nvim/lua/plugins/pr.nvim.lua\`

Expected: コマンド組み立て、実行可能判定、プレビュー名が表示される。

- [ ] **Step 2: Telescope のプレビューを hunk に置換する**

\`delta_command\` を削除し、関数名とタイトルを \`git_status_hunk_previewer\`、\`Git Hunk Preview\` に変更する。
実行可能判定とパイプは次の形にする。

\`\`\`lua
if vim.fn.executable("hunk") == 1 then
  return { "sh", "-c", diff_command .. " | hunk pager || true" }
end
\`\`\`

\`git_file_diff.new\` には \`git_status_hunk_previewer\` を設定する。

- [ ] **Step 3: PR プレビューを hunk に置換する**

\`delta_command\` を削除し、実行可能判定と戻り値を次へ変更する。

\`\`\`lua
if vim.fn.executable("hunk") == 1 then
  return { "sh", "-c", ("hunk pager < %s"):format(vim.fn.shellescape(diff_file)) }
end
\`\`\`

hunk がない場合の \`{ "cat", diff_file }\` は維持する。

- [ ] **Step 4: Lua を整形して読み込みを検証する**

\`\`\`bash
stylua config/nvim/lua/plugins/telescope.nvim.lua config/nvim/lua/plugins/pr.nvim.lua
nvim --headless -u NONE "+luafile config/nvim/lua/plugins/telescope.nvim.lua" "+luafile config/nvim/lua/plugins/pr.nvim.lua" +qa
\`\`\`

Expected: 両コマンドが終了コード 0 になる。

### Task 3: リポジトリ全体の検証

**Files:**
- Verify: \`nix/nix-darwin/homebrew/common.nix\`
- Verify: \`config/git/config\`
- Verify: \`config/lazygit/config.yml\`
- Verify: \`config/nvim/lua/plugins/telescope.nvim.lua\`
- Verify: \`config/nvim/lua/plugins/pr.nvim.lua\`

**Interfaces:**
- Consumes: Task 1 と Task 2 の変更
- Produces: delta 参照がなく、Nix 評価を通過する設定

- [ ] **Step 1: delta 参照が消えたことを確認する**

Run: \`rg -n --hidden --glob '!.git/**' 'git-delta|\bdelta\b' nix config/git config/lazygit config/nvim\`

Expected: 対象設定から delta 参照が 0 件になる。

- [ ] **Step 2: 差分の品質を確認する**

\`\`\`bash
git diff --check -- nix/nix-darwin/homebrew/common.nix config/git/config config/lazygit/config.yml config/nvim/lua/plugins/telescope.nvim.lua config/nvim/lua/plugins/pr.nvim.lua
git diff -- nix/nix-darwin/homebrew/common.nix config/git/config config/lazygit/config.yml config/nvim/lua/plugins/telescope.nvim.lua config/nvim/lua/plugins/pr.nvim.lua
\`\`\`

Expected: \`git diff --check\` が終了コード 0 になり、差分が hunk への置換だけを含む。

- [ ] **Step 3: Flake を検証する**

Run: \`just check\`

Expected: \`nix flake check\` が終了コード 0 になる。

- [ ] **Step 4: 実装をコミットする**

\`\`\`bash
git add nix/nix-darwin/homebrew/common.nix config/git/config config/lazygit/config.yml config/nvim/lua/plugins/telescope.nvim.lua config/nvim/lua/plugins/pr.nvim.lua
git commit -m "feat(git): delta を hunk に置き換える"
\`\`\`
