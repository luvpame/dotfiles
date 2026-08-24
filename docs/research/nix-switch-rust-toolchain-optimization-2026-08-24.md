# Herdr の Nix switch コールドビルドを短縮する設計調査

調査日：2026-08-24

対象は、Herdr を Home Manager の `home.packages` から配布し続けたまま、macOS の `darwin switch` で Rust toolchain と Herdr のソースビルドが再発する時間を短縮する方法である。

この文書は調査だけを行った記録であり、設定変更、ビルド、switch、プロセス操作は実行していない。

## 結論

最もよい着地は、現在の `inputs.herdr.packages.${system}.default` を **nixpkgs 標準の `pkgs.herdr`** へ置き換え、`herdr` と `rust-overlay` の flake input を削除する方法である。

この方法なら、Herdr を引き続き Nix store と Home Manager で管理しながら、通常は `cache.nixos.org` の substitute を使える。

現在ロックしている nixpkgs の `pkgs.herdr` は v0.8.0 で、その aarch64-darwin output が `cache.nixos.org` に存在することを確認した。

nixpkgs master には v0.8.2 への更新が 2026-08-22 にマージ済みで、PR では aarch64-darwin のビルドも確認されている。
[nixpkgs PR #554861](https://github.com/NixOS/nixpkgs/pull/554861) と [現行 package 定義](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/he/herdr/package.nix) が根拠である。

ただし、調査時点の `nixos-unstable` は commit `2c423e03bbafcff28bfadc6781a4a8257f205cb5` で、v0.8.2 を取り込んだ merge commit より179コミット手前にいる。
今すぐ `pkgs.herdr` へ切り替えると v0.8.0へ下がるため、nixos-unstable に v0.8.2 が流れてから変更するのが安全である。

`pkgs.herdr` の derivation は nixpkgs の `rustPlatform` を使い、確認した aarch64-darwin closure には `rust-docs` が入っていなかった。
cache miss 時には Herdr の source build が残るものの、今回問題になった rust-overlay の `rust-default` profile は通らない。

公式の [herdr-nix](https://github.com/herdrdev/herdr-nix) も、release binary を固定ハッシュで包装し、`herdr.cachix.org` から配るため、設計としては有力である。
しかし、調査時点の main は v0.8.0 のままで、v0.8.2 公開後も自動更新 workflow が動いていないため、現時点では nixpkgs より追随状況が悪い。

すぐに v0.8.2 が必要で source build を消したい場合は、C の固定ハッシュ package または Homebrew bottle が暫定案になる。
単一ホストのために新しい Cachix と macOS CI を自前運用する E は、nixpkgs と公式 herdr-nix の配布経路がある現在では過剰である。

`profile = "minimal"`、GC policy、`max-jobs` の調整は、いずれも標準 package と公式 cache を使う変更より効果が狭い。

したがって、推奨順序は次のとおりである。

1. nixos-unstable が Herdr v0.8.2 を取り込むまで、現在の v0.8.2 を維持する。
2. 取り込み後、package と launchd の PATH を `pkgs.herdr` に統一し、`herdr` と `rust-overlay` の flake input を削除する。
3. 日常は `just switch` を使い、`just us` は input 更新時だけ実行する。
4. Homebrew の `autoUpdate` と `upgrade` は、switch 全体の短縮策として別の変更で分離する。

この構成なら、自前 package、自前 cache、upstream patch のいずれも保守せずに済む。

## nixpkgs 標準 package が本命になる理由

現在ロックしている nixpkgs は `pkgs.herdr` v0.8.0 を公開している。
その output `/nix/store/24jh6wfc6wlgcwnrm4ynq93j2ad5v98j-herdr-0.8.0` を `cache.nixos.org` へ問い合わせると有効な path として返ったため、少なくとも現在の aarch64-darwin package はローカルビルドを必要としない。

nixpkgs の Herdr package は安定版tagを `fetchFromGitHub` で取得し、nixpkgs標準の RustとZigでビルドする。
[package.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/he/herdr/package.nix) では、version、source hash、Cargo hash、Zig依存hashを固定している。

現行dotfilesはHerdr upstreamのmasterをflake inputとして追跡するため、Herdrのcommitが変わるたびに独自derivationが生まれる。
一方、`pkgs.herdr`はnixpkgsの更新単位へまとまり、Hydraが作った同じderivationを`cache.nixos.org`から取得できる。

移行後は、[packages/common.nix](../../nix/nix-darwin/home-manager/packages/common.nix) と [services/herdr.nix](../../nix/nix-darwin/home-manager/services/herdr.nix) の両方で `pkgs.herdr` を参照する。
どちらか一方だけを変えると、古いupstream packageがlaunchdのPATHから依存に残る。

この方法にもversionの遅延はある。
nixpkgs masterへ更新がマージされてからnixos-unstableへ流れ、さらにbinary cacheが利用可能になるまで待つ必要がある。
今回のv0.8.2はすでにmasterへマージされているため、新しいpackage設計を作るより、その反映を待つほうが保守範囲を増やさない。

## 現行構成と upstream の状態

### リポジトリ側の経路

現行の flake は `herdr` input を `github:ogulcancelik/herdr` の branch 参照で宣言し、`inputs.herdr.packages.${system}.default` を Home Manager の共通 package に追加している。
[flake input](../../nix/flake.nix) と [Herdr の package 宣言](../../nix/nix-darwin/home-manager/packages/common.nix) がこの経路を定義する。

`just us` は `nix flake update` の直後に `nh darwin switch` を実行するため、Herdr だけでなく全 input の更新によって新しい derivation が発生し得る。
[justfile](../../justfile) では `update-and-switch: update switch` として定義されている。

`just switch` は更新を行わず、lock 済みの入力で system を実現する。
日常の反映と input 更新を別の操作に分けられるため、これは設定を変えずに利用できる最初の短縮策である。

現行の Nix core 設定は `keep-derivations = true`、自動 GC の `--delete-older-than 30d`、空き容量の閾値 `min-free = 10 GiB` と `max-free = 20 GiB` を持つが、`keep-outputs` は宣言していない。
[nix-core.nix](../../nix/nix-darwin/nix-core.nix) にその値がある。

Homebrew の activation は `autoUpdate = true`、`upgrade = true`、`cleanup = "zap"` になっている。
[Homebrew 設定](../../nix/nix-darwin/homebrew/common.nix) のこの設定は、Herdr の Rust build とは別に、switch 中の Homebrew 更新、upgrade、cleanup を発生させ得る。

### Herdr v0.8.2

調査時点の公式最新 stable release は v0.8.2 で、2026-08-19 に公開されている。
[公式 release](https://github.com/herdrdev/herdr/releases/latest) は v0.8.2 を `Latest` として示し、公式の [latest manifest](https://raw.githubusercontent.com/herdrdev/herdr/master/website/latest.json) も version `0.8.2` を示す。

v0.8.2 の release pipeline は Linux と macOS の各 target 用に `herdr-macos-aarch64` を含む binary asset を作る。
[release workflow](https://github.com/herdrdev/herdr/blob/v0.8.2/.github/workflows/release.yml#L35-L66) が target と asset 名を定義し、[artifact の package step](https://github.com/herdrdev/herdr/blob/v0.8.2/.github/workflows/release.yml#L139-L167) が binary を upload する。

v0.8.2 の aarch64-darwin binary は、公式 manifest に次の URL と SHA-256 で記録されている。

```text
URL:
https://github.com/herdrdev/herdr/releases/download/v0.8.2/herdr-macos-aarch64

SHA-256:
a5d4f4d504d8b309c91f811050559300faba31258425f53c50852fc96f6ae574
```

[公式 manifest の assets と hash](https://raw.githubusercontent.com/herdrdev/herdr/master/website/latest.json#L31-L44) が根拠である。

一方、公式 Nix flake は v0.8.2 でも `rustPlatform.buildRustPackage` を使い、vendored libghostty-vt と Cargo.lock を入力にして source build する。
[v0.8.2 の Nix package](https://github.com/herdrdev/herdr/blob/v0.8.2/nix/package.nix#L32-L75) は build-only の `doCheck = false` を指定するが、コンパイル自体は省略していない。

公式 Nix workflow は `nix flake check` を実行するだけで、Cachix への push は行っていない。
[Nix workflow](https://github.com/herdrdev/herdr/blob/master/.github/workflows/nix.yml#L35-L55) と [release workflow](https://github.com/herdrdev/herdr/blob/master/.github/workflows/release.yml#L14-L34) に cache push の step はない。

upstream の Discussion でも、Nix install は full Rust と Zig toolchain を引き込み、binary cache がないため consumer ごとに source build が繰り返されると説明されている。
[Herdr Discussion #1249](https://github.com/herdrdev/herdr/discussions/1249#L147-L159) では、release binary を hash-verified fetch derivation で包装して Cachix に push する案が提案されているが、公式 flake に採用された状態ではない。

## Rust docs が入る仕組み

v0.8.2 の `rust-toolchain.toml` は channel と `clippy`、`rustfmt` だけを指定し、profile を指定していない。
[v0.8.2 の rust-toolchain.toml](https://raw.githubusercontent.com/herdrdev/herdr/v0.8.2/rust-toolchain.toml) がその内容を示す。

Herdr の flake は package 用に `rust-bin.fromRustupToolchainFile ./rust-toolchain.toml` を呼び、devShell 用には同じ toolchain へ `rust-src` と `rust-analyzer` を追加している。
[v0.8.2 の flake](https://raw.githubusercontent.com/herdrdev/herdr/v0.8.2/flake.nix#L31-L46) と [devShell の定義](https://raw.githubusercontent.com/herdrdev/herdr/v0.8.2/flake.nix#L76-L93) が build と dev の関係を示す。

rust-overlay の `fromRustupToolchainFile` は profile が null の場合に `default` を選び、toolchain file の components を追加する。
[rust-overlay の実装](https://github.com/oxalica/rust-overlay/blob/master/lib/rust-bin.nix#L121-L168) にその処理がある。

Rustup の公式仕様では、`minimal` は rustc、rust-std、cargo だけを含み、`default` はそれに rust-docs、rustfmt、clippy を加える。
[rustup Profiles](https://rust-lang.github.io/rustup/concepts/profiles.html#profiles) が profile の構成を定義する。

したがって、添付画面の `rust-docs-1.96.1` は Herdr が `cargo doc` を実行しているという意味ではなく、profile 未指定を rust-overlay が default と解釈し、toolchain の rust-docs component を store に実現している状態である。

`profile = "minimal"` にして `clippy` と `rustfmt` を components として残せば、package build に必要な lint と formatter を保ったまま rust-docs を外せる。
Rustup の toolchain file は profile と追加 components を別々に指定でき、components は profile に加算される。[rustup toolchain file](https://rust-lang.github.io/rustup/overrides.html#the-toolchain-file) がこの仕様を定義する。

## 候補の比較

| 候補 | コールド switch | 再現性 | 保守性と更新体験 | セキュリティ | 判断 |
| --- | --- | --- | --- | --- | --- |
| A. local minimal override | rust-docs の取得を減らすが Cargo と Zig の source build は残る | local patch と lock が必要 | upstream 更新のたびに patch の再適用を確認する | source と lock をレビューできる | 短期の軽減策。単独では不十分 |
| B. upstream build/dev 分離 | A と同じく toolchain closure は小さくなるが source build は残る | upstream source と lock を使える | local fork より良いが upstream の採用待ち | source build の検証を維持できる | upstream へ返す長期改善 |
| C. release binary の fixed-output derivation | binary download と小さな install だけになり、source build を避けられる | release URL と SHA-256 を lock 付きで固定できる | version と hash の更新だけが必要 | hash は改変と破損を検出するが、upstream binary の署名とは別の trust boundary | 第一候補 |
| D. Homebrew bottle | matching bottle があれば高速 | Homebrew の formula と bottle に依存する | Homebrew の更新周期と activation に従う | Nix とは別の package trust を使う | Nix 管理を維持する条件には不適 |
| E. Cachix と CI | cache hit なら実質 download、miss は CI で一度だけ build | 同じ lock と derivation を配布できる | workflow、secret、cache key の運用が必要 | cache の公開鍵と CI secret を厳格に管理する | C と組み合わせる |
| F. GC と keep-outputs | 過去 derivation の再利用には効く可能性があるが、初回 build は変わらない | derivation の内容は変えない | disk usage と rollback policy の調整が必要 | stale output を残すだけで供給元の検証にはならない | 補助策 |
| G. pin と update 分離 | 不要な input 更新による cache miss を減らす | lock と release tag で更新境界を明示できる | 更新は明示的で、rollback しやすい | 未レビューの master を取り込む頻度を下げる | 必須の運用改善 |
| H. nixpkgs の `pkgs.herdr` | cache hit なら `cache.nixos.org` から取得するだけ | nixpkgs lock、source hash、Cargo hash、Zig hashで固定 | 独自input、package、cacheを保守しない | nixpkgsのレビューと公式cacheの信頼境界へ統合できる | 第一候補。v0.8.2がnixos-unstableへ入るまで待つ |
| I. 公式 `herdr-nix` | release binaryを取得するだけでtoolchain不要 | asset hashとflake lockで固定 | 現在v0.8.0で自動更新が止まっている | Herdr公式repoとCachix公開鍵を信頼する | 設計はよいが、追随再開まで保留 |

## 各候補の評価

### A. local override で minimal profile を選ぶ

最小変更は、Herdr の toolchain file に `profile = "minimal"` を加え、既存の `clippy` と `rustfmt` を追加 component として残す方法である。

この変更は rust-docs を外す根拠が明確である。
rustup の公式 profile 定義と rust-overlay の profile 解決実装が、default から minimal への差を明示している。[rustup Profiles](https://rust-lang.github.io/rustup/concepts/profiles.html#profiles) [rust-overlay source](https://github.com/oxalica/rust-overlay/blob/master/lib/rust-bin.nix#L141-L156)

ただし、現行の Home Manager は upstream flake の完成済み package を直接参照している。
profile だけを安全に差し替えるには、upstream source を patch して評価するか、Herdr package を local で再定義する必要がある。

その local derivation は upstream の derivation と異なるため、公式 Nix binary cache に同一 output があるとは限らない。
Nix は derivation と store object の一致を前提に substitute を選ぶため、profile を変えただけでも Herdr 本体の source build が残る。[Nix binary cache](https://nix.dev/guides/recipes/add-binary-cache.html)

A は大きな rust-docs component と多数のファイル展開を避ける用途には適するが、今回の長時間化を生む Cargo と Zig のコンパイルを解決しない。

### B. upstream で build toolchain と dev toolchain を分離する

upstream はすでに、package 用の `rustToolchainFor` と devShell 用の `rustDevToolchainFor` を別の関数にしている。
devShell だけが `rust-src` と `rust-analyzer` を追加するため、dev toolchain の不要な拡張を package build に持ち込まない設計はできている。[upstream flake](https://github.com/herdrdev/herdr/blob/v0.8.2/flake.nix#L31-L46)

不足しているのは、build と dev で profile の基礎を分けることではなく、共通の toolchain file に profile がない点である。
package build は共通 toolchain に `clippy` と `rustfmt` を追加し、devShell はそこへ `rust-src` と `rust-analyzer` を追加するため、まず upstream の toolchain file を minimal にするのが自然である。

この変更を upstream に返せれば local patch を維持せずに済む。
しかし、profile を minimal にしても Herdr package は `buildRustPackage` で Cargo と Zig を実行するため、source build の時間は残る。[upstream package](https://github.com/herdrdev/herdr/blob/v0.8.2/nix/package.nix#L32-L75)

B は再現性と保守性の面では A より良いが、switch 時間の主要な上限を取り除く方法ではない。
upstream が公式 Nix binary cache を提供するまでの fallback と位置づける。

### C. release binary を fixed-output derivation で包装する

Herdr は aarch64-darwin 用の完成 binary を公式 release に添付している。
v0.8.2 については、asset URL と SHA-256 が公式 manifest に固定されている。[release assets](https://github.com/herdrdev/herdr/blob/v0.8.2/.github/workflows/release.yml#L35-L66) [latest manifest](https://raw.githubusercontent.com/herdrdev/herdr/master/website/latest.json#L31-L44)

local Nix package は、この binary を `fetchurl` で取得し、`$out/bin/herdr` に install するだけの derivation にできる。
Nix の fixed-output derivation は、builder 完了後の output hash が宣言値と一致しなければ失敗し、`fetchurl` は URL の内容を hash で検証する。[Nix fixed-output derivation](https://nix.dev/manual/nix/2.22/language/advanced-attributes.html#fixed-output-derivations) [Nix content-addressing](https://nix.dev/manual/nix/2.35/store/derivation/outputs/content-address.html#fixed-output-content-addressing)

この構成では、Nix が管理するものは source checkout と build toolchain ではなく、version、release URL、hash、install path になる。
そのため、cache miss でも Rust、Zig、Cargo vendor、libghostty-vt の build input を実現する必要がなく、現在の source build を実行しない。

再現性は「同じ source から同じ binary を再ビルドできること」ではなく、「同じ hash の upstream binary bytes を取得すること」になる。
この違いを許容できる単一ホストの runtime package では、速度への効果が最も大きい。

セキュリティ上、v0.8.2 の release は binary asset を公開しているが、upstream の Discussion では checksums file、署名、GitHub artifact attestation がない状態が指摘されている。[Herdr Discussion #2506](https://github.com/herdrdev/herdr/discussions/2506#L135-L151)
したがって、local package に hash を commit するレビューは必要であり、manifest の hash を動的に評価する設計にはしない。

### D. Homebrew bottle を使う

Homebrew は Herdr v0.8.2 の stable formula と、Apple Silicon の Tahoe、Sequoia、Sonoma を含む bottle を公開している。[Homebrew formula API](https://formulae.brew.sh/api/formula/herdr.json) [formula source](https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/h/herdr.rb)

Homebrew の公式仕様では、現在の OS と architecture に対応する bottle が formula にあれば、`brew install` は source build ではなく bottle を download する。[Homebrew Bottles](https://github.com/Homebrew/brew/blob/main/docs/Bottles.md#usage)

したがって D は速度だけを見れば有力である。
しかし、Herdr の binary は Nix store path ではなく Homebrew prefix で管理され、Home Manager の Nix package と同じ再現性や rollback の単位ではない。

さらに現行リポジトリは Homebrew activation で auto-update と upgrade を有効にしているため、D を採用しても switch 中の Homebrew 更新時間は別に残る。[現行 Homebrew activation](../../nix/nix-darwin/homebrew/common.nix)

Herdr を Homebrew で管理してよい場合だけ、D は C の代替候補になる。
今回の条件では採用順位を下げる。

### E. Cachix または自前 CI で事前実現する

Nix の binary cache は `substituters` と `trusted-public-keys` で設定でき、Nix は署名された store object を取得できる。[nix.dev の binary cache 設定](https://nix.dev/guides/recipes/add-binary-cache.html)

Cachix の公式 Action は、cache から build input を pull し、job で新しく作った store path を push できる。[cachix-action](https://github.com/cachix/cachix-action#cachix-action) [Cachix push](https://docs.cachix.org/pushing#flakes)

運用は、保護された branch または tag の CI だけが Herdr derivation を build し、成功後に runtime closure を push する形がよい。
pull request では read-only cache と `skipPush` を使い、未レビューの workflow から write token を使わせない。

C を E と組み合わせる場合、CI は release binary を取得する小さな derivation を一度実現して Cachix に置く。
source build を CI に移す構成より、macOS runner の時間、Rust toolchain の closure、cache 容量を抑えやすい。

source build の再現性を優先する場合は、E 単独で upstream の `buildRustPackage` を native aarch64-darwin runner 上で実現して cache へ pushする方法もある。
この場合、local cache hit は速いが、cache miss 時の fallback は現在と同じく Cargo と Zig の長時間 build になる。

Cachix の公式説明は、cache の private key を持つ者が任意の store object を署名できることを警告している。[Nix custom binary cache の警告](https://nix.dev/guides/recipes/add-binary-cache.html#configure-nix-to-use-a-custom-binary-cache) [cachix-action の security](https://github.com/cachix/cachix-action#security)
したがって、cache URL と公開鍵を固定し、write token と signing key をローカルへ配布しない。

### F. GC と keep-outputs を調整する

Nix の `keep-outputs = true` は、まだ garbage ではない derivation の output を GC 後も保持し、開発中の再ビルドを速くし得る。[Nix garbage collection](https://nix.dev/manual/nix/2.33/package-management/garbage-collection#garbage-collection)

ただし、output が現行 generation や別の root から到達可能でない場合に、どの source build も無条件に保持する設定ではない。
Nix の設定仕様でも、`keep-outputs` は non-garbage derivation の output を保持する機能で、default は false とされている。[Nix `keep-outputs`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-keep-outputs)

現行は `keep-derivations = true` だが `keep-outputs` を指定していないため、過去 Herdr の build-time toolchain が GC 後に消える可能性はある。
一方、`keep-outputs` は disk usage を増やし、10 GiB の `min-free` による自動 GC とも競合し得る。[現行 Nix 設定](../../nix/nix-darwin/nix-core.nix) [Nix `min-free`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-min-free)

F は rollback を頻繁に行う開発機で限定的に有効だが、C または E の cache を置き換えない。

### G. flake input の pin と update を分ける

Nix は `flake.lock` に input を pin し、`nix flake update` は指定しなければ全 input を更新する。
反対に `nix flake lock` は既存 lock entry を更新せず、`--update-input` を指定した場合だけ対象 input を更新する。[Nix Flakes](https://nix.dev/concepts/flakes.html#what-are-flakes) [nix flake update](https://nix.dev/manual/nix/2.19/command-ref/new-cli/nix3-flake-update) [nix flake lock](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake-lock)

Herdr の公式 install docs も、通常利用では `master` を追跡せず release tag を使い、flake input の場合は `nix flake update herdr` で更新するよう案内している。[Herdr install docs](https://github.com/herdrdev/herdr/blob/master/docs/next/website/src/content/docs/install.mdx#install-with-nix)

現行の `just us` は全 input を更新してから switch するため、Herdr と無関係な input の変更でも system closure が変わり得る。
日常は `just switch`、更新時だけ `nix flake update herdr` または `nix flake lock --update-input herdr` とする運用が、再現性、rollback、cache hit の三つを同時に改善する。

Herdr を source build のまま使う場合は、少なくとも stable tag または release commit を input URL に記録する。
C を使う場合は binary version と SHA-256 を local package に記録し、Herdr source flake input は package build のために残さない設計も選べる。

## 推奨する導入順序

### 1. nixos-unstable の v0.8.2 を待つ

現在の `pkgs.herdr` は v0.8.0 なので、今すぐ切り替えると不具合修正を含む v0.8.2 からダウングレードする。

nixpkgs master への v0.8.2 マージは完了しているため、nixos-unstable がその commit を含むまで現在の Herdr package を維持する。

更新後は `pkgs.herdr.version` が `0.8.2` であることと、その output を `cache.nixos.org` から取得できることを変更前に確認する。

### 2. H の nixpkgs package へ統一する

Home Manager の package と launchd updater の PATH を、どちらも `pkgs.herdr` へ置き換える。

その後、flake から `herdr` と `rust-overlay` の input を削除する。

この変更で独自の Herdr source derivation と rust-overlay toolchain が system closure から消え、標準 cache を使える。

導入時には、`herdr --version`、既存 config、launchd agent、Claude と Codex の hook が同じ package path を参照することを確認する。

### 3. switch と update を分離する

`just switch` を日常の反映にし、`just us` は依存更新時だけ使う。

Herdr は nixpkgs の stable package として更新されるため、独立した master input を更新する必要はなくなる。

全 input の更新と system 反映を同じ操作に束ねないほうが、cache miss の原因と変更範囲を確認しやすい。

### 4. v0.8.2 が今すぐ必要なら C を使う

nixos-unstable の更新を待てない場合だけ、公式 v0.8.2 release binary を固定ハッシュの local Nix package で包装する。

この package は cache miss 時も binary を取得して install するだけなので、Rust と Zig の build へ戻らない。

公式 `herdr-nix` は同じ設計を実装しているが、v0.8.0 から更新されていないため、追随が再開するまでは直接使わない。

### 5. Homebrew activation と GC は別に見直す

Herdr の package 経路を短くしても、Homebrew の `autoUpdate`、`upgrade`、`zap` cleanup は switch の待ち時間に残り得る。

nix-darwin の公式 manual は、activation の `autoUpdate` と `upgrade` の既定値を false とし、反復 switch を idempotent にする理由を説明している。[nix-darwin Homebrew options](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.onActivation.autoUpdate)

Homebrew 更新を専用操作へ移すかは別の変更として測定し、Herdr の Nix package 移行と混ぜない。

GC は `pkgs.herdr` への移行効果を確認した後で、rollback の必要性と disk usage を見て `keep-outputs` を選ぶ。

## 最終判断

現在のリポジトリでは、nixos-unstable に v0.8.2 が入った時点で H へ移行するのが最もよい。

H は Herdr を Nix store で管理し、stable release を lock し、標準 cache を使いながら、独自の Herdr input と rust-overlay input を消せる。

それまでに即時対応が必要なら C を使う。
C は v0.8.2 の18 MiB前後の release binary を取得するだけで済み、自前 Cachix を追加しなくても source build より十分短い。

A と B は Rust docs を外せるが Herdr 本体の build を残し、F と `max-jobs` は再発や競合を調整するだけなので、H より先に採用する理由はない。

I は H と同じ方向の公式解決策だが、v0.8.2 への追随が止まっているため、workflow が再開した後に再評価する。

したがって、推奨順位は **HとG、即時の暫定策としてC、追随再開後のI、長期的なupstream改善としてB、補助策としてF、条件付き代替としてD** とする。

### 参照した一次情報

- [現行 flake](../../nix/flake.nix)
- [現行 Herdr package 宣言](../../nix/nix-darwin/home-manager/packages/common.nix)
- [現行 Nix core 設定](../../nix/nix-darwin/nix-core.nix)
- [現行 Homebrew activation](../../nix/nix-darwin/homebrew/common.nix)
- [現行 justfile](../../justfile)
- [Herdr v0.8.2 release](https://github.com/herdrdev/herdr/releases/tag/v0.8.2)
- [Herdr v0.8.2 flake](https://github.com/herdrdev/herdr/blob/v0.8.2/flake.nix)
- [Herdr v0.8.2 Nix package](https://github.com/herdrdev/herdr/blob/v0.8.2/nix/package.nix)
- [Herdr v0.8.2 release workflow](https://github.com/herdrdev/herdr/blob/v0.8.2/.github/workflows/release.yml)
- [Herdr latest manifest](https://raw.githubusercontent.com/herdrdev/herdr/master/website/latest.json)
- [Herdr Nix binary cache Discussion](https://github.com/herdrdev/herdr/discussions/1249)
- [Herdr release artifact verification Discussion](https://github.com/herdrdev/herdr/discussions/2506)
- [rust-overlay `rust-bin` implementation](https://github.com/oxalica/rust-overlay/blob/master/lib/rust-bin.nix)
- [rustup profiles](https://rust-lang.github.io/rustup/concepts/profiles.html)
- [rustup toolchain file](https://rust-lang.github.io/rustup/overrides.html#the-toolchain-file)
- [Nix fixed-output derivation](https://nix.dev/manual/nix/2.22/language/advanced-attributes.html#fixed-output-derivations)
- [Nix binary cache configuration](https://nix.dev/guides/recipes/add-binary-cache.html)
- [Nix garbage collection](https://nix.dev/manual/nix/2.33/package-management/garbage-collection)
- [Nix `keep-outputs`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-keep-outputs)
- [Nix flake update](https://nix.dev/manual/nix/2.19/command-ref/new-cli/nix3-flake-update)
- [nix-darwin Homebrew options](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.onActivation.autoUpdate)
- [Homebrew formula API for Herdr](https://formulae.brew.sh/api/formula/herdr.json)
- [Homebrew bottles](https://github.com/Homebrew/brew/blob/main/docs/Bottles.md)
- [Cachix Action](https://github.com/cachix/cachix-action)
- [Cachix push docs](https://docs.cachix.org/pushing)
- [nixpkgs Herdr package](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/he/herdr/package.nix)
- [nixpkgs Herdr v0.8.2 update PR](https://github.com/NixOS/nixpkgs/pull/554861)
- [公式 herdr-nix](https://github.com/herdrdev/herdr-nix)
