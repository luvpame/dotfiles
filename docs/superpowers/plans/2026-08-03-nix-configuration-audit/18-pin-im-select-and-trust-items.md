# T18: im-selectを固定しHomebrew trustをitem単位へ狭める

- Status: 未着手
- Audit IDs: BREW-04、BREW-05
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T14

## Goal

mutableなmasterと空hashから配布されるim-selectを固定可能なNix packageへ移す。
移行を確認したあと、第三者tap全体ではなく実際に使うformulaとcaskだけを信頼する。

## Architecture

im-selectはimmutableなreleaseまたはcommit URLとhashを使う小さなcustom Nix packageにする。
Home Managerのcommon packageへ追加し、IME menu bar scriptはNix user profileをHomebrewより先に探索する。
Nix版の動作確認が終わるまでHomebrew版を残し、確認後にbrewとdaipeihust/tapを削除する。

残る第三者itemはsoftware inventoryで完全修飾名へ変え、各itemへtrusted = trueを設定する。
対象はaerospace、mo、a-bar、cage、portkiller、ziggityである。
Homebrew adapterがscope全体のtapをまとめてtrustedにする仕組みは削除する。

## 対象ファイル

- 作成: nix/pkgs/im-select/default.nix
- 変更: nix/inventory/software.nix
- 変更: menubar-script/ime/read-state.sh
- 変更: nix/nix-darwin/homebrew/common.nix
- 条件付き変更: nix/AGENTS.md

## 未チェックの実施手順

- [ ] upstreamのreleaseまたはcommitからimmutableな取得元を選び、内容を確認してhashを計算する。
- [ ] versionとhashを明示したim-select packageを作成する。
- [ ] software inventoryのcommon `nixPackages`へim-selectを追加する。
- [ ] IME scriptのPATHへNix user profileとsystem profileをHomebrewより前に追加する。
- [ ] nixfmt、just check、just buildを実行し、許可された場合だけ一度switchする。
- [ ] commandとIME scriptの動作を確認する。失敗した場合はここで停止し、Homebrew版を削除しない。
- [ ] Nix版の確認後にHomebrew版im-selectを削除する。
- [ ] 第三者formulaとcaskを完全修飾名へ変え、itemごとのtrusted = trueへ移す。
- [ ] Homebrew adapterからtap集合をまとめてtrustedへ変換する処理を削除する。
- [ ] software inventoryの`taps`は三scopeで空にし、将来の第三者itemも完全修飾名で宣言する説明へ直す。
- [ ] もう一度nixfmt、just check、just buildを実行し、許可された場合だけswitchする。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] Hunkで二段階の移行順とitem単位trustを確認する。

## 検証コマンドと期待結果

~~~console
nixfmt --check nix/pkgs/im-select/default.nix nix/inventory/software.nix nix/nix-darwin/homebrew/common.nix
just check
just build
~~~

すべてexit 0になり、取得元がimmutableでhashを持つこと。

各段階の適用を許可された場合だけ、次も確認する。

~~~console
just switch
type -a im-select
im-select
env -i HOME="$HOME" USER="$USER" PATH=/usr/bin:/bin menubar-script/ime/read-state.sh
brew list --formula im-select
~~~

im-selectの先頭がNix profileになり、IME scriptがA、あ、または?を返すこと。
最終段階ではbrew listがim-selectを見つけないこと。
第三者itemの導入は成功し、tap全体を自動trustするNix式が残らないこと。

## 完了条件

- im-selectの取得元と内容がrevisionとhashで固定される。
- IME menu bar scriptがNix版im-selectで動作する。
- Homebrew版im-selectはNix版の確認後にだけ削除される。
- 第三者tapのtrustが必要itemへ限定される。
- just checkとjust buildが成功する。

## ロールバック

第一段階で失敗した場合はNix packageとPATH変更だけを戻し、Homebrew版を維持する。
第二段階で問題が出た場合は、im-selectを含む必要itemだけを完全修飾名かつitem単位trustedで一時復旧する。
tap全体を自動trustする旧方式には戻さない。
switch済みなら前のdarwin generationへ戻してIME表示を復旧する。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
Shell変更は既存のset -euo pipefailとPATH方針へ合わせる。
コード変更後はcode-simplifierスキルを適用する。
