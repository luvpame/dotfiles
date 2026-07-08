# リポジトリガイドライン

## プロジェクト構成とモジュール構成
- `nix/`: Flake のエントリポイント（`flake.nix` / `flake.lock` / `local.nix.example`）と、macOS の system+Homebrew+Home Manager 状態を管理する `nix-darwin/`、カスタム package 定義の `pkgs/` を持つ。`local.nix` は `local.nix.example` から作成する非追跡のローカル設定。
- `config/`: 各種ツール設定を集約するディレクトリ。`config/fish/` にシェル設定、`config/git/` に Git 設定、`config/agents/skills/` に再利用可能なエージェントスキルを保存する。加えて `config/aerospace/`、`config/cage/`、`config/efm-langserver/`、`config/gh/`、`config/guard-and-guide/`、`config/herdr/`、`config/lazygit/`、`config/mise/`、`config/nvim/`、`config/raycast/`、`config/tmux/`、`config/wezterm/`、`config/yazi/`、`config/zed/`、`config/zsh/` などのツール別設定を配置する。`config/claude/` には `CLAUDE.md`・`RTK.md`・`settings.json`・`statusline.py`・`hooks/`、`config/codex/` には `AGENTS.md`・`hooks.json`・`hooks/` と用途別の `private/` / `work/` 設定がある。
- `script/`: ユーティリティ Bash スクリプトを配置するディレクトリ。現状は `set-fish-default.sh` がある。
- `menubar-script/`: `calendar/`、`ime/`、`media/` などのメニューバー連携用スクリプト群。
- `docs/`: Superpowers の計画書や仕様メモを `docs/superpowers/` 配下に保存する。
- 補助生成物として `build/`（`download/` と `markdown/` を含む）、運用コマンドの入口としてトップレベルの `justfile` がある。隠しディレクトリとして `.claude/`（`settings.local.json`）に加え、ツール実行時のキャッシュや状態を保持する `.cache/`・`.data/`・`.state/` がルートに現れる。補助ログとしてトップレベルの `nvim.log` も存在する。

## ビルド・テスト・開発コマンド
- `just check` — `nix/` で `nix flake check` を実行し、flake と darwin 設定を検証。
- `just build` — `nix/` で `nh darwin build` を実行し、darwin 設定をビルド。
- `just switch` — `nix/local.nix` の `darwinConfigName` を使って system/Homebrew/Home Manager 設定を適用。
- `just update` — `nix/` で flake 入力を更新。
- `just update-and-switch` — flake 更新と darwin 反映を連続で実行。
- `just clean` — `nh clean all --keep-since 4d --keep 3` で古い Nix 世代を整理。
- `reload`（Fish 略語）— ログインシェルを再起動して新しい設定を読み込む。`fish_plugins` を変更した場合は `fisher update` を続けて実行。

## コーディングスタイルと命名規則
- Nix: `nixfmt <file>` を実行。2 スペースインデントを保ち、可能な限り属性セットをソート。
- シェルスクリプト: `#!/bin/bash` + `set -euo pipefail`。`echo -e` より `printf` の長いオプションを優先。
- ファイル名とスコープ名は kebab-case（例: `set-fish-default.sh`）。ツールごとのディレクトリでスコープ化したファイル名を使用。
- 小さく合成可能なスクリプトは `script/` に配置。秘密情報やホスト固有パスの埋め込みは避ける。

## テストガイドライン
- 自動テストは最小限のため、コミット/PR 前に `cd nix && nix flake check` を実行。
- 新規スクリプトでは可能な限り dry-run フラグを追加し、macOS（Apple Silicon）で手動テスト。
- Nix の入力やサービスを変更した後は darwin の switch コマンドを再実行し、サービスをスポットチェック（例: `launchctl list | grep jankyborders`）。

## コミット & PR ガイドライン
- コミットメッセージは Conventional Commits（スコープ付き。例: `chore(nix): ...`、`docs(cursor): ...`、`chore(fish): ...`）。命令形を使用。
- コミットは焦点を絞る。無関係なツール設定と Nix 変更を混ぜない。
- PR には以下を含める: 簡単な概要、影響範囲（Nix/Fish/アプリ設定）、実行したコマンド（`cd nix && nix flake check`、apply switch）、UI 変更がある場合はスクリーンショット。

## セキュリティ & 設定の注意点
- `nix/local.nix` は非追跡のローカル設定ファイルで、`nix/local.nix.example` を元に各環境の値へ編集して使う。
- `nix/local.nix.example` は初期値の参照用テンプレートとして保持し、必要に応じて `nix/local.nix` と見比べて更新する。
- `nix/local.nix` は秘密情報やホスト固有値を含むためコミットしない。Nix が検知できるよう `.gitignore` には追加せず、誤って追跡されている場合はファイルを残したまま `git rm --cached nix/local.nix` で追跡だけ外す。
- 秘密情報はコミットしない。Git の identity は `~/.config/git/config.local`（テンプレート: `config/git/config.local.example`）に保持し、その他の認証情報は 1Password CLI（`op signin`）を使用。
- `flake.lock` を唯一の正とし、手動編集は避ける。依存更新時にはロックファイルもコミット。
- 新しい cask やパッケージを追加する場合は `nix/nix-darwin/homebrew/` と `nix/nix-darwin/home-manager/packages/` 配下を優先して宣言的に管理し、switch コマンドを再実行してシステムに反映。

## エージェントスキル
- 再利用可能なスキルは `config/agents/skills/` に保存。
- タスクで特定のスキルが明示された場合は、そのスキルのワークフローを使用し、変更範囲は要求された領域に限定。
