# dotfiles クリーンアップ実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 2026-07-03 の網羅調査で見つかった問題（生成物の追跡、壊れた submodule 参照、二重管理、環境依存パス）を解消し、clone しただけで再現する dotfiles にする。

**Architecture:** 本リポジトリは nix-darwin + Home Manager 構成で、`mkOutOfStoreSymlink` により `~/.config` 等がリポジトリ実体を直接指す。
このためツールのランタイム生成物がリポジトリに流れ込む。
本計画は「マニフェスト（`fish_plugins`、`@plugin` 宣言、`package.toml`）だけを追跡し、生成物は gitignore する」方針で統一する。

**Tech Stack:** Nix flakes / nix-darwin / Home Manager / fish / tmux / just

## Global Constraints

- コミットメッセージは Conventional Commits（スコープ付き、命令形）。例: `chore(fish): ...`（AGENTS.md 準拠）
- 1 タスク 1 コミット。無関係な変更を混ぜない。
- Nix ファイル編集後は `nixfmt <file>` を実行する。
- `nix/` 配下を変更したタスクは `just check`（= `cd nix && nix flake check path:.`）で検証する。実行には aarch64-darwin とネットワークが必要。
- `git rm --cached` はワーキングツリーのファイルを消さない。ディスク上の実体は残るため、symlink 先の動作は変化しない。
- 実行開始前に `git status` を確認する。herdr 導入の未コミット変更（`nix/flake.nix`、`flake.lock`、`home-manager/files/common.nix`、`packages/common.nix`、`config/codex/hooks.json` 等）が残っている場合、先に `chore(herdr): herdr を導入` として独立コミットしてから着手する。

---

### Task 1: herdr ランタイム生成物の gitignore と設定のコミット

`config/herdr/` にはコミットすべき設定（`config.toml`）と、コミットしてはならないランタイム生成物（ログ、ソケット、セッション状態）が同居している。
特に `session-history.json` は端末スクロールバックの平文で、実際に打ったプロンプトや社内リポジトリ名を含む。
`git add -A` 一発で漏洩する状態なので最優先で遮断する。

**Files:**
- Modify: `.gitignore`
- 追跡開始: `config/herdr/config.toml`、`config/claude/hooks/herdr-agent-state.sh`

- [ ] **Step 1: .gitignore に herdr のランタイム生成物を追加**

`.gitignore` の末尾に以下を追記する。

```gitignore
config/herdr/*.log
config/herdr/*.sock
config/herdr/session*.json
```

- [ ] **Step 2: 除外が効いていることを確認**

Run: `git check-ignore config/herdr/herdr-server.log config/herdr/herdr.sock config/herdr/session.json config/herdr/session-history.json`
Expected: 4 パスすべてが出力される（= 無視されている）。

Run: `git status --short config/herdr/`
Expected: `config/herdr/config.toml` のみが untracked として表示される。

- [ ] **Step 3: 設定ファイルと hook スクリプトを追跡**

`config/claude/hooks/herdr-agent-state.sh` は herdr が生成・上書きする管理ファイルだが、`~/.claude/hooks` はリポジトリへの symlink なので、追跡しないと新しいマシンで SessionStart hook が壊れる。
herdr のバージョン更新時に差分が出たら、そのままコミットして追従する。

```bash
git add .gitignore config/herdr/config.toml config/claude/hooks/herdr-agent-state.sh
```

- [ ] **Step 4: コミット**

```bash
git commit -m "chore(herdr): 設定のみ追跡しランタイム生成物を無視"
```

---

### Task 2: gitignore 済みキャッシュ 221 ファイルの追跡解除

`.cache/`（201 ファイル）と `.state/`（20 ファイル)は `.gitignore` に登録済みだが、登録前にコミットされたため追跡が残っている。
gitignore は追跡済みファイルには効かないので、インデックスから明示的に外す。

**Files:**
- 追跡解除: `.cache/` 配下全部、`.state/` 配下全部（ディスク上には残す）

- [ ] **Step 1: 現状確認**

Run: `git ls-files -i -c --exclude-standard | wc -l`
Expected: `221`

- [ ] **Step 2: インデックスから削除**

