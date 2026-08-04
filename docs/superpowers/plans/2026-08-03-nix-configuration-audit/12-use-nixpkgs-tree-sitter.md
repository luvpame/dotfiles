# T12: Tree-sitter CLIをnixpkgs版へ置き換える

- Status: 未着手
- Audit IDs: PKG-01
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T01。T15より先に完了させる。

## Goal

独自のTree-sitter CLI derivationを削除し、固定中のnixpkgsが供給するpkgs.tree-sitterへ一本化する。

## Architecture

Home Managerのpackage listでcallPackageしている独自packageをpkgs.tree-sitterへ置き換える。
独自derivationは削除し、version、Cargo hash、doCheck、補完をnixpkgs側へ委ねる。
nix/AGENTS.mdのcustom package例も現状に合わせる。

## 対象ファイル

- 変更: nix/inventory/software.nix
- 削除: nix/pkgs/tree-sitter-cli/default.nix
- 変更: nix/AGENTS.md

## 未チェックの実施手順

- [ ] 固定nixpkgsのpkgs.tree-sitterがCLIとmainProgramを持つことを評価結果で再確認する。
- [ ] software inventoryのcommon `nixPackages`にある独自callPackageをtree-sitterへ置き換える。
- [ ] nix/pkgs/tree-sitter-cli/default.nixを削除する。
- [ ] nix/AGENTS.mdからtree-sitter-cliをcustom package例として扱う記述を外す。
- [ ] 変更したNixファイルへnixfmtを実行する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] Hunkでpackage置換と削除以外の差分がないことを確認する。

## 検証コマンドと期待結果

~~~console
nixfmt --check nix/inventory/software.nix
just check
just build
~~~

すべてexit 0になり、削除したpathへの参照が評価に残らないこと。

適用を許可された場合だけ、次も確認する。

~~~console
just switch
command -v tree-sitter
tree-sitter --version
tree-sitter --help
~~~

tree-sitterがNix profileから見つかり、固定nixpkgsのversionで起動すること。

## 完了条件

- nix/pkgs/tree-sitter-cliが存在しない。
- package listがpkgs.tree-sitterを使う。
- Tree-sitter CLIの起動とhelp表示を確認できる。
- just checkとjust buildが成功する。

## ロールバック

このタスクで削除したderivationを同じ内容で戻し、package listのcallPackage参照を復元する。
switch済みなら前のdarwin generationへ戻し、CLIの利用を継続できる状態にする。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
