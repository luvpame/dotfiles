# Repository Guidelines

## Project Structure & Module Organization
このリポジトリは、Nix Flakes と nix-darwin を使って macOS 環境を管理します。

- `flake.nix` / `flake.lock`: Flake のエントリポイントと依存の固定。
- `nix-darwin/`: system と Home Manager のモジュール群。
- `nix-darwin/default.nix`、`nix-darwin/nix-core.nix`、`nix-darwin/users.nix`、`nix-darwin/system.nix`
- `nix-darwin/homebrew/`: `common.nix`、`work.nix`、`private.nix`
- `nix-darwin/home-manager/`: `default.nix`、`files/`、`packages/`
- `pkgs/`: nixpkgs にないカスタムパッケージ定義（例: `site2skill`、`tree-sitter-cli`）。
- `local.nix` / `local.nix.example`: ローカルマシン固有の上書き設定。

変更は責務に合わせて配置してください。システム設定は `nix-darwin/`、カスタムパッケージは `pkgs/` に分離します。

## Build, Test, and Development Commands
- `nix flake check`
  Flake 出力とモジュール評価を検証します。
- `sudo -H nix run github:LnL7/nix-darwin -- switch --flake path:.#<darwinConfigName>`
  system + Home Manager 設定をホストに適用します。
- `nix flake update`
  flake input を更新します。

コマンドは `nix/` ディレクトリで実行してください。
`nix flake` 系コマンドは Codex 実行環境だと極端に遅くなるため、必要時はユーザー環境での実行を依頼してください。

## Coding Style & Naming Conventions
- Nix は 2 スペースインデント、属性順は一貫させる。
- コミット前に `nixfmt <file>` を実行する。
- Shell スクリプトは `#!/bin/bash` と `set -euo pipefail` を先頭に置く。
- ファイル名は kebab-case を推奨（例: `tree-sitter-cli`）。
- 秘密情報やホスト依存の絶対パスは埋め込まない。

## Testing Guidelines
自動テストは最小限のため、設定検証を主な品質ゲートにします。

- PR/コミット前に `nix flake check` を必ず実行する。
- サービスやパッケージ変更後は switch 実行後に動作確認する（例: `launchctl list | grep <service>`）。
- 新規スクリプトには可能な限り dry-run オプションを追加し、Apple Silicon macOS で確認する。
- Codex からは `nix flake check` などが遅延しやすいため、検証コマンド実行は基本的にユーザーに依頼する。

## Security & Configuration Tips
- 秘密情報はコミットしない。
- `flake.lock` を唯一の正とし、手動編集ではなく Nix ワークフローで更新する。

### `local.nix` の取り扱い
- `flake.nix` は `local.nix` がなければ `local.nix.example` にフォールバックする。
- ただし実運用では `local.nix` を作成し、ローカル値で上書きすることを推奨。  
  例: `cp local.nix.example local.nix`
- `local.nix` には以下を設定する。
- `darwinConfigName`（`switch --flake path:.#<name>` の `<name>`）
- `userName`
- `homeDirectory`（絶対パス）
- `dotfilesRoot`（このリポジトリの絶対パス）
- `profile`（`work` または `private`）
- `local.nix` はローカル専用のためコミットしない。
- `local.nix` は秘密情報やホスト固有値を含むためコミットしない。Nix が検知できるよう `.gitignore` には追加せず、誤って追跡されている場合はファイルを残したまま `git rm --cached local.nix` で追跡だけ外す。
- `just switch` は `local.nix` を直接読むため、switch 前に `cp local.nix.example local.nix` で作成しておく。
