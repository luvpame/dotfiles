# mise の Nix ビルドが長時間化する理由

調査日：2026-08-04

## 結論

今回の長時間ビルドは、mise 自体に既知の性能退行があるからではなく、ローカル overlay が `cache.nixos.org` にある公式の mise derivation と異なる出力パスを作っているために起きている、と判断できる。

現行の nixpkgs 固定値 `643809054d65fdd466a63e3155b8c498cb483c04` は mise 2026.7.17 を収録している。
公式 derivation の aarch64-darwin 出力 `/nix/store/ylixplbpi7c6dl1kf9ymm9cii6pvg3ff-mise-2026.7.17` は `cache.nixos.org` にあり、実測では 40.3 MiB のダウンロード（展開後 133.3 MiB）で取得できる。
一方、overlay 適用後の出力 `/nix/store/wyzcqjjibvb9xcgj910fzfkldmp2plql-mise-2026.7.17` に対応する narinfo は HTTP 404 だった。

Nix は、入力アドレス方式の出力パスを「生成した derivation」から決める。
同じ内容を生成するとしても作り方が異なれば出力パスが変わるため、`doCheck` やビルド入力を変えた derivation は公式キャッシュの代替物と一致しない。[Nix Reference Manual: Input-addressing derivation outputs](https://nix.dev/manual/nix/2.32/store/derivation/outputs/input-address.html)
Nix は substituter に出力がなければ依存関係を実現して builder を実行する。[Nix Reference Manual: `nix-store --realise`](https://nix.dev/manual/nix/latest/command-ref/nix-store/realise.html)

したがって、flake 更新のたびに mise の版や Rust toolchain、依存 derivation のどれかが変わり、overlay 版の新しい出力が手元にない場合、巨大な Rust パッケージをソースから再構築する。

## 現在の derivation 差分

リポジトリの overlay は mise に次の変更を加えている。

```nix
mise = prev.mise.overrideAttrs (oldAttrs: {
  doCheck = false;
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.cmake ];
});
```

固定 nixpkgs の[公式パッケージ定義](https://github.com/NixOS/nixpkgs/blob/643809054d65fdd466a63e3155b8c498cb483c04/pkgs/by-name/mi/mise/package.nix)では、`cmake` は `nativeBuildInputs` ではなく `nativeCheckInputs` にある。
テストは `cargo test --all-features` 相当で実行され、Darwin 向けに二つの sandbox 非互換テストだけを除外し、ローカル HTTP mock server 用に `__darwinAllowLocalNetworking = true` を設定している。

nixpkgs の `mkDerivation` は `doCheck` が真のときだけ `nativeCheckInputs` を通常のネイティブ入力へ加える。[`make-derivation.nix`](https://github.com/NixOS/nixpkgs/blob/643809054d65fdd466a63e3155b8c498cb483c04/pkgs/stdenv/generic/make-derivation.nix#L539-L548)
それにもかかわらず現在の overlay は、`doCheck = false` でテストを止めたうえで `cmake` を通常ビルド入力へ移している。

実際に `nix derivation show` で比較すると、公式 derivation は `doCheck=1` で `cmake`、Git、bindgen hook を check 入力に持つ。
overlay 版は check 入力を持たず、`cmake` だけを通常ビルド入力に持つ。
この差だけでも別の derivation になる。

## direnv overlay も mise のキャッシュを外す

mise の公式パッケージ定義は `src/cli/direnv/exec.rs` を書き換え、実行する direnv の絶対 store path を Rust ソースへ埋め込む。[mise package `postPatch`](https://github.com/NixOS/nixpkgs/blob/643809054d65fdd466a63e3155b8c498cb483c04/pkgs/by-name/mi/mise/package.nix#L41-L59)

このリポジトリは direnv にも `doCheck = false` を設定している。
そのため、mise 自身の override だけを外しても、mise が参照する direnv は公式の `/nix/store/2rj4aby8shsbcbcllxk5j5giw25fk1c7-direnv-2.37.1` ではなく、overlay 版の `/nix/store/xv3jh7ds8jr5x8s1qi66a4kcwcp6l79k-direnv-2.37.1` になる。
前者の narinfo は `cache.nixos.org` にあり、後者は HTTP 404 だった。

mise の `postPatch` に埋め込む文字列が変わるため、direnv override は mise derivation の入力と生成物を変える。
公式 mise のキャッシュを使うには、mise の override だけでなく、参照先を変える direnv override も解消する必要がある。

## Rust ソースビルドの規模

nixpkgs は配布済みの mise バイナリを再包装せず、`rustPlatform.buildRustPackage` で GitHub のタグ付きソースと Cargo vendor 固定出力からビルドする。[mise package definition](https://github.com/NixOS/nixpkgs/blob/643809054d65fdd466a63e3155b8c498cb483c04/pkgs/by-name/mi/mise/package.nix#L22-L39)
`buildRustPackage` の標準 build hook は Cargo を release profile、offline、利用可能な Nix build core 数で実行する。[`cargo-build-hook.sh`](https://github.com/NixOS/nixpkgs/blob/643809054d65fdd466a63e3155b8c498cb483c04/pkgs/build-support/rust/hooks/cargo-build-hook.sh)

mise 2026.7.17 の `Cargo.lock` には 1,078 個の `[[package]]` がある。[mise 2026.7.17 `Cargo.lock`](https://github.com/jdx/mise/blob/v2026.7.17/Cargo.lock)
すべてが同じビルドでコンパイルされるわけではないが、手元のログでは 794 件の `Compiling` が出ている。
前回は unpack に 5分15秒、build に 8分25秒、今回の `just us` では Cargo 部分が 17分07秒かかり、同時に `rust-docs` もローカルビルドされていた。
公式キャッシュが使えない場合の所要時間として、この実測はパッケージ構成と矛盾しない。

## zlib-ng と CMake

mise 2026.7.17 は直接依存として `flate2 = "1"` を持ち、lockfile には `flate2`、`libz-ng-sys`、`aws-lc-sys` が含まれる。[mise `Cargo.toml`](https://github.com/jdx/mise/blob/v2026.7.17/Cargo.toml)、[mise `Cargo.lock`](https://github.com/jdx/mise/blob/v2026.7.17/Cargo.lock)
`libz-ng-sys` の所有元である libz-sys は、zlib-ng のビルドには実験的な no-cmake feature を使わない限り CMake が必要だと明記している。[libz-sys README](https://github.com/rust-lang/libz-sys/blob/main/README.md)

ただし、現行 nixpkgs のコメントは `cmake` と bindgen hook を **aws-lc-sys の checkPhase** 用としている。
また、通常の Cargo build は default features であり、`--all-features` は test にだけ指定される。
現行 nixpkgs の aarch64-darwin パッケージは CMake を check 入力に置いた状態でビルドとテストに成功し、公式キャッシュにも登録されている。

以上から、「Darwin の通常ビルドには zlib-ng 用 CMake が欠けている」という現在の overlay コメントは、少なくとも mise 2026.7.17 と固定 nixpkgs には当てはまらない。
過去ログで CMake 不在が表面化したなら、それは `cargo test --all-features` を含む check 側だった可能性が高い。
通常ビルド入力への CMake 追加を継続する根拠は、一次情報からは確認できなかった。

## Darwin の既知不具合と修正状況

Darwin の mise check が壊れた報告は複数あるが、調べた範囲では「cache miss による mise の Rust ローカルビルドが十数分かかる」という同種の Issue は nixpkgs と mise の公式 tracker に見つからなかった。

確認できた既知不具合は次のとおりである。

- 2025年の nixpkgs PR #451589 では、sandbox 有効時の x86_64-darwin と aarch64-darwin で複数のテストが失敗した。一方、sandbox 無効時には両 Darwin でビルドできた。[NixOS/nixpkgs#451589](https://github.com/NixOS/nixpkgs/pull/451589)
- 2026年5月の Issue #516902 は `git-upload-pack` が check 入力にないため aarch64-darwin のテストが失敗する報告で、Git を `nativeCheckInputs` に加えて解決した。通常ビルドの性能問題ではない。[NixOS/nixpkgs#516902](https://github.com/NixOS/nixpkgs/issues/516902)、[修正 PR #517276](https://github.com/NixOS/nixpkgs/pull/517276)
- mise 2026.6.11 では、Nix sandbox が setuid bit を保持しないため OCI metadata test が aarch64-darwin で失敗した。[更新 PR #533304 の報告](https://github.com/NixOS/nixpkgs/pull/533304#issuecomment-4786974089)
  nixpkgs 2026.6.13 はこのテストを除外して aarch64-darwin で確認し、mise 2026.7.1 では upstream の sandbox 対応テストへ変わったため除外を削除した。[PR #534965](https://github.com/NixOS/nixpkgs/pull/534965)、[PR #539274](https://github.com/NixOS/nixpkgs/pull/539274)
- 現在固定している mise 2026.7.17 の PR は aarch64-darwin でビルド、package test、基本動作を確認している。最初の review では Darwin test が失敗したが、system binary を呼ぶ二テストの除外後は aarch64-darwin を含む review が成功した。[NixOS/nixpkgs#547556](https://github.com/NixOS/nixpkgs/pull/547556)、[最終コミット](https://github.com/NixOS/nixpkgs/commit/e185d05d174daad2276466436e956d44e0083768)
- localhost を使う HTTP test についても、2026年5月に `__darwinAllowLocalNetworking = true` が追加され、aarch64-darwin で確認済みである。[NixOS/nixpkgs#526166](https://github.com/NixOS/nixpkgs/pull/526166)

現在の `doCheck = false` は、mise 2026.6.11 の一時的な失敗を避けるために導入された履歴を持つ。
しかし、固定 nixpkgs の 2026.7.17 は後続修正を含み、aarch64-darwin の check を通している。
現時点では、この override は解決済み不具合を回避し続け、テストを失い、公式キャッシュも外す状態になっている。

## 推奨する確認順序

1. mise の `doCheck = false` と CMake 追加を外す。
2. direnv の `doCheck = false` も外し、mise に公式 direnv の store path が埋め込まれる状態にする。
3. `nix path-info` で mise の出力が `/nix/store/ylixplbpi7c6dl1kf9ymm9cii6pvg3ff-mise-2026.7.17` になり、`nix build --dry-run` が build ではなく fetch を示すことを確認する。
4. `just check` と通常の switch を実行する。

これで公式 derivation と一致する限り、mise は Rust ソースビルドではなくバイナリキャッシュから取得される。
将来の nixpkgs 更新で再び Darwin check が壊れた場合は、テスト全体を止める前に upstream の `checkFlags`、`nativeCheckInputs`、`__darwinAllowLocalNetworking` の修正状況を確認するのがよい。
