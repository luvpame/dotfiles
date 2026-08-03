# T24 Hunkのruntime stateをrepoから分離する

- **Status**: 未着手
- **Audit IDs**: `FILE-03`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T06（設定ファイルの所有境界）、T23（Herdr state分離）

## Goal

repoで管理するHunkのファイルを`config.toml`だけに限定する。
`lastSeenCliVersion`などを持つ`state.json`は、端末ごとの`~/.config/hunk`へ移す。

## Architecture

現在の`xdg.configFile.hunk`は、`~/.config/hunk`全体をrepoの`config/hunk`へ向けるdirectory symlinkである。
これを`xdg.configFile."hunk/config.toml"`のfile symlinkへ置き換える。

移行後の`~/.config/hunk`は実directoryとし、`config.toml`だけをHome Managerが管理する。
`config/hunk/state.json`は退避とlocal copyを確認してからrepoの追跡対象から外す。
stateは削除せず、移行中も退避先とlocal directoryの二か所に保持する。

## 対象ファイル

- Modify: `nix/nix-darwin/home-manager/files/common.nix`
- Preserve: `config/hunk/config.toml`
- Remove after preservation: `config/hunk/state.json`
- Runtime migration: `~/.config/hunk/`

## 実施手順

- [ ] `hunk session list --json`を実行し、active sessionと対象repoを記録する。
- [ ] `readlink "$HOME/.config/hunk"`と`find -H "$HOME/.config/hunk" -maxdepth 2 -print`で、現在のlink先と内容を記録する。
- [ ] `~/.local/state/dotfiles-migrations/`配下へ権限700の時刻付き退避directoryを作り、`config/hunk`全体を複製する。
- [ ] `state.json`の退避元と退避先でSHA-256を比較する。
- [ ] `xdg.configFile.hunk`を削除し、`xdg.configFile."hunk/config.toml".source`だけをout-of-store symlinkとして宣言する。
- [ ] コード変更に`code-simplifier`を適用し、Hunkの親directory linkが残っていないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] Hunk TUIをすべて正常終了し、`hunk session list --json`が空になるまで移行を進めない。
- [ ] 現在の`~/.config/hunk` symlinkを退避directoryへ移し、同じpathに権限700の実directoryを作る。
- [ ] `state.json`を新しい実directoryへ複製し、内容とSHA-256が一致することを確認する。
- [ ] local copyと退避copyを確認した後に限り、repoの`config/hunk/state.json`を追跡対象から外す。
- [ ] ユーザーが適用を明示した場合だけ`just switch`を実行する。
- [ ] Hunkを起動し、設定が読み込まれ、version noticeのstateがlocal directoryで更新されることを確認する。
- [ ] 退避directoryは少なくとも次回の正常起動と終了を確認するまで保持し、このタスクでは削除しない。

## 検証コマンドと期待結果

```bash
hunk session list --json
```

期待結果は、state移行の直前には`sessions`が空であることである。

```bash
nixfmt --check nix/nix-darwin/home-manager/files/common.nix
just check
just build
```

期待結果は、すべて終了コード0で完了することである。

適用を明示された後だけ、次を確認する。

```bash
test -d "$HOME/.config/hunk"
test ! -L "$HOME/.config/hunk"
test -L "$HOME/.config/hunk/config.toml"
test -f "$HOME/.config/hunk/state.json"
readlink "$HOME/.config/hunk/config.toml"
```

期待結果は、親が実directoryで、`config.toml`だけがrepoを指すsymlinkになり、`state.json`がlocal fileとして残ることである。

```bash
git ls-files --error-unmatch config/hunk/state.json
```

期待結果は、`state.json`を追跡対象から外したため非0で終了することである。

```bash
find config/hunk -mindepth 1 ! -name config.toml -print
git status --short config/hunk
```

期待結果は、repo側にruntime stateがなく、`state.json`がuntrackedでも再生成されないことである。

## 完了条件

- `~/.config/hunk`が実directoryになっている。
- `config.toml`だけをHome Managerがrepoから配備している。
- `state.json`がlocal directoryと退避先にあり、repoでは追跡されていない。
- Hunkが正常起動し、machine-local stateを更新できる。
- 退避directoryを削除せず保持している。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

Hunkを正常終了し、local directory全体を新しい時刻付き退避先へ複製する。
Nix宣言を親directory linkへ戻し、退避した`state.json`をrepoの元位置へ復元する。
`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後に`just switch`を行う。
local stateと退避stateは動作確認が終わるまで削除しない。

## 実装時の制約

- Hunkを停止し、stateを退避するまでdirectory構造や`state.json`を変更しない。
- stateは移動または複製して保持し、削除しない。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
