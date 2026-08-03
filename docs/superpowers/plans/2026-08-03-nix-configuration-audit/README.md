# Nix 構成棚卸し実装計画

2026-07-31 に実施した[Nix 構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)の回答を、独立して検証して切り戻せる30個の実装計画へ分割した。
各ファイルは未着手であり、明示的に選ばれたタスクだけを実行する。

タスク番号は参照用の固定IDである。
実行順は番号ではなく、各ファイルの依存関係に従う。

## 共通制約

- 実行前に `git status --short` を確認し、既存の変更をタスクへ混ぜない。
- `nix/nix-darwin/system.nix` にある未コミットのHot Corner変更を保全する。
- `nix/local.nix`は読み上げず、追跡せず、タスク文書にも値を記載しない。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`を実行する。
- コードを変更したら`code-simplifier`を適用し、同じ検証をもう一度実行する。
- `just switch`、logout、アプリ削除、runtime state移行は、各計画に記載した事前確認を終えてから実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
- GitHub issueを作成した後は、進捗の正をissue側に置き、この計画書へ状態を二重記録しない。

## タスク一覧

| ID | 実装計画 | 監査ID | 依存 |
| --- | --- | --- | --- |
| T01 | [マルチホスト定義をtracked registryへ移す](01-multi-host-registry.md) | `FLAKE-03`, `FLAKE-07`, `SYS-14` | なし |
| T02 | [Home Managerの互換性方針を確定する](02-home-manager-baseline.md) | `HM-01`, `HM-03`, `HM-04` | T01 |
| T03 | [Nix storeの保持とGCを統一する](03-nix-store-lifecycle.md) | `CORE-05`, `CORE-07` | なし |
| T04 | [`max-jobs`を実測して設定する](04-max-jobs-benchmark.md) | `CORE-08` | T01 |
| T05 | [GitとLuarocksの供給元を一本化する](05-cli-source-of-truth.md) | `PKG-08` | T01 |
| T06 | [設定ファイルの所有境界を整理する](06-file-ownership-boundaries.md) | `FILE-01`, `FILE-04`, `FILE-05`, `FILE-06` | なし |
| T07 | [Caskの更新責任とgreedy policyを揃える](07-cask-update-policy.md) | `BREW-13` | なし |
| T08 | [`ignoreArd`の効力を実機で確認する](08-validate-ignore-ard.md) | `SYS-05` | なし |
| T09 | [Nixの既定重複と一時設定を整理する](09-clean-nix-defaults.md) | `CORE-04`, `CORE-06`, `CORE-11`, `TEMP-01`, `TEMP-02`, `TEMP-04` | T03, T04 |
| T10 | [Flakeの検査とrevision metadataを整備する](10-flake-checks-metadata.md) | `FLAKE-04`, `FLAKE-05`, `FLAKE-06` | T01, T09 |
| T11 | [statixとRTKのstale test overrideを外す](11-remove-stale-test-overrides.md) | `TEMP-03`（statix）, `PKG-02` | なし |
| T12 | [Tree-sitter CLIをnixpkgs版へ置き換える](12-use-nixpkgs-tree-sitter.md) | `PKG-01` | なし |
| T13 | [未使用のsite2skillとPiqueを削除する](13-remove-unused-custom-packages.md) | `PKG-03`, `PKG-05` | なし |
| T14 | [Homebrew formulaとprefixを整理する](14-clean-homebrew-formulas.md) | `BREW-02`, `BREW-06`, `BREW-07`, `BREW-08`, `BREW-12` | T05 |
| T15 | [nixpkgsとnix-darwin inputを更新する](15-update-nixpkgs-nix-darwin.md) | `FLAKE-01`, `FLAKE-02` | T10, T11, T12, T13 |
| T16 | [Nixのtrustとunfree許可を縮小する](16-restrict-nix-trust-unfree.md) | `CORE-02`, `CORE-03`, `PKG-07` | T15 |
| T17 | [relaxed sandboxを導入する](17-enable-relaxed-sandbox.md) | `CORE-01` | T11, T12, T13, T15, T16, T18 |
| T18 | [`im-select`を固定してitem単位でtrustする](18-pin-im-select-and-trust-items.md) | `BREW-04`, `BREW-05` | T14 |
| T19 | [Application Firewallを有効にする](19-enable-application-firewall.md) | `SYS-03` | なし |
| T20 | [画面ロック直後の再認証を必須にする](20-require-password-after-lock.md) | `SYS-04` | なし |
| T21 | [DockとAeroSpaceのdisplay設定を整合させる](21-align-dock-aerospace.md) | `SYS-01`, `SYS-15` | なし |
| T22 | [Home Manager Appsを`copyApps`へ移す](22-migrate-home-manager-copy-apps.md) | `HM-02` | T02 |
| T23 | [Herdrのruntime stateをrepoから分離する](23-separate-herdr-runtime-state.md) | `FILE-02` | T06 |
| T24 | [Hunkのruntime stateをrepoから分離する](24-separate-hunk-runtime-state.md) | `FILE-03` | T06, T23 |
| T25 | [Fish login shellをnix-darwinへ移管する](25-manage-fish-login-shell.md) | `SHELL-01` | T01 |
| T26 | [direnvとnix-direnvをmoduleへ移管する](26-enable-direnv-module.md) | `SHELL-02`, `TEMP-03`（direnv） | T11 |
| T27 | [FisherからHome Manager Fish moduleへ移す](27-migrate-fisher-to-home-manager.md) | `SHELL-04`, `SHELL-06` | T02, T25, T26 |
| T28 | [廃止済みCodex appを安全に撤去する](28-remove-codex-app-safely.md) | `BREW-01` | T14 |
| T29 | [HackGenとMonaspaceをNix管理へ移す](29-manage-fonts-with-nix.md) | `BREW-09` | T14, T21 |
| T30 | [全変更を統合検証する](30-final-acceptance.md) | 全タスクの受け入れ確認 | 実施対象の全タスク |

## 推奨する実行のまとまり

最初のまとまりでは、依存先のないT01、T03、T06、T07、T08、T11からT13、T19からT21までに着手できる。
T01が終わるとT02、T04、T05、T25へ進める。

T03とT04の結果を反映してT09を終えた後、T10からT16までを進める。
packageとFlakeの基線が安定してから、T17のsandboxを導入する。

T18からT21までは、securityまたはmacOSの動作を変えるため、それぞれを独立して適用する。
一つの変更で問題が出ても、ほかの設定を戻さずに切り分けられる。

T22からT29までは、アプリ、shell、runtime stateを移行する。
データ退避やlogoutが必要になるため、通常のNix整理と同じ適用単位にはしない。

T30は、選択して実施したタスクだけを対象にする。
未実施タスクを完了扱いにはしない。

## 変更しない判断

見送りと現状維持の判断は、[変更禁止事項と現状維持ガード](guardrails.md)にまとめた。
各タスクのレビューでは、このファイルに反する変更が混入していないことも確認する。