```bash
git rm -r --cached .cache .state
```

- [ ] **Step 3: 追跡解除を確認**

Run: `git ls-files -i -c --exclude-standard | wc -l`
Expected: `0`

Run: `ls .cache/nvim`
Expected: ディレクトリが存在する（ディスク上の実体は消えていない）。

- [ ] **Step 4: コミット**

```bash
git commit -m "chore(git): gitignore 済みの .cache と .state を追跡解除"
```

---

### Task 3: tre.fish の廃止構文の修正

`config/fish/functions/tre.fish:2` の `^/dev/null` は fish 3.0 で廃止されたリダイレクト構文で、現行の fish 4.3 ではエラーになる。

**Files:**
- Modify: `config/fish/functions/tre.fish:2`

- [ ] **Step 1: 現状の構文エラーを確認**

Run: `fish --no-execute config/fish/functions/tre.fish`
Expected: `^` に関するエラーが出る。

- [ ] **Step 2: 修正**

```fish
function tre
  command tre $argv -e nvim; and source /tmp/tre_aliases_$USER 2>/dev/null
end
```

- [ ] **Step 3: 構文チェック**

Run: `fish --no-execute config/fish/functions/tre.fish`
Expected: 出力なし・exit 0。

- [ ] **Step 4: コミット**

```bash
git add config/fish/functions/tre.fish
git commit -m "fix(fish): tre.fish の廃止済みリダイレクト構文を修正"
```

---

### Task 4: fisher プラグイン本体の追跡解除

`config/fish/` の追跡 115 ファイルのうち約 99 ファイルは fisher がインストールした外部プラグイン本体で、マニフェストの `fish_plugins` と二重管理になっている。
自作ファイルだけを残して追跡を外し、導入は `fisher update`（README 記載のセットアップ手順）に任せる。

自作として残すファイル（これ以外の `functions/`・`conf.d/`・`completions/` は全部プラグイン由来）:

- `config/fish/config.fish`、`config/fish/fish_plugins`、`config/fish/config.d/`（全 5 ファイル）
- `config/fish/conf.d/{direnv,git_keybindings,load-dotenv,nix,yazi}.fish`
- `config/fish/functions/{fzf_git_branch,ghq_cd_fzf,tmux,tre}.fish`

**Files:**
- Modify: `.gitignore`
- 追跡解除: 上記以外の `config/fish/functions/`、`conf.d/`、`completions/` 全ファイル
- Delete: `config/fish/conf.d/fish_frozen_key_bindings.fish`（fish 4.3 の自動生成ファイル。冒頭に削除推奨と明記されている）

- [ ] **Step 1: プラグイン由来ファイルの追跡解除**

```bash
git ls-files config/fish/functions config/fish/conf.d config/fish/completions \
  | grep -vE 'conf\.d/(direnv|git_keybindings|load-dotenv|nix|yazi)\.fish$' \
  | grep -vE 'functions/(fzf_git_branch|ghq_cd_fzf|tmux|tre)\.fish$' \
  | xargs git rm --cached
```

- [ ] **Step 2: 追跡数を確認**

Run: `git ls-files config/fish | wc -l`
Expected: `16`（config.fish 1 + fish_plugins 1 + config.d 5 + conf.d 5 + functions 4）

- [ ] **Step 3: .gitignore に追加**

`.gitignore` の末尾に以下を追記する。
ホワイトリスト方式で、自作ファイルだけを追跡対象に戻す。

```gitignore
config/fish/completions/
config/fish/conf.d/*
!config/fish/conf.d/direnv.fish
!config/fish/conf.d/git_keybindings.fish
!config/fish/conf.d/load-dotenv.fish
!config/fish/conf.d/nix.fish
!config/fish/conf.d/yazi.fish
config/fish/functions/*
!config/fish/functions/fzf_git_branch.fish
!config/fish/functions/ghq_cd_fzf.fish
!config/fish/functions/tmux.fish
!config/fish/functions/tre.fish
```

- [ ] **Step 4: 生成物ファイルをディスクからも削除**

⚠ `rm` は permissions で deny されている場合がある。ブロックされたらユーザーに実行を依頼する。

