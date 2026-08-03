# T23 Herdrのruntime stateをrepoから分離する

- **Status**: 未着手
- **Audit IDs**: `FILE-02`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T06（設定ファイルの所有境界）

## Goal

repoで管理するHerdrのファイルを`config.toml`だけに限定する。
session、history、log、release note、plugin lockなどのruntime stateは、端末ごとの`~/.config/herdr`へ移す。

## Architecture

現在の`xdg.configFile.herdr`は、`~/.config/herdr`全体をrepoの`config/herdr`へ向けるdirectory symlinkである。
これを`xdg.configFile."herdr/config.toml"`のfile symlinkへ置き換える。

移行後の`~/.config/herdr`は実directoryとし、その中の`config.toml`だけをHome Managerが管理する。
runtime stateは同じ実directoryに残し、repoへ書き戻さない。

Herdrが動いている間はsession、log、socketが更新される。
実データの移動はHerdrを正常終了した後、Herdr外の通常terminalから行う。
移行前のstateは権限を制限した退避先へ複製し、タスク内では退避を削除しない。

## 対象ファイル

- Modify: `nix/nix-darwin/home-manager/files/common.nix`
- Preserve: `config/herdr/config.toml`
- Runtime migration: `config/herdr/`内の`config.toml`以外
- Runtime migration: `~/.config/herdr/`

## 実施手順

- [ ] `readlink "$HOME/.config/herdr"`と`find -H "$HOME/.config/herdr" -maxdepth 3 -print`で、現在のlink先と全内容を記録する。
- [ ] `session.json`、`session-history.json`、`release-notes.json`、`.plugins.lock`、log、socket、および未知の項目を分類する。
- [ ] `~/.local/state/dotfiles-migrations/`配下へ権限700の時刻付き退避directoryを作り、`config/herdr`の通常fileとdirectoryを複製する。
- [ ] 退避元と退避先の通常fileについてSHA-256を比較し、stateが複製できたことを確認する。
- [ ] `xdg.configFile.herdr`を削除し、`xdg.configFile."herdr/config.toml".source`だけをout-of-store symlinkとして宣言する。
- [ ] コード変更に`code-simplifier`を適用し、Herdrの親directory linkが残っていないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] `HERDR_ENV=1`のpaneでは移行を続けず、すべてのHerdr workspaceを保存してHerdrを正常終了する。
- [ ] Herdr serverとclientが終了し、runtime fileの更新が止まったことを確認する。
- [ ] 現在の`~/.config/herdr` symlinkを退避directoryへ移し、同じpathに権限700の実directoryを作る。
- [ ] repo側の`config.toml`以外を新しい実directoryへ移す。
- [ ] socketは退避先へ保持するが、新しい実directoryへ復元しない。
  Herdrが再起動時に新しいsocketを作るためである。
- [ ] 未知の項目はruntime stateとして移し、名前だけを理由に削除しない。
- [ ] ユーザーが適用を明示した場合だけ、Herdr外のterminalから`just switch`を実行する。
- [ ] `~/.config/herdr/config.toml`がrepoを指すfile symlinkで、親が実directoryであることを確認する。
- [ ] Herdrを起動し、直前のsessionと設定が読み込まれ、新しいstateがrepoではなく実directoryへ書かれることを確認する。
- [ ] 退避directoryは少なくとも次回の正常起動と終了を確認するまで保持し、このタスクでは削除しない。

## 検証コマンドと期待結果

```bash
readlink "$HOME/.config/herdr"
find -H "$HOME/.config/herdr" -maxdepth 3 -print
```

期待結果は、移行前のlink先とstateの全体を記録できることである。

```bash
nixfmt --check nix/nix-darwin/home-manager/files/common.nix
just check
just build
```

期待結果は、すべて終了コード0で完了することである。

Herdrを停止した後、次の条件を確認する。

```bash
test -d "$HOME/.config/herdr"
test ! -L "$HOME/.config/herdr"
test -L "$HOME/.config/herdr/config.toml"
readlink "$HOME/.config/herdr/config.toml"
```

期待結果は、親が実directoryで、`config.toml`だけがrepoを指すsymlinkになることである。

```bash
find config/herdr -mindepth 1 ! -name config.toml -print
git status --short config/herdr
```

期待結果は、repo側に`config.toml`以外のruntime stateが残らず、`.plugins.lock`などがuntrackedで現れないことである。

Herdr再起動後に次を実行する。

```bash
find "$HOME/.config/herdr" -maxdepth 2 -print
find config/herdr -mindepth 1 ! -name config.toml -print
```

期待結果は、sessionやlogなどが`~/.config/herdr`に作成され、repo側の二つ目の出力が空であることである。

## 完了条件

- `~/.config/herdr`が実directoryになっている。
- `config.toml`だけをHome Managerがrepoから配備している。
- 既存のsession、history、release note、plugin lock、logを失っていない。
- Herdrが正常起動し、新しいruntime stateがrepoへ流入しない。
- 退避directoryを削除せず保持している。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

Herdrを再び正常終了し、実directory全体を新しい時刻付き退避先へ複製する。
Nix宣言を親directory linkへ戻し、`nixfmt`、`just check`、`just build`を実行する。
元のrepo targetへstateを戻す場合も、退避済みstateと実directoryの差分を統合してから行い、どちらも削除しない。
ユーザーの明示後に`just switch`を実行し、sessionを確認する。

## 実装時の制約

- Herdrを停止し、stateを退避するまでdirectory構造を変更しない。
- stateは移動または複製して保持し、削除しない。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
