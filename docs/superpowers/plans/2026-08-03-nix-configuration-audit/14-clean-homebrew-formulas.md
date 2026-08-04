# T14: Homebrew formulaとprefixの重複を整理する

- Status: 未着手
- Audit IDs: BREW-02、BREW-06、BREW-07、BREW-08、BREW-12
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T01、T05。T18はこのタスクの完了後に実施する。

## Goal

不要または重複しているHomebrew formulaを除去し、Homebrew prefixをnix-darwinのoptionから参照する。
T01で確立したMAS appとcleanupの構成は変更せず、対話用mas CLIだけを常設対象から外す。

## Architecture

T01で`extraFlags`を削除済みであることを確認し、このタスクではactivation policyを変更しない。
rootsとHomebrew版ripgrepをbrewsから外し、ripgrepはNix版を正とする。
mas formulaだけを削除し、`programs.mas.packages`とホスト別の`programs.mas.cleanup`を維持する。
独自のhomebrewPrefix定数はconfig.homebrew.prefixへ置き換える。

## 対象ファイル

- 変更: nix/inventory/software.nix
- 変更: nix/nix-darwin/homebrew/common.nix
- 条件付き変更: README.md（mas formulaの常設を前提にした説明が見つかった場合だけ）

## 未チェックの実施手順

- [ ] repo内のscript、alias、運用文書を検索し、対話的にmas commandを使っていないか確認する。
- [ ] 対話利用が見つかった場合は作業を停止し、no-cliという回答との不一致をユーザーへ報告する。
- [ ] `software.nix`のcommon brewsからmas、roots、ripgrepを削除する。
- [ ] `programs.mas.packages`とホスト別の`programs.mas.cleanup`を変更していないことを確認する。
- [ ] `onActivation.extraFlags`がT01で削除済みであることを確認する。
- [ ] module引数へconfigを加え、hard-coded prefixをconfig.homebrew.prefixへ置き換える。
- [ ] k1LoW tapはmoが使うため、このタスクでは削除しない。
- [ ] 変更したNixファイルへnixfmtを実行する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] HunkでMAS app宣言とcleanup policyが変わっていないことを確認する。

## 検証コマンドと期待結果

~~~console
nixfmt --check nix/inventory/software.nix nix/nix-darwin/homebrew/common.nix
just check
just build
~~~

すべてexit 0になり、生成されるHomebrew構成にmas、roots、ripgrepのformulaが含まれないこと。
`programs.mas.packages`は変更前と同じApp IDを持つこと。

適用を許可された場合だけ、次も確認する。

~~~console
just switch
brew list --formula
type -a rg
command -v mas
~~~

brew listにmas、roots、ripgrepがなく、rgの優先実体がNix profileになること。
command -v masは見つからないこと。
宣言済みのApp Store applicationは削除されないこと。

## 完了条件

- force-cleanupが二重指定されない。
- roots、Homebrew版ripgrep、対話用mas formulaが削除される。
- `programs.mas.packages`とホスト別のcleanup policyが維持されている。
- prefixがconfig.homebrew.prefixに一本化される。
- just checkとjust buildが成功する。

## ロールバック

このタスクの変更だけを逆向きに適用し、必要なformulaとprefix参照を元へ戻す。
`programs.mas.packages`には触れていないため、App Store appの宣言自体をロールバック対象に含めない。
switch後の問題は前のdarwin generationへ戻して切り分ける。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
