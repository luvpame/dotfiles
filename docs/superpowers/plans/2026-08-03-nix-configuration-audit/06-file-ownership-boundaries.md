# T06 Home Managerのfile所有境界を整理する

- Status: 未着手
- Audit IDs: `FILE-01`, `FILE-04`, `FILE-05`, `FILE-06`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: なし

## Goal

即時編集するout-of-store linkとgenerationへ固定するfileを区別し、各targetの書き込み主体を明文化する。

その判断に沿って、実行経路に入らないZsh directory linkとTirithの残骸を削除する。
Claude settingsの`force = true`は、repoを正とすることを確認できた場合だけ維持する。

## Architecture

利用者がrepo内の設定を直接編集し、applicationが書き戻してよいdirectoryは`mkOutOfStoreSymlink`を維持する。
世代rollbackで内容まで戻したい静的fileはstore-backed sourceへ移す。
runtime stateを含むHerdrとHunkは別タスクでfile単位へ分割するため、このタスクでは変更しない。

Zshは`~/.zshenv`だけを起動経路として残す。
実効`ZDOTDIR`が未設定であることを再確認してから、重複する`xdg.configFile.zsh`を削除する。

Tirithはpackageと設定directoryがすでにないため、条件付きinitとrepository guideの参照を一緒に削除する。

Claude settingsはrepoを正とし、Claudeがlocal-only stateを書かないと確認できれば`force = true`を維持して理由をcommentにする。
local-only keyやapplicationによるfile置換が確認された場合は、managed設定とlocal stateを別fileへ分けられるまで変更を停止する。

## 対象ファイル

- `nix/nix-darwin/home-manager/files/common.nix`
- `config/zsh/.zshenv`
- `AGENTS.md`
- `config/claude/settings.json`（書き込み主体の確認対象。原則として内容変更はしない）
- `docs/adr/`（file ownershipを独立した決定として残す場合のみ）

## 未チェックの実施手順

- [ ] `xdg.configFile`と`home.file`の各targetを、live編集、静的設定、runtime stateの三分類で一覧にする。
- [ ] applicationが書き戻すtargetと、人だけが編集するtargetを確認する。
- [ ] 分類結果を`common.nix`の近接commentまたはADRへ記録する。
- [ ] 実効`ZDOTDIR`とZsh startup fileの読込経路を確認する。
- [ ] `ZDOTDIR`が未設定なら`xdg.configFile.zsh`を削除し、`home.file.".zshenv"`を維持する。
- [ ] repo内と実効PATHでTirithを再導入していないことを確認する。
- [ ] `config/zsh/.zshenv`の`tirith init` blockと`AGENTS.md`の存在しないdirectory記述を削除する。
- [ ] Claude起動前後でsettings targetのtype、symlink先、Git差分を確認する。
- [ ] repoを唯一の正と確認できれば`force = true`を維持し、その理由を設定の直前へ記す。
- [ ] local-only dataがあれば削除や上書きをせず、file分割の設計が決まるまで停止する。
- [ ] HerdrとHunkのdirectory linkには触れない。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
zsh -lic 'print -r -- ${ZDOTDIR:-$HOME}'
rg -n 'ZDOTDIR|tirith' config nix AGENTS.md --glob '!nix/local.nix'
```

期待結果: Zshの起動directoryが`$HOME`であり、Tirithの実行参照と存在しないdirectory記述が残っていない。

```sh
test -L "$HOME/.zshenv"
zsh -lic 'echo zsh-startup-ok'
```

期待結果: `~/.zshenv`がmanaged linkとして存在し、新しいinteractive login shellが正常に起動する。

```sh
nixfmt nix/nix-darwin/home-manager/files/common.nix
just check
just build
git diff --check
```

期待結果: file宣言が重複せず、darwin system buildとwhitespace検査が成功する。

## 完了条件

- file targetごとにlive linkを使う理由またはstore-backedにする理由が分かる。
- 重複Zsh directory linkとTirith残骸が削除されている。
- Claude settingsの書き込み主体を確認し、`force`を維持する根拠または分割を保留する根拠が残っている。
- Herdr、Hunk、既存のruntime stateを同じ差分で変更していない。
- `just check`と`just build`が成功している。

## ロールバック

`xdg.configFile.zsh`とTirith initを元の宣言へ戻す。
Claude settingsのtargetがactivationで失われた場合はHome Managerのbackupを優先して復元し、`force`を外した状態で原因を調べる。
runtime stateはこのタスクで移動しないためrollback対象にしない。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
