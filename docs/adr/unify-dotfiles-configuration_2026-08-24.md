# Dotfiles 構成を単一ユーザーへ統一する

Date: 2026-08-24

## Status

Accepted

## Context

Nix、Home Manager、Codex、AeroSpace の設定が用途別の構成に分かれていた。
構成を選ぶために非追跡の `nix/local.nix` を必要とし、同じ設定を複数のディレクトリへ分散していた。

このリポジトリは単一の macOS ユーザーが使うため、構成の切り替えは運用上の要件ではない。
一方、設定ファイルは作業ツリーから直接リンクしており、編集直後に反映できる利点がある。

## Decision

現在使っている設定を唯一の構成へ昇格し、用途別の構成と非追跡のローカル入力を廃止する。
旧構成のうち不要な設定は現在のツリーから削除するが、Git 履歴は書き換えない。

ユーザー名は `nix/nix-darwin/users.nix` の `dotfiles.user.name` に一度だけ定義する。
`users.users.<name>.home` と統合 Home Manager の `home.username`、`home.homeDirectory` はそこから自動導出する。
リポジトリの clone 先は固定せず、`$HOME/.dotfiles` を現在使う checkout への安定した入口とする。
Nix の構成名は `default` に固定し、実機のホスト名は管理しない。

Nix モジュールは責務ごとの単一ファイルへ平坦化する。
Home Manager は `$HOME/.dotfiles/config/` を out-of-store symlink で参照し、設定の即時反映を維持する。
`just switch` は `nix/` working-directory から実行元 checkout の物理パスを取得し、switch 前に `$HOME/.dotfiles` をその checkout へ更新する。
既存の `$HOME/.dotfiles` がシンボリックリンクではない場合は上書きせずに停止する。
Git worktree からの実行も許可する。

Git identity の `config/git/config.local` は、公開リポジトリへ置けない値を分離するため残す。

## Options Considered

- **用途別の構成を維持する**：環境ごとの切り替えはできるが、単一ユーザーには不要な分岐とローカル入力を保守し続けることになる。
- **実行時にユーザー名やパスを解決する**：clone 先の自由度は上がるが、Nix の評価条件と初回適用の挙動が複雑になる。
- **単一構成と `$HOME/.dotfiles` への安定リンクへ統一する**：Nix の参照先を固定しながら clone 先を自由にでき、switch 時にリンクを更新して即時反映も維持できる。

## Consequences

構成選択のための `local.nix`、用途別ディレクトリ、動的 import がなくなり、設定の入口が `default` に揃う。
作業ツリーからのリンクは維持されるため、編集内容は switch を待たずに各アプリへ反映できる。

clone 先を変更しても、`just switch` が `$HOME/.dotfiles` を実行元 checkout へ更新するため、Nix の設定を変更する必要はない。
ユーザー名を変更する場合は、`nix/nix-darwin/users.nix` の `dotfiles.user.name` だけを変更する。
初回 switch の前には `$HOME/.dotfiles` を作成する必要がある。
シンボリックリンクではない既存の `$HOME/.dotfiles` は保護され、switch はエラーになる。
別の checkout や Git worktree から switch すると、その checkout が次に使う設定としてリンクされる。

## References

- `nix/flake.nix`
- `nix/nix-darwin/users.nix`
- `justfile`
