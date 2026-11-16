# Meta Muse と Muse Code の配布状況

2026-11-16 に Apple Silicon の Mac（macOS 26.6.2）で調査した。この Mac へのインストールと設定変更は未実施。

| 製品 | Homebrew | nixpkgs |
| --- | --- | --- |
| Muse（個人向け AI の Mac アプリ） | `muse` は無効。Homebrew が対応しない署名付きダウンロード URL を必要とする。 | 調査したリビジョンに該当パッケージなし。`pkgs.muse` は別製品の MusE。 |
| Muse Code（ターミナル用のコーディングエージェント） | `muse-code` が有効。調査時は `1.4.20-R8619.1`。 | `pkgs.muse-code` が `aarch64-darwin` に対応。調査時は `1.4.14`（`R7309.1`）。 |

## Muse

Homebrew の `muse` cask は `Muse.app`（バンドル ID `com.meta.endo`）を対象とする。macOS 14 以降が要件で、アプリの自動更新ありとして登録されている。ダウンロードに署名付き URL が必要になったため、2026-10-01 付で無効になった。カタログに名前が残っていても、`brew install --cask muse` では導入できない。[cask 定義](https://github.com/Homebrew/homebrew-cask/blob/HEAD/Casks/m/muse.rb)・[無効化 PR](https://github.com/Homebrew/homebrew-cask/pull/291072)・[Homebrew API](https://formulae.brew.sh/api/cask/muse.json)

Mac アプリの導入先は Meta の公式ダウンロードページ。旧 cask の URL に直接 GET した結果は HTTP 403 だった。Meta の更新フィードは期限付きの配布 URL を返し、その URL への Range GET は HTTP 206 だった。フィードから得た URL を cask や Nix の取得先に固定すると、期限切れ後の新規取得に使えなくなる。[公式ダウンロード](https://ai.meta.com/muse/download/)・[Meta の更新フィード](https://www.facebook.com/endo/release/appcast.xml?channel=production)

dotfiles が固定する [nixpkgs `2074cc6`](https://github.com/NixOS/nixpkgs/tree/2074cc672349f14240fb7ea90d509e0b643e9dd4) と調査時の [`nixpkgs-unstable` `5d2b81a`](https://github.com/NixOS/nixpkgs/tree/5d2b81a7a3be3e2f832879028e4d60abbf58e9a0) を展開し、`pkgs/` の製品名と配布 URL を検索した。どちらにも GUI 版は見つからなかった。[`pkgs.muse` の定義](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/by-name/mu/muse/package.nix)は Linux 向けの MIDI・音声シーケンサー。Mac GUI を配布する非公式 tap・flake も、GitHub のリポジトリ検索では確認できなかった。

## Muse Code

Homebrew の `muse-code` cask は macOS 12 以降に対応する。Apple Silicon では Meta の CDN からバージョンを指定して `muse-aarch64-macos` を取得し、SHA-256 を照合して `muse` として配置する。追加の tap は不要。通常の Homebrew formula に同じ製品は見つからなかった。[cask 定義](https://github.com/Homebrew/homebrew-cask/blob/HEAD/Casks/m/muse-code.rb)・[cask API](https://formulae.brew.sh/api/cask/muse-code.json)・[formula 一覧 API](https://formulae.brew.sh/api/formula.json)

cask が参照するバイナリを一時ディレクトリに取得した。SHA-256 が一致し、`codesign --verify --strict` が成功した。バイナリを直接 `--version` で実行すると `Muse Code 1.4.20 (1.4.20-R8619.1)` と表示された。

nixpkgs の固定版と調査時の `nixpkgs-unstable` では、`pkgs.muse-code` がどちらも `1.4.14` として `aarch64-darwin` で評価できた。Meta の CDN から固定バージョンのバイナリを取得し、`bin/muse` に配置する。macOS では署名を保持するためバイナリを加工しない。ライセンス区分は `unfree`。固定版のバイナリを一時ディレクトリに取得し、HTTP 200、マニフェストの SHA-256 一致、Mach-O arm64、`codesign -vv` の成功を確認した。[パッケージ定義](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/by-name/mu/muse-code/package.nix)・[マニフェスト](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/by-name/mu/muse-code/manifest.json)

非公式の [`ilqqy/muse-code-flake`](https://github.com/ilqqy/muse-code-flake) も見つかった。[配布対象](https://github.com/ilqqy/muse-code-flake/blob/main/sources.json)は `aarch64-linux` と `x86_64-linux` のみ。この Mac には使えない。

## dotfiles への登録先

- Homebrew で調査時点の新しい版を使うなら、[homebrew.nix](../../nix/nix-darwin/homebrew.nix) の `caskNames` に `"muse-code"` を追加する。この構成は `cleanup = "zap"` を使うため、手動で入れた未登録の cask は次回の `just switch` で削除対象になる。
- `flake.lock` でバージョンを固定するなら、[packages.nix](../../nix/nix-darwin/home-manager/packages.nix) の `home.packages` に `muse-code` を追加する。[nix-core.nix](../../nix/nix-darwin/nix-core.nix) はすでに `allowUnfree` を有効にしている。
