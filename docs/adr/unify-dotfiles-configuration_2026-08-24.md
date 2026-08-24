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

ユーザー名、ホームディレクトリ、canonical checkout のパスは `nix/flake.nix` に追跡済みの値として定義する。
Nix の構成名は `default` に固定し、実機のホスト名は管理しない。

Nix モジュールは責務ごとの単一ファイルへ平坦化する。
Home Manager は canonical checkout の `config/` を out-of-store symlink で参照し、設定の即時反映を維持する。
`just switch` は canonical checkout からの実行だけを許可する。

Git identity の `config/git/config.local` は、公開リポジトリへ置けない値を分離するため残す。

## Options Considered

- **用途別の構成を維持する**：環境ごとの切り替えはできるが、単一ユーザーには不要な分岐とローカル入力を保守し続けることになる。
- **実行時にユーザー名やパスを解決する**：clone 先の自由度は上がるが、Nix の評価条件と初回適用の挙動が複雑になる。
- **単一構成と固定パスへ統一する**：公開されるパスと checkout 規約を受け入れる代わりに、評価と即時反映の仕組みを単純に保てる。

## Consequences

構成選択のための `local.nix`、用途別ディレクトリ、動的 import がなくなり、設定の入口が `default` に揃う。
作業ツリーからのリンクは維持されるため、編集内容は switch を待たずに各アプリへ反映できる。

別のユーザーや checkout 先へそのまま移す用途は対象外になる。
別 checkout では check と build を実行できるが、canonical checkout 以外からの switch はエラーになる。

## References

- `nix/flake.nix`
- `justfile`
