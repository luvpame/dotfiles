# T02 Home Managerの互換性基線を確定する

- Status: 未着手
- Audit IDs: `HM-01`, `HM-03`, `HM-04`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: `T01 マルチホスト構成を tracked host registry へ移行する`

## Goal

`home.stateVersion = "24.11"`の来歴と互換性を確認し、維持するか変更するかを根拠付きで決める。

24.11を維持する場合は、意図せずGNU manが導入される互換挙動を`programs.man.package = null`で打ち消す。
FishなどをHome Manager moduleへ移す計画があるため、`home-manager.minimal`はmodule ownershipが固まるまで有効化しない。

## Architecture

`home.stateVersion`は「現在のHome Manager版」ではなく、初回導入時の既定動作を保持する互換性境界として扱う。
既存環境の導入時期をGit履歴、過去のgeneration、利用者の記録から確認し、単に新しい値へ追従させない。

調査で24.11が正しいと確認できた場合、state versionは維持する。
そのうえで24.11固有のGNU man packageを不要とする回答を反映し、`programs.man.package = null`を明示する。
別のstate versionが正しいと裏付けられた場合は、変更による互換挙動を列挙し、独立したmigration判断を利用者へ求める。

`home-manager.minimal`はcoreとshellに絞ったmodule構成を選ぶoptionである。
後続のFish module移行と競合するため、このタスクでは`false`のまま維持し、理由を短いcommentで残す。

## 対象ファイル

- `nix/nix-darwin/home-manager/default.nix`
- `nix/flake.lock`（Home Manager sourceの確認だけ。手動編集しない）
- `docs/adr/`（state versionの来歴を恒久的に残す必要がある場合のみ）

## 未チェックの実施手順

- [ ] 作業開始時に`git status --short`を記録し、既存の未コミット差分を特定する。
- [ ] `git log`と`git blame`で`home.stateVersion = "24.11"`が導入されたcommitと理由を調べる。
- [ ] 利用可能なら過去のHome Manager generation情報を読み、初回導入時期との整合を確認する。
- [ ] 固定Home Manager sourceで、24.11に関連する`programs.man`の互換分岐と`home-manager.minimal`が読み込むmoduleを確認する。
- [ ] 24.11が正しい基線なら値を維持し、`programs.man.package = null`を同じuser moduleへ追加する。
- [ ] 24.11が誤りまたは不明ならstate versionを変更せず、確認できなかった事実と必要な追加情報を記録して停止する。
- [ ] `home-manager.minimal`を有効にせず、後続のFish module移行を妨げるため現状維持することを記録する。
- [ ] `programs.man.enable`自体は変更せず、package差し替えだけに限定する。
- [ ] 既存のApplication配備activationには触れない。これは`T22`相当の別タスクで扱う。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
git log -S 'home.stateVersion = "24.11"' -- nix/nix-darwin/home-manager/default.nix
git blame nix/nix-darwin/home-manager/default.nix
```

期待結果: state versionの導入commitまたは、来歴を確定できないという事実を記録できる。

```sh
nixfmt nix/nix-darwin/home-manager/default.nix
just check
just build
```

期待結果: Home Manager user configurationを評価してdarwin systemをbuildできる。
24.11を維持した場合、option conflictやGNU man packageに関する評価errorがない。

```sh
git diff --check
```

期待結果: whitespace errorがなく、このタスクの差分がHome Managerの互換性設定に限定されている。

switchを許可された場合だけ、適用後に次を確認する。

```sh
man --version
home-manager generations
```

期待結果: macOS標準のman利用経路を壊さず、新しいHome Manager generationを確認できる。

## 完了条件

- state versionの値を維持する根拠、または変更を保留した根拠が記録されている。
- 24.11を維持する場合だけ`programs.man.package = null`が設定されている。
- `home-manager.minimal`を有効化していない。
- Application配備やFish ownershipを同じ差分へ混ぜていない。
- `just check`と`just build`が成功している。

## ロールバック

追加した`programs.man.package`と説明commentを戻す。
state versionを変更するmigrationが別途承認されていた場合は、適用前のgenerationへ切り替えたうえで元の値へ戻す。
`home-manager.minimal`は変更しないため、同optionのrollbackは発生しない。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
