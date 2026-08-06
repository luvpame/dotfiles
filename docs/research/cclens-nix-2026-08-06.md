# cclens を Nix で導入するための調査

調査日：2026-08-06

対象は [Zenn の紹介記事](https://zenn.dev/lambdalisue/articles/introduce-cclens) から辿れる公式リポジトリ `lambdalisue/cclens` である。
記事は、macOS と Linux の Intel、ARM64 を対象として `nix run github:lambdalisue/cclens -- doctor` と `nix profile install github:lambdalisue/cclens` を案内している。
一方、この dotfiles へ宣言的に組み込む場合は、更新の追従しやすさだけでなく、バイナリキャッシュを本当に利用できるか、生成 DB をどこへ置くかも決める必要がある。

## 調査時点のリリース

最新リリースは [v0.1.1](https://github.com/lambdalisue/cclens/releases/tag/v0.1.1) で、タグは commit [`14c611720a98a4fbec2b576fe878175031ef651d`](https://github.com/lambdalisue/cclens/commit/14c611720a98a4fbec2b576fe878175031ef651d) を指す。
一つ前のタグは v0.1.0 である。
v0.1.1 には `aarch64-apple-darwin`、`x86_64-apple-darwin`、`aarch64-unknown-linux-gnu`、`x86_64-unknown-linux-gnu` の実行ファイルと、それぞれの `.sha256` が添付されている（[release workflow](https://github.com/lambdalisue/cclens/blob/v0.1.1/.github/workflows/release.yml)、[build matrix](https://github.com/lambdalisue/cclens/blob/v0.1.1/.github/workflows/build.yml)）。

Apple Silicon 用 archive は `cclens-v0.1.1-aarch64-apple-darwin.tar.gz` で、GitHub Releases API が示す SHA-256 は `d7b1b5296384f8242162963dfcaa5e0f52f9f0257d767691f04bada8f94a833e` である（[release asset](https://github.com/lambdalisue/cclens/releases/download/v0.1.1/cclens-v0.1.1-aarch64-apple-darwin.tar.gz)、[API metadata](https://api.github.com/repos/lambdalisue/cclens/releases/latest)）。
親調査では archive の SHA 一致と展開した `cclens --help` の成功まで確認済みである。

注意すべきなのは、v0.1.1 の [`Cargo.toml`](https://github.com/lambdalisue/cclens/blob/v0.1.1/Cargo.toml#L1-L4) と Claude Code plugin manifest が、どちらも内部 version を `0.1.0` のままにしていることである（[plugin manifest](https://github.com/lambdalisue/cclens/blob/v0.1.1/plugins/cclens/.claude-plugin/plugin.json#L1-L11)）。
導入側の package version は、リリースタグに合わせて `0.1.1` とするのが実体を追いやすい。

また、v0.1.1 のツリーには `LICENSE` がなく、GitHub API も license を検出していない（[repository metadata](https://api.github.com/repos/lambdalisue/cclens)）。
個人環境から取得して実行する範囲を越えてバイナリを再配布したり、公開 binary cache に載せたりするなら、先に upstream へライセンスを確認したほうがよい。

## 上流 flake の構成

公式 flake は `flake-utils.lib.eachDefaultSystem` を使い、既定の `packages.default` と `apps.default` を公開する（[`flake.nix`](https://github.com/lambdalisue/cclens/blob/v0.1.1/flake.nix#L24-L47)）。
実際に `nix flake show github:lambdalisue/cclens/v0.1.1 --json` を評価し、Linux と Darwin の aarch64、x86_64 に既定 app があることを確認した。

ビルドには `rust-overlay` と `crane` を使い、`rust-toolchain.toml` の stable toolchain を `crane` に渡している（[`flake.nix`](https://github.com/lambdalisue/cclens/blob/v0.1.1/flake.nix#L14-L42)、[`rust-toolchain.toml`](https://github.com/lambdalisue/cclens/blob/v0.1.1/rust-toolchain.toml)）。
Rust の `rusqlite` は `bundled` feature 付きなので SQLite をソースから組み込み、system の SQLite や `pkg-config` を runtime/build input として要求しない（[`Cargo.toml`](https://github.com/lambdalisue/cclens/blob/v0.1.1/Cargo.toml#L10-L14)、[`flake.nix`](https://github.com/lambdalisue/cclens/blob/v0.1.1/flake.nix#L35-L42)）。
通常の解析コマンドは単体バイナリで動くが、`cclens optimize` は `claude` を `PATH` から起動するため、このサブコマンドには Claude Code が必要である（[`src/cli.rs`](https://github.com/lambdalisue/cclens/blob/v0.1.1/src/cli.rs#L355-L363)）。

上流 flake は `https://cclens.cachix.org` と公開鍵を `nixConfig` に宣言している（[`flake.nix`](https://github.com/lambdalisue/cclens/blob/v0.1.1/flake.nix#L4-L12)）。
しかし `nix eval github:lambdalisue/cclens/v0.1.1#packages.aarch64-darwin.default...` を実行すると、`--accept-flake-config` を渡さない限り両設定を無視するという警告が出た。
さらに、cclens を別 flake の input にしたとき、その input の `nixConfig` が top-level flake の信頼設定として自動適用されるとは見込めない。
したがって upstream package を input として採用する場合は、cclens の `nixpkgs`、`crane`、`rust-overlay` などの lock node が増え、cache を明示的に信頼しなければローカルで Rust 依存をビルドし得る。

なお、v0.1.1 の `flake.lock` は cclens 自身の `nixpkgs` を `567a49d1913ce81ac6e9582e3553dd90a955875f` に固定している（[`flake.lock`](https://github.com/lambdalisue/cclens/blob/v0.1.1/flake.lock)）。
これは再現性を持つ反面、この dotfiles が使う nixpkgs と自動では共有されない。

## nixpkgs への掲載状況

調査環境の現在の nixpkgs に対して `nix eval nixpkgs#cclens.meta.name --raw` を実行すると、`cclens` 属性は存在せず、Nix は候補として `ccls`、`csvlens`、`lens` を返した。
[NixOS package search の `cclens` 検索](https://search.nixos.org/packages?channel=unstable&query=cclens) でも同名 package は確認できない。
そのため、現時点では `pkgs.cclens` を Home Manager の package list に加える方式は使えない。

## Claude Code plugin と DB

公式リポジトリは Claude Code plugin marketplace でもあり、plugin は `/cclens:doctor`、`/cclens:optimize`、`/cclens:query` の三つの skill を提供する（[README](https://github.com/lambdalisue/cclens/blob/v0.1.1/README.md#L49-L69)、[marketplace manifest](https://github.com/lambdalisue/cclens/blob/v0.1.1/.claude-plugin/marketplace.json)）。
plugin 内に hooks はない。
cclens が既存の Claude Code hooks を設定 surface として解析することと、cclens 自身を hook で起動することは別である。
導入時に `settings.json` の hooks を変更する必要はない。

各 skill は `cclens` が `PATH` にあればそれを使い、なければ `nix run github:lambdalisue/cclens` にフォールバックする（[`doctor` skill](https://github.com/lambdalisue/cclens/blob/v0.1.1/plugins/cclens/skills/doctor/SKILL.md#L12-L18)）。
カレントディレクトリに `cclens.db` がある場合はそれを使い、ない場合は `${XDG_CACHE_HOME:-$HOME/.cache}/cclens/cclens.db` を作成して `--db` で渡す（[`doctor` skill](https://github.com/lambdalisue/cclens/blob/v0.1.1/plugins/cclens/skills/doctor/SKILL.md#L19-L33)）。

バイナリ単体の既定値は `./cclens.db` である。
解析対象は `~/.claude/projects` と live config で、読み取り専用かつ増分に処理し、派生データだけを SQLite store に書く（[README](https://github.com/lambdalisue/cclens/blob/v0.1.1/README.md#L87-L94)）。
dotfiles のルートで誤って実行して untracked DB を生まないよう、plugin を使わない運用でも user cache の DB path を明示するのが安全である。
schema が変わった古い DB は拒否され、削除すれば再生成できる cache として扱われる（[README](https://github.com/lambdalisue/cclens/blob/v0.1.1/README.md#L170-L178)）。

## 要件確定後の推奨導入方式

追加要件は、CLI と Claude Code plugin の両方を導入し、日常の `just us` で更新することである。
この条件では、cclens の default branch を Flake input として追加する方式が適する。
既存の `just us` は `nix flake update` と `nh darwin switch` を連続実行するため、input の revision 更新と実環境への反映を一つの経路にまとめられる。

CLI は `${inputs.cclens.packages.${system}.default}` から取得する。
plugin は同じ input の `plugins/cclens` を Claude Code の `--plugin-dir` へ渡す。
ローカル CLI の help では `--plugin-dir` を repeatable なセッション限定 plugin 読込として定義しているため、Nix 管理する `claude` wrapper が毎回この引数を付ければ常時利用できる。
CLI と plugin が同じ Nix store 上の source を参照し、Claude marketplace の checkout と版が分かれない。

input URL を `github:lambdalisue/cclens` にすると `flake.lock` が通常時の revision を固定し、`nix flake update` が upstream の default branch を更新する。
これは最新の release tag だけを追う仕組みではなく、default branch の commit を追う仕組みである。
upstream は最新 release tag を Flake update だけで選ぶ alias を公開していないため、専用 updater を増やさず `just us` に統合するなら、この更新単位になる。

upstream Cachix を使うには、この dotfiles の Nix daemon 設定へ substituter と公開鍵を明示する。
cclens input の `nixConfig` は top-level flake の設定として自動適用されないためである。
また、cclens の `nixpkgs` をこの dotfiles の input へ `follows` させると upstream の cache derivation と一致しない可能性があるため、upstream lock graph を維持する。

公式 release archive を固定 hash derivation にする案は、依存 node と cache trust を増やさない点では小さい。
しかし version、URL、hash の更新が必要で、`nix flake update` だけでは新 release に追従しないため、確定した更新要件には合わない。
Homebrew formula も Nix の更新経路と分かれるため採用しない。
