# `nixos-unstable` と `nixpkgs-unstable` の比較

調査日：2026-08-24

対象：macOS 26、Apple Silicon（`aarch64-darwin`）で nix-darwin と Home Manager を使う構成。

## 結論

このリポジトリの root `nixpkgs` には、`nixpkgs-unstable` を使うほうが自然である。

Nix の公式 FAQ は、rolling channel について Linux では `nixos-unstable`、それ以外のプラットフォームでは `nixpkgs-unstable` を選ぶよう案内している。[Nix FAQ「Which channel branch should I use?」](https://nix.dev/concepts/faq.html#which-channel-branch-should-i-use)

nix-darwin の公式 README も、macOS の flake 例に `github:NixOS/nixpkgs/nixpkgs-unstable` を使い、`nix-darwin.inputs.nixpkgs.follows = "nixpkgs"` で同じ package set を使う形を示している。[nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md#step-1-creating-flakenix)

同 README は channel の説明でも Nixpkgs unstable を「default」と明記している。[nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md#channels)

nix-darwin と Home Manager 自身の flake も、既定の Nixpkgs input に `nixpkgs-unstable` を指定している。[nix-darwin `flake.nix`](https://github.com/nix-darwin/nix-darwin/blob/master/flake.nix#L3-L8) [Home Manager `flake.nix`](https://github.com/nix-community/home-manager/blob/master/flake.nix#L1-L4)

`nixos-unstable` が誤りという意味ではない。
Nixpkgs の公式マニュアルは両方を `master` から更新される rolling channel と説明しており、どちらも通常は `master` より数日遅れる。[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/#overview-of-nixpkgs)

ただし、`nixos-unstable` は NixOS のシステム評価を含む channel、`nixpkgs-unstable` は NixOS 以外で package set を使うための channel という役割分担がある。
したがって、Darwin の package set を root に置くこの構成では、公式の用途と一致する `nixpkgs-unstable` を選ぶ。

この切り替えだけでは、今回の Herdr の Rust docs ビルドは解消しない。
Herdr は現在も root から別の flake input として導入され、Rust toolchain と Zig を使って source build されているためである。[現行 `flake.nix`](../../nix/flake.nix#L27-L40) [現行 Home Manager package 定義](../../nix/nix-darwin/home-manager/packages/common.nix#L68-L74) [Herdr `flake.nix`](https://github.com/ogulcancelik/herdr/blob/d6dae88345d24b8e468f63faad6a09173d2cbeac/flake.nix#L1-L43) [Herdr `rust-toolchain.toml`](https://github.com/ogulcancelik/herdr/blob/d6dae88345d24b8e468f63faad6a09173d2cbeac/rust-toolchain.toml)

## channel の用途と更新条件

Nixpkgs の公式マニュアルは、NixOS 以外の利用者には `nixpkgs-unstable`、NixOS 利用者には `nixos-*` channel を一般的に使うと説明している。[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/#overview-of-nixpkgs)

公式の Nixpkgs contributing guide では、`master` が `nixos-unstable`、`nixos-unstable-small`、`nixpkgs-unstable` の基礎になり、Hydra が評価とビルドを行い、ジョブが成功したときに公式 channel が更新されると定義している。[Nixpkgs CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#flow-of-merged-pull-requests)

両 channel の差は「別の package collection」ではなく、同じ Nixpkgs の異なる channel branch をどの時点で公開したかにある。
channel branch は公開済み channel と同じ commit に更新されるため、flake の `ref` はその channel の検証済みスナップショットを指す。[Nixpkgs CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#flow-of-merged-pull-requests)

Hydra の評価対象は同じではない。
Nixpkgs の package 側 release aggregate は `release-checks`、package、manual、Darwin 用の `aarch64-darwin` ジョブなどを含み、NixOS 側の release 定義は NixOS の設定と VM テストを含む。[Nixpkgs package release jobs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/release.nix#L1047-L1142) [NixOS release jobs](https://github.com/NixOS/nixpkgs/blob/master/nixos/release.nix)

この構成から、`nixos-unstable` は NixOS システムの整合性を検証する用途、`nixpkgs-unstable` は package 利用者向けの用途に重心があると判断できる。
これは channel の利用者区分と Hydra の release 定義を組み合わせた推論であり、個々の package が両 channel で同じビルド結果になることを保証するものではない。[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/#overview-of-nixpkgs) [Nixpkgs package release jobs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/release.nix#L1148-L1271) [NixOS release jobs](https://github.com/NixOS/nixpkgs/blob/master/nixos/release.nix)

## 更新頻度と 2026-08-24 時点の遅延

公式マニュアルは、両 rolling channel が `master` を追い、通常は `master` より数日遅れると説明している。[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/#overview-of-nixpkgs)

channel の公開ページから、調査時点の状態を確認した。

| ref | channel に公開された commit | channel 公開時刻 | Hydra evaluation |
| --- | --- | --- | --- |
| `nixos-unstable` | `2c423e03bbafcff28bfadc6781a4a8257f205cb5` | 2026-08-22 15:12 UTC | [1828337](https://hydra.nixos.org/eval/1828337) |
| `nixpkgs-unstable` | `a831408e6378bc02ebf8cc09b52c96ca86f6bab4` | 2026-08-23 08:21 UTC | [1828338](https://hydra.nixos.org/eval/1828338) |
| `master` | `64b7af55c5adecff92379d9f7d4b36d36848181d` | 2026-08-24 02:17 UTC の commit | なし |

出典は channel の公開ページ、GitHub の branch API、各 channel の GitHub 比較である。[`nixos-unstable` channel](https://channels.nixos.org/nixos-unstable) [`nixpkgs-unstable` channel](https://channels.nixos.org/nixpkgs-unstable) [`master` branch](https://github.com/NixOS/nixpkgs/tree/master) [`nixos-unstable` と `master` の比較](https://github.com/NixOS/nixpkgs/compare/nixos-unstable...master) [`nixpkgs-unstable` と `master` の比較](https://github.com/NixOS/nixpkgs/compare/nixpkgs-unstable...master) [`nixos-unstable` と `nixpkgs-unstable` の比較](https://github.com/NixOS/nixpkgs/compare/nixos-unstable...nixpkgs-unstable)

この時点では `nixpkgs-unstable` が `nixos-unstable` より 4 commit 先に進んでいる。
両 channel の先頭 commit はいずれも 2026-08-22 に作られており、`master` の 2026-08-24 の先頭 commit から見ると、公式マニュアルがいう「数日遅れ」の範囲にある。[`nixos-unstable` channel](https://channels.nixos.org/nixos-unstable) [`nixpkgs-unstable` channel](https://channels.nixos.org/nixpkgs-unstable) [`nixos-unstable` と `nixpkgs-unstable` の比較](https://github.com/NixOS/nixpkgs/compare/nixos-unstable...nixpkgs-unstable)

更新時刻は固定間隔ではない。
Hydra が必要な評価とビルドを終えた channel から公開するため、調査時点でも `nixos-unstable` と `nixpkgs-unstable` の公開時刻には約 17 時間の差がある。[Nixpkgs CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#flow-of-merged-pull-requests) [`nixos-unstable` channel](https://channels.nixos.org/nixos-unstable) [`nixpkgs-unstable` channel](https://channels.nixos.org/nixpkgs-unstable)

公式 status page が使う Prometheus の `channel_update_time` を 2026-08-24 02:55 UTC に集計すると、直近 30 日の更新回数は `nixos-unstable` が 17 回、`nixpkgs-unstable` が 37 回だった。
直近 90 日ではそれぞれ 32 回と 94 回である。
これは commit 数ではなく、channel の公開時刻が変化した回数であり、更新間隔が一定ではないことも示す。[NixOS Status の metric 実装](https://status.nixos.org/js/status.js) [`nixos-unstable` 30 日](https://prometheus.nixos.org/api/v1/query?query=changes%28channel_update_time%7Bchannel%3D%22nixos-unstable%22%7D%5B30d%5D%29) [`nixos-unstable` 90 日](https://prometheus.nixos.org/api/v1/query?query=changes%28channel_update_time%7Bchannel%3D%22nixos-unstable%22%7D%5B90d%5D%29) [`nixpkgs-unstable` 30 日](https://prometheus.nixos.org/api/v1/query?query=changes%28channel_update_time%7Bchannel%3D%22nixpkgs-unstable%22%7D%5B30d%5D%29) [`nixpkgs-unstable` 90 日](https://prometheus.nixos.org/api/v1/query?query=changes%28channel_update_time%7Bchannel%3D%22nixpkgs-unstable%22%7D%5B90d%5D%29)

## `aarch64-darwin` の Hydra と binary cache

Nixpkgs の公式マニュアルは、Hydra が `x86_64-linux`、`aarch64-linux`、`x86_64-darwin`、`aarch64-darwin` 向けに binary package を作り、`cache.nixos.org` で配布すると説明している。[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/#overview-of-nixpkgs)

Darwin のサポートは「channel に含まれるすべての package が必ず cache にある」という意味ではない。
package の `meta.hydraPlatforms` で Hydra の対象 platform を選べるうえ、Hydra の Nixpkgs unstable aggregate も `aarch64-darwin` の代表的な job を構成している。[Nixpkgs `hydraPlatforms` reference](https://nixos.org/manual/nixpkgs/unstable/#sec-meta-attributes) [Nixpkgs package release jobs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/release.nix#L1221-L1271)

調査時点の実ジョブでも、`herdr.aarch64-darwin` は 0.8.0 の成功済み build を持つ一方、0.8.2 はキュー待ちだった。[Hydra `herdr.aarch64-darwin`](https://hydra.nixos.org/job/nixpkgs/unstable/herdr.aarch64-darwin) [成功した Herdr 0.8.0 の build](https://hydra.nixos.org/build/341758169) [キュー待ちの Herdr 0.8.2](https://hydra.nixos.org/build/343046249)

成功した Herdr 0.8.0 の output `/nix/store/24jh6wfc6wlgcwnrm4ynq93j2ad5v98j-herdr-0.8.0` は `cache.nixos.org` の narinfo を持つが、キュー待ちの 0.8.2 の output `/nix/store/19s5rcl9c4la3804kwj02smf1r61qfzm-herdr-0.8.2` は調査時点で narinfo が存在しなかった。[Herdr 0.8.0 narinfo](https://cache.nixos.org/24jh6wfc6wlgcwnrm4ynq93j2ad5v98j.narinfo) [Herdr 0.8.2 narinfo の確認先](https://cache.nixos.org/19s5rcl9c4la3804kwj02smf1r61qfzm.narinfo)

`mise` については、Hydra の aarch64-darwin build で 2026.8.6 が成功し、対応する output は cache に存在する。
一方、より新しい評価では `usage` 依存の失敗により同じ version の別 output が失敗しているため、version が channel に存在することと、現在の derivation が cache hit することは別である。[Hydra `mise.aarch64-darwin`](https://hydra.nixos.org/job/nixpkgs/unstable/mise.aarch64-darwin) [成功した mise 2026.8.6 の build](https://hydra.nixos.org/build/342457058) [成功 output の narinfo](https://cache.nixos.org/w7nmmbynfpc45i2sjjqrw5aqbch820vz.narinfo) [依存失敗の build](https://hydra.nixos.org/build/342955572)

したがって、channel 選択で得られるのは「Hydra が作った標準 derivation を cache から取得しやすい」状態であり、overlay、override、外部 flake package、Hydra のキュー待ちや失敗まで解消するものではない。[Nixpkgs README](https://github.com/NixOS/nixpkgs#continuous-integration-and-distribution) [Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/#overview-of-nixpkgs)

## 現行リポジトリとの対応

現行の root input は `github:nixos/nixpkgs?ref=nixos-unstable` で、評価対象の system は `aarch64-darwin` である。[現行 `flake.nix`](../../nix/flake.nix#L4-L53)

`nix-darwin` と Home Manager は root `nixpkgs` に `follows` し、Home Manager は `useGlobalPkgs = true` で system 側の `pkgs` を使う。
そのため root channel を変更すると、nix-darwin と Home Manager が評価する package set もまとめて変わる。[現行 `flake.nix`](../../nix/flake.nix#L6-L13) [現行 Home Manager 設定](../../nix/nix-darwin/home-manager/default.nix#L7-L10) [Home Manager Flakes manual](https://nix-community.github.io/home-manager/nix-flakes.html#nixpkgs)

共通 package には root `pkgs` の `mise` と `neovim` が入り、Herdr だけは `inputs.herdr.packages.${system}.default` から別に入っている。[現行 package 定義](../../nix/nix-darwin/home-manager/packages/common.nix#L19-L74)

更新運用は `just update` が `nix flake update`、`just switch` が `nh darwin switch`、`just update-and-switch` がその二つの連続実行になっている。[現行 `justfile`](../../justfile#L6-L35)
日常の switch は input 更新を含まない `just s`、依存更新を意図するときだけ `just us` を使う設計である。

現行 lock では、`nodes.root.inputs.nixpkgs` が `nixpkgs_2` を指し、その node は `2c423e03bbafcff28bfadc6781a4a8257f205cb5` に固定されている。[現行 `flake.lock`](../../nix/flake.lock)
これは調査時点の `nixos-unstable` と同じ commit である。[`nixos-unstable` channel](https://channels.nixos.org/nixos-unstable)

2026-08-24 時点の両 unstable channel では、`mise` は 2026.8.6、Neovim は 0.12.4 である。[`nixos-unstable` の mise](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/mi/mise/package.nix#L24-L30) [`nixpkgs-unstable` の mise](https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/mi/mise/package.nix#L24-L30) [`nixos-unstable` の Neovim](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ne/neovim-unwrapped/package.nix#L107-L115) [`nixpkgs-unstable` の Neovim](https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/ne/neovim-unwrapped/package.nix#L107-L115)

Herdr は差が異なる。
両 unstable channel の Nixpkgs package は 0.8.0 だが、`master` には 0.8.2 が入っている。[`nixos-unstable` の Herdr](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/he/herdr/package.nix#L14-L22) [`nixpkgs-unstable` の Herdr](https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/he/herdr/package.nix#L14-L22) [`master` の Herdr](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/he/herdr/package.nix#L14-L22)

ただし現行構成が使っている Herdr は Nixpkgs の `pkgs.herdr` ではなく、外部 input の Herdr 0.8.2 である。[現行 `flake.nix`](../../nix/flake.nix#L27-L31) [現行 package 定義](../../nix/nix-darwin/home-manager/packages/common.nix#L72-L74) [Herdr `Cargo.toml`](https://github.com/ogulcancelik/herdr/blob/d6dae88345d24b8e468f63faad6a09173d2cbeac/Cargo.toml#L1-L4)

外部 Herdr の flake は `nixos-unstable` を初期値にしているが、現行 root flake が `inputs.nixpkgs.follows = "nixpkgs"` を設定しているため、実際には root の pinned Nixpkgs を受け取る。[Herdr `flake.nix`](https://github.com/ogulcancelik/herdr/blob/d6dae88345d24b8e468f63faad6a09173d2cbeac/flake.nix#L4-L18) [現行 `flake.nix`](../../nix/flake.nix#L27-L31)

Herdr の `rust-toolchain.toml` は Rust 1.96.1 と `clippy`、`rustfmt` を指定するが `profile` を指定していない。
Nix package は `rustPlatform.buildRustPackage` と Zig 0.15 を使うため、root channel を `nixos-unstable` から `nixpkgs-unstable` に変えても、Rust docs を含む toolchain 選択そのものは変わらない。[Herdr `rust-toolchain.toml`](https://github.com/ogulcancelik/herdr/blob/d6dae88345d24b8e468f63faad6a09173d2cbeac/rust-toolchain.toml) [Herdr Nix package](https://github.com/ogulcancelik/herdr/blob/d6dae88345d24b8e468f63faad6a09173d2cbeac/nix/package.nix#L36-L74)

## nix-darwin と Home Manager の互換性

nix-darwin の公式 macOS flake 例は、rolling では `nixpkgs-unstable`、stable では `nixpkgs-26.05-darwin` を使い、nix-darwin 自身も対応する branch に合わせる。[nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md#step-1-creating-flakenix)

Home Manager の公式 manual は、unstable の `nixpkgs-unstable` または `nixos-unstable` には Home Manager の `master`、stable の Nixpkgs には対応する `release-<version>` を使うよう指定している。[Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html#understanding-home-manager-versioning)

現行 Home Manager input は branch を明示していないため default の `master` を使い、root `nixpkgs` に follows している。
どちらの unstable channel を選んでも、Home Manager の branch 方針は変わらない。[現行 `flake.nix`](../../nix/flake.nix#L10-L13) [Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html#flake-based-installation)

stable へ移す場合は `nixpkgs-26.05-darwin`、nix-darwin `nix-darwin-26.05`、Home Manager `release-26.05` を同じ世代に揃える必要がある。
`home.stateVersion = "24.11"` は input の世代とは別で、Home Manager manual は既存の state version を維持するよう説明している。[`nixpkgs-26.05-darwin` channel](https://channels.nixos.org/nixpkgs-26.05-darwin) [nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md#step-1-creating-flakenix) [Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html#state-version-management) [現行 Home Manager 設定](../../nix/nix-darwin/home-manager/default.nix#L18-L30)

## 選択肢の比較

| 選択肢 | 適合度 | 得られるもの | この構成での注意 |
| --- | --- | --- | --- |
| `nixpkgs-unstable` | 高い | macOS 向けの公式推奨、Hydra の Darwin package cache、rolling 更新 | 更新のたびに package set 全体が動く。Hydra の個別 job が失敗または待機中なら cache miss になる |
| `nixos-unstable` | 利用可能だが優先度は低い | NixOS channel と共通の snapshot、NixOS 側の検証 | Darwin の root package set として公式 FAQ の推奨対象ではなく、調査時点で `nixpkgs-unstable` より 4 commit 遅い |
| `nixpkgs-26.05-darwin` | 安定性を優先する場合 | 保守的な更新、Darwin package の事前ビルド、cache | mise などの更新が遅く、nix-darwin と Home Manager も 26.05 系に揃える必要がある |
| root を stable にして別 input で unstable package を選ぶ | 条件付き | system の安定性と、選択した CLI の新しさを分けられる | package set が複数になり、評価、依存、overlay、runtime ABI の切り分けが増える |

stable channel は原則として security fix と保守的な bug fix を受け、半年ごとに新しい release が作られる。
macOS では `nixpkgs-*-darwin` が package の事前ビルド対象である。[Nix FAQ](https://nix.dev/concepts/faq.html#which-channel-branch-should-i-use) [`nixpkgs-26.05-darwin` channel](https://channels.nixos.org/nixpkgs-26.05-darwin)

調査時点の `nixpkgs-26.05-darwin` は `mise` 2026.5.12、Neovim 0.12.4 で、Herdr の Nixpkgs package は存在しない。
現行 root lock と両 unstable channel の `mise` は 2026.8.6 で、stable channel の 2026.5.12 より新しい。[stable mise package](https://github.com/NixOS/nixpkgs/blob/nixpkgs-26.05-darwin/pkgs/by-name/mi/mise/package.nix#L24-L30) [stable Neovim package](https://github.com/NixOS/nixpkgs/blob/nixpkgs-26.05-darwin/pkgs/by-name/ne/neovim-unwrapped/package.nix#L107-L115) [stable branch の package tree](https://github.com/NixOS/nixpkgs/tree/nixpkgs-26.05-darwin/pkgs/by-name/he) [`nixos-unstable` の mise](https://github.com/NixOS/nixpkgs/blob/2c423e03bbafcff28bfadc6781a4a8257f205cb5/pkgs/by-name/mi/mise/package.nix#L24-L30) [`nixpkgs-unstable` の mise](https://github.com/NixOS/nixpkgs/blob/a831408e6378bc02ebf8cc09b52c96ca86f6bab4/pkgs/by-name/mi/mise/package.nix#L24-L30)

複数 input 自体は Flakes の標準機能である。
公式の nix.dev は `follows` で依存の Nixpkgs を揃えられる一方、分けたままにすると同じ依存の複数 version、古い依存、未使用 input の eager fetch が起こりうると説明している。[nix.dev Flakes dependency management](https://nix.dev/concepts/flakes.html#dependency-management)

このリポジトリでは common package の大半を root `pkgs` から一括しているため、stable root と unstable package の混在は、特定 CLI だけに限定する場合に有効である。
Herdr、mise、Neovim、開発用ライブラリをまとめて新しくしたい現状では、package set を二つに分けるより `nixpkgs-unstable` を root に選び、Home Manager と nix-darwin の input を同じ世代に揃えるほうが管理量が少ない。[現行 package 定義](../../nix/nix-darwin/home-manager/packages/common.nix#L19-L81) [nix.dev Flakes dependency management](https://nix.dev/concepts/flakes.html#dependency-management)

## 最終判断

1. root `nixpkgs` は `github:NixOS/nixpkgs/nixpkgs-unstable` を第一候補にする。
2. Home Manager は `master`、nix-darwin は rolling 用の `master` として同じ root Nixpkgs に follows させる。[Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html#understanding-home-manager-versioning) [nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md#step-1-creating-flakenix)
3. 毎日の反映と input 更新を分ける現行運用を維持し、`just s` と `just us` を使い分ける。[現行 `justfile`](../../justfile#L12-L35)
4. Herdr の Rust docs ビルド短縮は channel 選択とは別の問題として扱う。
`nixpkgs-unstable` の Herdr 0.8.0 は cache 済みだが、現行外部 Herdr 0.8.2 は Hydra で queue 待ちであり、root channel を変えただけでは外部 package の source build は標準 package cache に置き換わらない。[Hydra Herdr job](https://hydra.nixos.org/job/nixpkgs/unstable/herdr.aarch64-darwin) [現行 package 定義](../../nix/nix-darwin/home-manager/packages/common.nix#L72-L74)

以上から、`nixos-unstable` を維持する理由はこの Darwin 構成には見つからない。
今後 NixOS 用の system module と package set を同じ input で管理する必要が生じた場合だけ、`nixos-unstable` を再検討する。
