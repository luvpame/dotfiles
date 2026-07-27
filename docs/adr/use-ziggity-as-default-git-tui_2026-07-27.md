# Ziggity を既定の Git TUI として使う

Date: 2026-07-27

## Status

Accepted

## Context

この dotfiles では、Fish、Neovim、tmux、Herdr から LazyGit を起動している。
Ziggity は LazyGit に近い操作体系を持ちながら、単一のネイティブバイナリとして動作し、Git 操作中も画面をブロックしない。

一方、Ziggity は LazyGit の設定ファイルと互換性がなく、固定中の nixpkgs にもパッケージがない。
LazyGit の設定には Ziggity で代替できない日本語表示、Nerd Fonts、Hunk pager、絵文字展開が含まれる。

## Decision

Fish の `lg`、Neovim の `<leader>gg`、tmux の `prefix+g`、Herdr の `prefix+g` は Ziggity を起動する。
Ziggity は公式 Homebrew tap `simoarpe/ziggity` から導入する。

Ziggity のグローバル設定は `config/ziggity/config.ini` で管理し、`ZIGGITY_CONFIG` で明示的に読み込ませる。
設定ファイルには安定版 `v0.11.0` のデフォルト値を日本語コメント付きで記述し、更新時に挙動の変更を差分として確認できるようにする。

LazyGit の Nix パッケージと `config/lazygit/` は削除しない。
専用ショートカットは残さず、必要な場合は `lazygit` コマンドで明示的に起動する。

## Options Considered

- **LazyGit を使い続ける**：既存設定をそのまま使えるが、Ziggity を日常の Git TUI として評価できない。
- **LazyGit を完全に削除する**：管理対象は減るが、Ziggity に移せない設定とフォールバックを失う。
- **Ziggity の Nix パッケージを独自に定義する**：パッケージ管理を Nix に統一できるが、リリースごとのバージョンと hash の保守が増える。
- **Ziggity を公式 Homebrew tap から導入し、LazyGit を残す**：パッケージ管理元は分かれるが、公式リリースに追従しながら安全に移行できる。

## Consequences

既存のキーバインドを変えずに、日常の Git TUI が Ziggity へ切り替わる。
LazyGit は明示起動できるため、Ziggity の未対応機能や挙動差に遭遇しても作業を継続できる。

Ziggity のデフォルト値は設定ファイルに固定される。
Ziggity を更新するときは、安定版のデフォルト値との差分を確認し、必要に応じて設定ファイルを更新する。

## References

- [simoarpe/ziggity](https://github.com/simoarpe/ziggity)
- [Ziggity v0.11.0 configuration](https://github.com/simoarpe/ziggity/blob/v0.11.0/src/config.zig)
- [ADR の命名規則](./use-summary-date-adr-filenames_2026-07-09.md)
