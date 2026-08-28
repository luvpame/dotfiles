# リポジトリガイドライン

## プロジェクト構成とモジュール構成
- `archive/`: 使用を終了した設定を現行設定から分離して保存する。退避手順は `archive/README.md` に従う。
- `nix/`: Flake のエントリポイント（`flake.nix` / `flake.lock`）と、macOS の system、Homebrew、Home Manager 状態を管理する `nix-darwin/`、カスタム package 定義の `pkgs/` を持つ。
- `config/`: 各種ツール設定を集約するディレクトリ。`config/fish/` にシェル設定、`config/git/` に Git 設定、`config/agents/skills/` に再利用可能なエージェントスキルを保存する。加えて `config/aerospace/`、`config/efm-langserver/`、`config/gh/`、`config/guard-and-guide/`、`config/herdr/`、`config/hunk/`、`config/lazygit/`、`config/mise/`、`config/nvim/`、`config/raycast/`、`config/tmux/`、`config/wezterm/`、`config/worktrunk/`、`config/yazi/`、`config/zed/`、`config/ziggity/`、`config/zsh/` などのツール別設定を配置する。`config/claude/` には `CLAUDE.md`・`RTK.md`・`SOUL.md`・`settings.json`・`statusline.py`・`hooks/`、`config/codex/` には `AGENTS.md`・`SOUL.md`・`hooks.json`・`hooks/`・`config.toml` を配置する。
- `script/`: ユーティリティ Bash スクリプトを配置するディレクトリ。`set-fish-default.sh` と `setup-git-signing.sh` がある。
- `menubar-script/`: `herdr/`、`ime/`、`media/`、`vpn/` のメニューバー連携用スクリプト群。
- `docs/`: ADR を `docs/adr/` に、エージェント向けガイドを `docs/agents/` に、調査資料を `docs/research/` に、Superpowers の計画書や仕様メモを `docs/superpowers/` 配下に保存する。
- 補助生成物として `build/`（`download/` と `markdown/` を含む）、運用コマンドの入口としてトップレベルの `justfile` がある。隠しディレクトリとして `.claude/`（`settings.local.json`）に加え、ツール実行時のキャッシュや状態を保持する `.cache/`・`.data/`・`.state/` がルートに現れる。`nvim.log` は Neovim 実行時に生成される補助ログである。

## ビルド・テスト・開発コマンド
- `just check` — `nix/` で `nix flake check` を実行し、flake と darwin 設定を検証。
- `just build` — `nix/` で `nh darwin build` を実行し、darwin 設定をビルド。
- `just switch` — 実行した checkout を `$HOME/.dotfiles` に更新してから、`default` 構成の system、Homebrew、Home Manager 設定を適用。Git worktree も使用できる。
- `just update` — `nix/` で flake 入力を更新。
- `just update-and-switch` — flake 更新と darwin 反映を連続で実行。
- `just clean` — `nh clean all --keep-since 30d --keep 3` で古い Nix 世代を整理。
- `reload`（Fish 略語）— ログインシェルを再起動して新しい設定を読み込む。`fish_plugins` を変更した場合は `fisher update` を続けて実行。

## コーディングスタイルと命名規則
- Nix: `nixfmt <file>` を実行。2 スペースインデントを保ち、可能な限り属性セットをソート。
- シェルスクリプト: `#!/bin/bash` + `set -euo pipefail`。`echo -e` より `printf` の長いオプションを優先。
- ファイル名とスコープ名は kebab-case（例: `set-fish-default.sh`）。ツールごとのディレクトリでスコープ化したファイル名を使用。
- 小さく合成可能なスクリプトは `script/` に配置。秘密情報やホスト固有パスの埋め込みは避ける。

## テストガイドライン
- 自動テストは最小限のため、コミット/PR 前に `cd nix && nix flake check` を実行。
- 新規スクリプトでは可能な限り dry-run フラグを追加し、macOS（Apple Silicon）で手動テスト。
- Nix の入力やサービスを変更した後は darwin の switch コマンドを再実行し、サービスをスポットチェック（例: `launchctl list | grep herdr`）。

## コミット & PR ガイドライン
- コミットメッセージは Conventional Commits（スコープ付き。例: `chore(nix): ...`、`docs(cursor): ...`、`chore(fish): ...`）。命令形を使用。
- コミットは焦点を絞る。無関係なツール設定と Nix 変更を混ぜない。
- PR には以下を含める: 簡単な概要、影響範囲（Nix/Fish/アプリ設定）、実行したコマンド（`cd nix && nix flake check`、apply switch）、UI 変更がある場合はスクリーンショット。

## セキュリティ & 設定の注意点
- `nix/nix-darwin/users.nix` の `dotfiles.user.name` にユーザー名を一か所だけ定義し、ホームディレクトリと各モジュールのユーザー情報をそこから導出する。nix-darwin 統合 Home Manager の `home.username` と `home.homeDirectory` は自動導出に任せる。リポジトリは `$HOME/.dotfiles` の安定したシンボリックリンクから参照する。これらは認証情報ではない。
- 秘密情報はコミットしない。Git の identity は `~/.config/git/config.local`（テンプレート: `config/git/config.local.example`）に保持し、その他の認証情報は 1Password CLI（`op signin`）を使用。
- `flake.lock` を唯一の正とし、手動編集は避ける。依存更新時にはロックファイルもコミット。
- 新しい Homebrew cask は `nix/nix-darwin/homebrew.nix`、Nix パッケージは `nix/nix-darwin/home-manager/packages.nix` へ宣言的に追加し、switch コマンドを再実行してシステムに反映。
- 使用を終了した設定を退避する場合は、Home Manager の配置宣言を確認してから `archive/` へ移し、元の宣言位置に退避先を示す一行コメントを残す。詳細は `archive/README.md` を参照。

## Agent skills

- 再利用可能なスキルは `config/agents/skills/` に保存。
- タスクで特定のスキルが明示された場合は、そのスキルのワークフローを使用し、変更範囲は要求された領域に限定。

### Issue tracker

Issues and PRDs are tracked as GitHub issues in `luvpame/dotfiles`. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the default triage labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Use the single-context layout with `CONTEXT.md` and `docs/adr/` at the repository root. See `docs/agents/domain.md`.
