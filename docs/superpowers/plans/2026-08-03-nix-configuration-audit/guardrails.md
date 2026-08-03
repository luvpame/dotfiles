# 変更禁止事項と現状維持ガード

[Nix 構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)で見送った項目と、現在の方針を維持すると決めた項目を記録する。
これらは実装タスクではない。

## 明示的に見送った項目

- `PKG-04`: site2skillのPython package属性は更新しない。
  `PKG-03`でsite2skill自体を削除するため、変更する対象が残らない。
- `PKG-06`: Yaziが利用する画像、PDF、圧縮CLIのdirect installを減らさない。
- `PKG-09`: 用途不明とされたglobal CLIを今回の棚卸しだけで削除しない。
- `FILE-07`: SOUL.mdの相対参照検証は実施しない。
- `SHELL-03`: TPMからHome Manager tmux moduleへ移行しない。
- `BREW-10`: `mo`と`mole`の構成は変更しない。
- `SYS-02`: `IsAnalog = false`を追加しない。
- `SYS-07`: host identityをNixから宣言しない。

## 現在の方針を維持する項目

- `CORE-09`: scheduled optimiseを維持する。
- `CORE-10`: cacheの署名検証と明示cacheを維持する。
- `CORE-12`: `accept-flake-config = false`などの安全側の既定を維持する。
- `FLAKE-08`: inputの`follows`とlock集約を維持する。
- `FLAKE-09`: CritのGit URLとHunkのcommit pinを、解除条件が成立するまで維持する。
- `PKG-10`: active packageとprofileの組み立てを維持する。
- `HM-05`: global package setとbackup policyを維持する。
- `SHELL-05`: Yaziの現在の管理方法を維持する。
- `BREW-03`: `autoUpdate`、`upgrade`、`zap`のactivation policyを維持する。
- `BREW-11`: WorktrunkはHomebrew版を維持する。
- `BREW-14`: active dependencyを維持する。
- `BREW-15`: GUIとhardware packageを削除せず、現在の構成を維持する。
- `BREW-16`: profile schemaのplaceholderを維持する。
- `SYS-06`: PAM Touch IDを維持し、Watch専用moduleは追加しない。
- `SYS-08`: AeroSpaceとmacOS native tilingの現在の方針を維持する。
- `SYS-09`: desktopとDockの現在の宣言を維持する。
- `SYS-10`: OS updateとGuest loginの現在の方針を維持する。
- `SYS-11`: developer向けdefaultsを追加しない。
- `SYS-12`: `system.stateVersion = 6`を維持する。
- `SYS-13`: `system.primaryUser`を維持する。

## 実装タスク内で維持する選択

- `PKG-07`は[T16](16-restrict-nix-trust-unfree.md)で扱う。
  Claudeはflake packageの直接参照と専用cacheを維持し、global overlayだけを不要なら縮小する。
- `SYS-01`は[T21](21-align-dock-aerospace.md)で扱う。
  `orientation = "right"`は変更せず、矛盾したコメントだけを直す。
- `SYS-05`は[T08](08-validate-ignore-ard.md)で扱う。
  現在の設定が機能すると確認できた場合だけ維持し、機能しない場合は修正せず停止する。

## 全タスクに適用する保護条件

- `nix/nix-darwin/system.nix`にある既存のHot Corner差分を取り込まず、戻さない。
- `nix/local.nix`を追跡対象へ加えず、その内容を文書やログへ出さない。
- HerdrとHunkのruntime stateは削除せず、移行前に退避する。
- `codex-app`の撤去では`zap`を使用しない。
- Fish移行では、親directory linkとHome Manager管理の子ファイルを混在させない。
- `programs.mas.cleanup`を有効にしない。
- コミットはユーザーから明示的に依頼された場合だけ作成する。
