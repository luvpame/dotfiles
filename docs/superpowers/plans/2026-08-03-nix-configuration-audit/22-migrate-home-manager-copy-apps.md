# T22 Home Manager AppsをcopyAppsへ移す

- **Status**: 未着手
- **Audit IDs**: `HM-02`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T02（Home Managerの互換性方針）

## Goal

独自の`linkApplications` activationをHome Manager標準の`copyApps`へ置き換える。
削除済みappの残骸、package更新後のLaunchServices登録漏れ、独自scriptの保守をなくす。

## Architecture

Home Manager user設定で`targets.darwin.copyApps.enable = true`と`targets.darwin.linkApps.enable = false`を明示する。
現在の`home.activation.linkApplications`は全体を削除する。

`copyApps`はapp bundleを`~/Applications/Home Manager Apps`へ実コピーするため、従来のsymlinkより容量を使う。
初回activationはApp Management権限を確認できる対話セッションで行い、SSHやheadless環境では実施しない。

独自activationが作った`~/Applications/*.app`のsymlinkは、移行後のapp bundleを確認してから個別に退避する。
targetを確認せず、`~/Applications`を一括削除する操作は行わない。

## 対象ファイル

- Modify: `nix/nix-darwin/home-manager/default.nix`
- Runtime migration: `~/Applications/`

## 実施手順

- [ ] T02が完了し、`home.stateVersion`と`home-manager.minimal`の方針が確定していることを確認する。
- [ ] `~/Applications`直下のsymlinkとtargetを読み取り専用で一覧化し、`Home Manager Apps`を指すものだけを移行台帳へ記録する。
- [ ] `~/Applications/Home Manager Apps`の現在の種類、容量、内容を記録する。
- [ ] App Management設定を開けるGUIセッションで作業できることと、必要な空き容量があることを確認する。
- [ ] `home.activation.linkApplications`を削除する。
- [ ] Home Manager user設定へ`targets.darwin.copyApps.enable = true`と`targets.darwin.linkApps.enable = false`を追加する。
- [ ] コード変更に`code-simplifier`を適用し、独自activationの参照が残っていないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] ユーザーが適用を明示した場合だけ、ローカルのGUIセッションで`just switch`を実行する。
- [ ] App Management権限を求められた場合は内容を確認して許可し、activationが完了したことを確認する。
- [ ] コピー済みappを起動し、Spotlightから見つかることを確認する。
- [ ] 移行前に記録したtop-level symlinkのうち、旧`Home Manager Apps`を指したままのものだけを退避する。
- [ ] 退避したsymlinkは、すべてのappを確認し終えるまで削除しない。

## 検証コマンドと期待結果

```bash
find "$HOME/Applications" -maxdepth 1 -type l -print -exec readlink {} \;
du -sh "$HOME/Applications/Home Manager Apps" 2>/dev/null || true
```

期待結果は、既存symlinkのpathとtarget、および移行前の容量を記録できることである。

```bash
nixfmt --check nix/nix-darwin/home-manager/default.nix
just check
just build
```

期待結果は、すべて終了コード0で完了することである。

```bash
rg -n "linkApplications|targets\.darwin\.(copyApps|linkApps)" nix/nix-darwin/home-manager/default.nix
```

期待結果は、独自`linkApplications`がなく、`copyApps`の`true`と`linkApps`の`false`だけが見つかることである。

適用を明示された後だけ、次を実行する。

```bash
just switch
test -d "$HOME/Applications/Home Manager Apps"
test ! -L "$HOME/Applications/Home Manager Apps"
find "$HOME/Applications/Home Manager Apps" -maxdepth 1 -name '*.app' -print
```

期待結果は、switchが成功し、`Home Manager Apps`がsymlinkではないdirectoryになり、管理対象のapp bundleが存在することである。
代表的なappをFinderとSpotlightから起動し、LaunchServices登録も手動で確認する。

```bash
git diff --check
```

期待結果は、出力なしで終了コードが0になることである。

## 完了条件

- 独自`linkApplications` activationが削除されている。
- `copyApps`が有効で`linkApps`が無効である。
- app bundleが実コピーされ、FinderとSpotlightから起動できる。
- staleなtop-level symlinkをtarget確認後に退避している。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

コピー済みの`Home Manager Apps`を削除せず、まず別名へ退避する。
`copyApps`と`linkApps`の設定を戻し、作業開始時の`linkApplications`を復元する。
`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後に`just switch`を行う。
移行台帳に記録したsymlinkだけを元のtargetへ戻し、退避したapp bundleは動作確認が終わるまで保持する。

## 実装時の制約

- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
