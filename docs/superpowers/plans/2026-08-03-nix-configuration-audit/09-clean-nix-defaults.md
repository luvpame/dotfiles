# T09 Nixの既定重複と一時無効化を整理する

- Status: 未着手
- Audit IDs: `CORE-04`, `CORE-06`, `CORE-11`, `TEMP-01`, `TEMP-02`, `TEMP-04`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: `T03 Nix storeの保持とGC方針を統一する`, `T04 max-jobsを実測して決める`

## Goal

Flake専用運用に不要なchannelと、現行の既定値に重なるNix設定を削除する。

解消済みのdocumentationとdarwin-uninstallerの無効化を解除する。
miseの`doCheck = false`は維持するが、現在version、失敗test、追跡先、解除条件が分かるcommentへ更新する。

## Architecture

`nix.channel.enable = false`を宣言し、legacyな`<nixpkgs>`と`nix-channel`に依存しない状態を明示する。
既定と同じ`nix.package = pkgs.nix`と`keep-derivations = true`は削除し、experimental featuresはlist表記へ揃える。

`documentation.doc.enable = false`と`system.tools.darwin-uninstaller.enable = false`は行ごと削除して既定`true`へ戻す。
過去の`--toc-depth` workaround commentも同時に削除する。

miseだけは再現確認が済むまでoverrideを残す。
commentには固定version、失敗するtest名またはphase、確認したupstream issueかsource reference、`nixpkgs`更新後にcheckを再実行して通れば解除するという条件を書く。
追跡issueが見つからない場合はURLを捏造せず、「upstream issue未確認」と確認日を記す。

## 対象ファイル

- `nix/nix-darwin/nix-core.nix`
- `nix/flake.lock`（versionとsource revisionの確認だけ。手動編集しない）

## 未チェックの実施手順

- [ ] repo内の`nix-channel`、`<nixpkgs>`、`NIX_PATH`参照を検索し、legacy channel利用がないことを確認する。
- [ ] `nix.channel.enable = false`を追加する。
- [ ] `nix.package = pkgs.nix`と`keep-derivations = true`を削除する。
- [ ] `experimental-features`を`[ "nix-command" "flakes" ]`へ変える。
- [ ] documentationの無効化行と古いworkaround commentを削除する。
- [ ] darwin-uninstallerの無効化行を削除する。
- [ ] 固定nixpkgsのmise versionとoverrideなしで失敗するtestまたはphaseを確認する。
- [ ] upstream issueを検索し、見つかった場合だけURLをcommentへ記載する。
- [ ] mise commentへversion、失敗箇所、追跡先、解除条件、確認日を記載し、`doCheck = false`自体は維持する。
- [ ] `nix.optimise.automatic`、cache、sandbox、trust設定には触れない。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
rg -n 'nix-channel|<nixpkgs>|NIX_PATH' . --glob '!nix/local.nix' --glob '!docs/research/**'
```

期待結果: runtime scriptとtracked設定にlegacy channel依存がない。

構成名はT01のtracked registryにある名前へ置き換える。

```sh
cd nix
nix eval '.#darwinConfigurations.<configuration>.config.nix.channel.enable'
nix eval '.#darwinConfigurations.<configuration>.config.documentation.doc.enable'
nix eval '.#darwinConfigurations.<configuration>.config.system.tools.darwin-uninstaller.enable'
```

期待結果: channelだけが`false`で、documentationとdarwin-uninstallerは`true`になる。

```sh
nixfmt nix/nix-darwin/nix-core.nix
just check
just build
git diff --check
```

期待結果: 既定値削除後もflake checkとdarwin buildが成功し、whitespace errorがない。

switchを別途許可された場合だけ、`man configuration.nix`と`darwin-uninstaller --help`が利用できることを確認する。

## 完了条件

- legacy channelが無効で、repo内に依存がない。
- 既定値と重複する`nix.package`と`keep-derivations`が削除されている。
- experimental featuresがlist表記である。
- documentationとdarwin-uninstallerが再有効化されている。
- mise workaroundが維持され、解除判断に必要な情報がcommentに揃っている。
- `just check`と`just build`が成功している。

## ロールバック

legacy workflowが見つかった場合は`nix.channel.enable`の追加を戻す。
documentationまたはdarwin-uninstallerがbuildを壊す場合は、失敗logを保存して無効化行を一時的に戻す。
mise overrideはこのタスクで解除しないためrollback対象にしない。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