```bash
rm config/fish/conf.d/fish_frozen_key_bindings.fish
```

- [ ] **Step 5: 除外の整合を確認**

Run: `git status --short config/fish/ | grep -v '^D ' | grep -v '^M '`
Expected: untracked のプラグインファイルが表示されない（除外が効いている）。

Run: `git check-ignore config/fish/conf.d/direnv.fish`
Expected: 出力なし・exit 1（自作ファイルは除外されていない）。

- [ ] **Step 6: コミット**

```bash
git add .gitignore
git commit -m "chore(fish): fisher 管理のプラグイン本体を追跡解除"
```

---

### Task 5: tmux プラグインの追跡整理と tpm bootstrap

`config/tmux/plugins/` には 3 種類の壊れた状態が混在している。

- `.gitmodules` なしの gitlink 6 件（clone しても中身が復元されない）
- うち `tmux`、`tmux-battery`、`tmux-cpu` の 3 件は `tmux.conf:71-74` の `@plugin` 宣言に存在しない未参照プラグイン
- `tpm` だけは実体 44 ファイルが丸ごとコミット

全部追跡から外し、tpm は初回起動時に自動 clone する方式へ統一する。

**Files:**
- Modify: `.gitignore`、`config/tmux/tmux.conf:102` 付近
- 追跡解除: `config/tmux/plugins/` 配下全部

- [ ] **Step 1: gitlink と tpm 実体の追跡解除**

```bash
git rm --cached config/tmux/plugins/tmux config/tmux/plugins/tmux-battery \
  config/tmux/plugins/tmux-cpu config/tmux/plugins/tmux-fzf \
  config/tmux/plugins/tmux-sensible config/tmux/plugins/tmux-yank
git rm -r --cached config/tmux/plugins/tpm
```

- [ ] **Step 2: .gitignore に追加**

```gitignore
config/tmux/plugins/
```

- [ ] **Step 3: 追跡状態を確認**

Run: `git ls-files config/tmux`
Expected: `tmux.conf`、`scripts/dotbar.tmux`、`scripts/git-status.sh` の 3 件のみ。

- [ ] **Step 4: tpm の自動 bootstrap を tmux.conf に追加**

`config/tmux/tmux.conf` の `run '~/.config/tmux/plugins/tpm/tpm'`（102 行目付近）の直前に以下を挿入する。

```tmux
# tpm が無ければ初回起動時に clone してプラグインを導入する
if "test ! -d ~/.config/tmux/plugins/tpm" \
  "run 'git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm && ~/.config/tmux/plugins/tpm/bin/install_plugins'"
run '~/.config/tmux/plugins/tpm/tpm'
```

- [ ] **Step 5: 未参照プラグインの実体を削除**

⚠ `rm` は permissions で deny されている場合がある。ブロックされたらユーザーに実行を依頼する。
参照されている sensible/yank/fzf の実体は残してよい（ignored のまま動き続け、無ければ `prefix + I` で再導入できる）。

```bash
rm -rf config/tmux/plugins/tmux config/tmux/plugins/tmux-battery config/tmux/plugins/tmux-cpu
```

- [ ] **Step 6: 動作確認**

Run: `tmux source-file ~/.config/tmux/tmux.conf 2>&1 || true`（tmux セッション内で）
Expected: エラーなし。tmux 外で実行している場合は `tmux -f config/tmux/tmux.conf new-session -d -s plancheck && tmux kill-session -t plancheck` で代替。

- [ ] **Step 7: コミット**

```bash
git add .gitignore config/tmux/tmux.conf
git commit -m "chore(tmux): プラグインを追跡解除し tpm bootstrap を追加"
```

---

### Task 6: flake input の整理（yazi 削除と guard-and-guide follows）

`flake.lock` に nixpkgs が 3 系統ある。
原因は 2 つで、`yazi` input（`nix/flake.nix:18`）は `inputs.yazi` への参照がゼロの未使用 input（`packages/common.nix:60` の yazi は `pkgs.yazi`）、`guard-and-guide`（`nix/flake.nix:19`）は `follows` 未設定。
yazi input を消すと付随する `flake-utils`、`rust-overlay`、`systems` も lock から消える。

