# T29 HackGenとMonaspaceをNix管理へ移す

- **Status**: 未着手
- **Audit IDs**: `BREW-09`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T14（Homebrew formulaとprefixの整理）、T21（DockとAeroSpaceのdisplay設定）

## Goal

HackGen Nerd FontとMonaspaceをHomebrew caskからnix-darwinの`fonts.packages`へ移す。
WezTermとZedが参照する`HackGen Console NF`を維持し、重複fontを残さない。

## Architecture

`nix/nix-darwin/system.nix`で`pkgs.hackgen-nf-font`と`pkgs.monaspace`を`fonts.packages`へ宣言する。
同じswitchでHomebrewの`font-hackgen-nerd`と`font-monaspace`をcask一覧から外す。

nix-darwinはNix管理のfontを`/Library/Fonts/Nix Fonts`へ同期する。
移行中は同じPostScript nameが一時的に重複し得るため、適用後にFont Book、WezTerm、Zedを再起動して確認する。
font cacheを破壊的に初期化する操作は、通常の再起動で直らない場合に別途判断する。

## 対象ファイル

- Modify: `nix/nix-darwin/system.nix`
- Modify: `nix/nix-darwin/homebrew/common.nix`
- Verify only: `config/wezterm/wezterm.lua`
- Verify only: `config/zed/settings.json`

## 実施手順

- [ ] `brew list --cask`、Font Book、`system_profiler SPFontsDataType`で移行前のHackGenとMonaspaceを記録する。
- [ ] WezTermとZedが`HackGen Console NF`を参照していることを確認する。
- [ ] `system.nix`が`pkgs`を受け取り、`fonts.packages`へ`hackgen-nf-font`と`monaspace`を追加する。
- [ ] Homebrew cask一覧から`font-hackgen-nerd`と`font-monaspace`を削除する。
- [ ] `nix/nix-darwin/system.nix`の既存Hot Corner差分を作業開始時の記録と照合し、変更しない。
- [ ] コード変更に`code-simplifier`を適用し、同じfontをHomebrewとNixの両方で宣言していないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] ユーザーが適用を明示した場合だけ`just switch`を実行する。
- [ ] WezTerm、Zed、Font Bookを再起動し、HackGenとMonaspaceが一組ずつ認識されることを確認する。
- [ ] 再起動で反映されない場合はlogoutを提案し、ユーザーの明示後に実施する。

## 検証コマンドと期待結果

```bash
brew list --cask | rg 'font-(hackgen-nerd|monaspace)'
system_profiler SPFontsDataType | rg -i 'HackGen|Monaspace'
rg -n 'HackGen Console NF' config/wezterm/wezterm.lua config/zed/settings.json
```

期待結果は、移行前の供給元と利用中のfont familyを記録できることである。

```bash
nixfmt --check nix/nix-darwin/system.nix nix/nix-darwin/homebrew/common.nix
just check
just build
```

期待結果は、二つのNix packageを含む構成が終了コード0でbuildできることである。

```bash
rg -n 'hackgen-nf-font|monaspace|font-hackgen-nerd|font-monaspace' \
  nix/nix-darwin/system.nix \
  nix/nix-darwin/homebrew/common.nix
```

期待結果は、Nix packageの二宣言だけが見つかり、Homebrew font caskは見つからないことである。

適用を明示された後だけ、次を実行する。

```bash
just switch
find '/Library/Fonts/Nix Fonts' -maxdepth 2 -type f | rg -i 'HackGen|Monaspace'
brew list --cask | rg 'font-(hackgen-nerd|monaspace)'
```

期待結果は、Nix Fonts配下に両fontがあり、最後のHomebrew検索は非0で終了することである。
`system_profiler SPFontsDataType`、Font Book、WezTerm、Zedでもfont名と表示を確認する。

```bash
git diff --check
git diff -- nix/nix-darwin/system.nix
```

期待結果は、空白エラーがなく、Hot Cornerの既存差分を保全していることである。

## 完了条件

- HackGenとMonaspaceを`fonts.packages`だけが供給している。
- Homebrewのfont caskが撤去されている。
- `/Library/Fonts/Nix Fonts`で両fontを確認できる。
- WezTermとZedで`HackGen Console NF`が従来どおり表示される。
- Font Bookで同じfontの重複警告がない。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

Homebrewの二font caskを宣言へ戻し、`fonts.packages`から対応する二packageを外す。
`nix/nix-darwin/system.nix`のHot Corner差分には触れない。
`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後だけ`just switch`を行う。
WezTerm、Zed、Font Bookを再起動し、Homebrew版のfontへ戻ったことを確認する。

## 実装時の制約

- font cacheを初期化する破壊的操作をこのタスクへ含めない。
- `nix/nix-darwin/system.nix`の既存Hot Corner差分を保全する。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
