# T27 FisherからHome Manager Fish moduleへ移す

- **Status**: 未着手
- **Audit IDs**: `SHELL-04`, `SHELL-06`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T02（Home Managerの互換性方針）、T25（Fish login shell）、T26（direnv module）

## Goal

FisherがruntimeにGitHubから取得している10個のFish pluginを、revisionとhashを固定したHome Manager管理へ移す。
trackedなFish設定、plugin生成物、`fish_variables`の所有境界も同時に整理する。

## Architecture

新しいHome Manager moduleで`programs.fish.enable = true`と`programs.fish.plugins`を宣言する。
`fish_plugins`にある次の10 sourceは、移行時点のrevisionを固定してNixで取得する。

- `yuys13/fish-cdf`
- `mollifier/fish-cd-gitroot`
- `yuys13/fish-fzf-bd`
- `patrickf1/fzf.fish`
- `yuys13/fish-autols`
- `laughedelic/pisces`
- `gazorby/fish-abbreviation-tips`
- `franciscolourenco/done`
- `pure-fish/pure`
- `acomagu/fish-async-prompt`

`~/.config/fish`の親directory symlinkは削除する。
移行後の親は実directoryとし、Home Manager moduleがplugin fileを、個別の`xdg.configFile`宣言がtrackedなcustom fileを管理する。
親directory linkと管理対象の子fileは混在させない。

現在repo内にあるFisher生成物と`fish_variables`は移行前に退避する。
trackedなcustom fileとFisher生成物は`git ls-files config/fish`との差分で分け、名前の推測だけで削除しない。

## 対象ファイル

- Create: `nix/nix-darwin/home-manager/programs/fish.nix`
- Modify: `nix/nix-darwin/home-manager/default.nix`
- Modify: `nix/nix-darwin/home-manager/files/common.nix`
- Modify: `nix/nix-darwin/homebrew/common.nix`
- Modify: `config/fish/config.d/path.fish`
- Delete: `config/fish/fish_plugins`
- Runtime migration: `config/fish/`内のignoredなFisher生成物と`fish_variables`
- Runtime migration: `~/.config/fish/`

## 実施手順

- [ ] T02、T25、T26が完了し、`home-manager.minimal`を有効にしていないことを確認する。
- [ ] `fisher list`、`fish --version`、`git ls-files config/fish`、`git status --ignored config/fish`を記録する。
- [ ] pluginごとに現在使っているrevisionを特定し、Nix fetcherのhashとlicenseを記録する。
- [ ] repoの`config/fish`全体と`fish_variables`を、権限を制限した時刻付きdirectoryへ退避する。
- [ ] `programs/fish.nix`を作り、10 pluginをrevisionとhash付きで`programs.fish.plugins`へ宣言する。
- [ ] trackedな`config.fish`、`conf.d`、`config.d`、`functions`のcustom fileを、親directoryを作らない個別のHome Manager管理へ移す。
- [ ] Home Manager importsへ新しいFish moduleを追加し、`xdg.configFile.fish`の親directory linkを削除する。
- [ ] `fish_variables`を新しい実directoryへmachine-local stateとして移す。
- [ ] Homebrewの`fisher` formulaと、HomebrewのFisher function pathを追加する`path.fish`の処理を削除する。
- [ ] `config/fish/fish_plugins`を削除する。
- [ ] ignoredなFisher生成物は退避済みであることを照合してからrepo外へ移し、このタスク中は退避を削除しない。
- [ ] コード変更に`code-simplifier`を適用し、Fishの親directory link、Fisher、浮動revisionが残っていないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] ユーザーが適用を明示した場合だけ、復旧用Zsh terminalを残して`just switch`を実行する。
- [ ] 新しいFish login shellでprompt、hook、key binding、completion、custom functionを確認する。
- [ ] Home Manager世代を切り替えてもnetwork取得なしで同じpluginが復元されることを確認する。

## 検証コマンドと期待結果

```bash
nixfmt --check \
  nix/nix-darwin/home-manager/programs/fish.nix \
  nix/nix-darwin/home-manager/default.nix \
  nix/nix-darwin/home-manager/files/common.nix \
  nix/nix-darwin/homebrew/common.nix
just check
just build
```

期待結果は、すべて終了コード0で完了し、10 pluginのsourceが固定hashで取得されることである。

```bash
rg -n "fisher|fish_plugins|xdg\.configFile\.fish|rev =|hash =" nix config/fish
```

期待結果は、Fisherと親directory linkがなく、各pluginのrevisionとhashだけが見つかることである。

適用を明示された後だけ、次を実行する。

```bash
just switch
test -d "$HOME/.config/fish"
test ! -L "$HOME/.config/fish"
fish --login -i -c '
  type -q cdf
  and type -q cd-gitroot
  and type -q bd
  and type -q fzf_configure_bindings
  and type -q fish_prompt
  and echo fish-plugins-ok
'
```

期待結果は、親が実directoryで、主要plugin functionが見つかり、`fish-plugins-ok`と表示されることである。

```bash
brew list --formula fisher
```

期待結果は、Fisherを撤去したため非0で終了することである。
対話確認ではPure prompt、async prompt、Pisces、abbreviation tips、done通知、autols、fzf key binding、custom functionを一つずつ試す。

```bash
git status --short --ignored config/fish
git diff --check
```

期待結果は、Fisher生成物と`fish_variables`がrepoへ再流入せず、空白エラーもないことである。

## 完了条件

- 10 pluginが固定revisionとhashでHome Managerに宣言されている。
- Fisher formula、`fish_plugins`、Fisher用PATH調整がなくなっている。
- `~/.config/fish`は実directoryで、親directory symlinkとmanaged childが混在していない。
- trackedなcustom設定とmachine-localな`fish_variables`を失っていない。
- prompt、hook、key binding、completion、custom functionが正常に動く。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

復旧用Zsh terminalを維持したまま、新しい`~/.config/fish`と`fish_variables`を時刻付き退避先へ複製する。
Home Manager Fish moduleを外し、親directory link、`fish_plugins`、Homebrew Fisher、`path.fish`の連携を移行前へ戻す。
退避したFisher生成物をrepo targetへ戻し、必要なら`fisher update`で整合を取り直す。
`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後に`just switch`を行う。
新旧どちらの`fish_variables`も動作確認が終わるまで削除しない。

## 実装時の制約

- 親directory linkとHome Manager管理の子fileを同時に有効化しない。
- 10 pluginの一部だけをFisherに残す段階移行は行わない。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