**Files:**
- Modify: `nix/flake.nix:18-19`
- 再生成: `nix/flake.lock`

- [ ] **Step 1: flake.nix の inputs を修正**

`nix/flake.nix` の 18〜19 行目

```nix
    yazi.url = "github:sxyazi/yazi";
    guard-and-guide.url = "github:kawarimidoll/guard-and-guide";
```

を以下に置き換える（yazi は削除）。

```nix
    guard-and-guide = {
      url = "github:kawarimidoll/guard-and-guide";
      inputs.nixpkgs.follows = "nixpkgs";
    };
```

- [ ] **Step 2: フォーマットと lock 再生成**

`nix flake update` ではなく `nix flake lock` を使う（全 input のバージョンを上げないため）。

```bash
nixfmt nix/flake.nix
cd nix && nix flake lock && cd ..
```

- [ ] **Step 3: lock の nixpkgs が 1 系統になったことを確認**

Run: `jq -r '.nodes | keys[]' nix/flake.lock`
Expected: `nixpkgs` が 1 つだけ。`nixpkgs_2`、`nixpkgs_3`、`yazi`、`rust-overlay`、`flake-utils`、`systems` が消えている。

- [ ] **Step 4: flake check**

Run: `just check`
Expected: エラーなしで完了。

- [ ] **Step 5: コミット**

```bash
git add nix/flake.nix nix/flake.lock
git commit -m "chore(nix): 未使用の yazi input を削除し guard-and-guide に follows を追加"
```

---

### Task 7: Claude Code リンクを common へ移動（private プロファイルの非対称解消)

`.claude/*` と `.cursor/skills` のリンクは `files/work.nix:12-17` にしかなく、private プロファイルでは Claude Code 設定が一切反映されない。
プロファイル固有なのは aerospace と codex だけなので、claude/cursor 系は common へ移す。

**Files:**
- Modify: `nix/nix-darwin/home-manager/files/common.nix:37-43`（home.file ブロック）
- Modify: `nix/nix-darwin/home-manager/files/work.nix:10-18`（home.file ブロック）

**Interfaces:**
- Produces: common の `home.file` に `.claude/*` 5 リンクと `.cursor/skills` が入る。Task 8 はこのブロックに `.claude/RTK.md` を追記する。

- [ ] **Step 1: common.nix の home.file に claude/cursor リンクを追加**

`nix/nix-darwin/home-manager/files/common.nix` の `home.file` ブロックを以下にする。

```nix
  home.file = {
    ".zshenv".source = oos "${configRoot}/zsh/.zshenv";
    ".agents".source = oos "${configRoot}/agents";
    ".codex/hooks".source = oos "${configRoot}/codex/hooks";
    ".codex/hooks.json".source = oos "${configRoot}/codex/hooks.json";
    ".codex/AGENTS.md".source = oos "${configRoot}/codex/AGENTS.md";
    ".claude/settings.json".source = oos "${configRoot}/claude/settings.json";
    ".claude/statusline.py".source = oos "${configRoot}/claude/statusline.py";
    ".claude/hooks".source = oos "${configRoot}/claude/hooks";
    ".claude/skills".source = oos "${configRoot}/agents/skills";
    ".claude/CLAUDE.md".source = oos "${configRoot}/claude/CLAUDE.md";
    ".cursor/skills".source = oos "${configRoot}/agents/skills";
  };
```

- [ ] **Step 2: work.nix から重複リンクを削除**

`nix/nix-darwin/home-manager/files/work.nix` を以下にする（プロファイル固有の aerospace と codex だけ残す）。

```nix
{ config, local, ... }:
let
  configRoot = "${local.dotfilesRoot}/config";
  oos = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    aerospace.source = oos "${configRoot}/aerospace/work";
  };
  home.file = {
    ".codex/config.toml".source = oos "${configRoot}/codex/work/config.toml";
  };
}
```

- [ ] **Step 3: フォーマットと検証**

```bash
nixfmt nix/nix-darwin/home-manager/files/common.nix nix/nix-darwin/home-manager/files/work.nix
just check
```

Expected: エラーなし。

- [ ] **Step 4: switch で反映確認**

Run: `just switch` のあと `readlink ~/.claude/CLAUDE.md`
Expected: リンクが生きている（Home Manager の store 経由でリポジトリの `config/claude/CLAUDE.md` に到達する）。

- [ ] **Step 5: コミット**

```bash
git add nix/nix-darwin/home-manager/files/common.nix nix/nix-darwin/home-manager/files/work.nix
git commit -m "fix(nix): claude/cursor のリンクを common に移動し private でも有効化"
```

---

### Task 8: RTK.md を dotfiles 管理に取り込む

`config/claude/CLAUDE.md` は `@RTK.md` を import しているが、実体の `~/.claude/RTK.md` はリポジトリ管理外で、新しいマシンでは参照切れになる。
内容は rtk（トークン削減プロキシ）の使い方メモで、機密は含まない（2026-07-03 確認済み）。

**Files:**
- Create: `config/claude/RTK.md`（`~/.claude/RTK.md` のコピー）
- Modify: `nix/nix-darwin/home-manager/files/common.nix`（Task 7 で作った home.file ブロック）

- [ ] **Step 1: 実体をリポジトリへコピー**

```bash
cp ~/.claude/RTK.md config/claude/RTK.md
```

- [ ] **Step 2: common.nix にリンクを追加**

Task 7 の `home.file` ブロック内、`".claude/CLAUDE.md"` の行の直後に追加する。

```nix
    ".claude/RTK.md".source = oos "${configRoot}/claude/RTK.md";
```

- [ ] **Step 3: 検証**

```bash
nixfmt nix/nix-darwin/home-manager/files/common.nix
just check
just switch
```

Run: `cat ~/.claude/RTK.md | head -1`
Expected: `# RTK - Rust Token Killer`

- [ ] **Step 4: コミット**

```bash
git add config/claude/RTK.md nix/nix-darwin/home-manager/files/common.nix
git commit -m "chore(claude): RTK.md を dotfiles 管理に取り込み"
```

---

### Task 9: hook のハードコード絶対パスを $HOME に統一

herdr の SessionStart hook だけが `/Users/nasuno.ayumu/...` の絶対パスで登録されている。
同ファイル内の他の hook（`config/claude/settings.json:45` の rtk-rewrite）は `$HOME` を使っており、それに揃える。
注意: これらのエントリは herdr のインストーラが書いた可能性があり、herdr の更新で絶対パスに戻ることがある。戻っていたら再修正する。

**Files:**
- Modify: `config/claude/settings.json:67`
- Modify: `config/codex/hooks.json:18`

- [ ] **Step 1: settings.json の修正**

`config/claude/settings.json` の SessionStart hook を以下にする。

```json
            "command": "bash \"$HOME/.claude/hooks/herdr-agent-state.sh\" session",
```

- [ ] **Step 2: hooks.json の修正**

`config/codex/hooks.json` の SessionStart hook を以下にする。

```json
            "command": "bash \"$HOME/.codex/herdr-agent-state.sh\" session",
```

- [ ] **Step 3: JSON の構文と動作を確認**

Run: `jq empty config/claude/settings.json config/codex/hooks.json`
Expected: 出力なし・exit 0。

Run: `bash "$HOME/.claude/hooks/herdr-agent-state.sh" session; echo "exit=$?"`
Expected: `exit=0`（herdr 環境変数が無い場合は早期 exit 0 するガードがある）。

- [ ] **Step 4: コミット**

```bash
git add config/claude/settings.json config/codex/hooks.json
git commit -m "fix(claude,codex): herdr hook の絶対パスを \$HOME に統一"
```

---

### Task 10: バックログ（判断が必要、または低優先の項目）

以下は実害が小さいか、ユーザーの判断が必要な項目。
着手時に 1 項目 1 コミットで進める。

**判断が必要:**

- [ ] `config/codex/private/config.toml` に `/Users/luvpame/` と `/Users/nasuno.ayumu/` の 2 ユーザーのパスが混在。どちらのマシン用か決めて他方のエントリ（`[projects]`、`notify`、`[mcp_servers]` 内のパス）を削除する。
- [ ] `config/codex/{work,private}/config.toml` の自動生成セクション（`[marketplaces].last_updated`/`last_revision`、`[hooks.state].trusted_hash`、`[projects]` の trust 記録）が commit churn を生む。Codex は設定分割をサポートしないため、当面は「コミット時に `git add -p` で手動設定の差分だけ拾う」運用とし、蓄積した古い `[projects]` エントリ（`~/Documents/Codex/` の日付付きパス等）を削除する。
- [ ] `config/agents/.skill-lock.json` が陳腐化。ディスクに存在しない `slidev` のエントリを削除し、ベンダリング済み 21 スキルの由来を lock に再記録するか、lock 自体を廃止するか決める。
- [ ] `config/agents/skills/` の Cloudflare 系スキル（`cloudflare` 320 ファイルほか計約 530 ファイル）を使い続けるか判断。使っていなければ削除でリポジトリの追跡ファイルが半減する。
- [ ] `config/raycast/Raycast 2026-04-28 21.15.36.rayconfig`（2.2MB、暗号化エクスポート）を追跡し続けるか判断。Raycast のクラウド同期を使うなら削除。
- [ ] `config/tirith/` は本体パッケージ削除済み（コミット 7f0402f）のため、設定ディレクトリも削除するか判断。

**低優先の改善（判断不要、手が空いたときに）:**

- [ ] `config/yazi/flavors/` の flavor 実体を追跡解除し `ya pack -i` 導入に統一する。`package.toml:4-11` に rev/hash 付きの依存宣言が既にある。`git rm -r --cached config/yazi/flavors` + `.gitignore` に `config/yazi/flavors/` を追加し、README のセットアップ手順に `ya pack -i` を追記。
- [ ] `config/nvim/lua/config/lazy.lua:29` の `checker.enabled = true` を `false` にする。`lazy-lock.json` でバージョン固定する運用と自動更新チェックは方向が逆。更新は手動 `:Lazy update` で行う。
- [ ] aerospace の `work/aerospace.toml` と `private/aerospace.toml` の全文重複（116 行）を解消する。共通部分を 1 ファイルにまとめる仕組みが aerospace に無いため、当面はコメントで「両ファイルを同期して編集する」旨を明記するだけでもよい。
- [ ] `nix/nix-darwin/homebrew/common.nix:34` の `ripgrep`（nix 側 `packages/common.nix:33` と二重）のコメントに「codex formula の依存であり nix 版と共存させる」理由を明記する。
- [ ] `config/gh/`、`config/raycast/scripts/` が nix からリンクされていない。管理対象にするなら `files/common.nix` にリンクを追加する。
- [ ] `config/claude/statusline.py` の `is_dark_mode()`（31-40 行）と `git_info()`（102-111 行）が再描画のたびに subprocess を起動する。mtime ベースの数秒キャッシュを検討。
- [ ] `config/tmux/scripts/dotbar.tmux` と `config/raycast/scripts/2webp.sh` に `set -euo pipefail` を追加する。
- [ ] `nix/nix-darwin/home-manager/packages/work.nix:2` と `packages/private.nix:2` の未使用引数 `inputs` を削除する。
- [ ] guard-and-guide の PreToolUse matcher が Claude（`.*`、`config/claude/settings.json:30`）と Codex（`Bash`、`config/codex/hooks.json:11`)で不一致。意図を確認してどちらかに揃える。
- [ ] `config/claude/CLAUDE.md` と `config/codex/AGENTS.md` の共通ルール（編集後 code-simplifier、起動時 japanese-tech-writing）が別表現で二重記述。`config/agents/` 配下に共通ファイルを置き、両方から参照する形を検討。

---

## 検証（全タスク完了後）

- [ ] `git ls-files | wc -l` が大幅に減っている（着手前 1047。Task 2/4/5 で約 365 減の見込み）。
- [ ] `git ls-files -i -c --exclude-standard | wc -l` が `0`。
- [ ] `just check` が通る。
- [ ] `just switch` 後、fish 新セッション・tmux 新セッション・nvim 起動・Claude Code 起動（statusline と SessionStart hook）がすべて正常。
