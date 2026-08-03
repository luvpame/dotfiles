# T15: nixpkgsとnix-darwinの入力を更新する

- Status: 未着手
- Audit IDs: FLAKE-01、FLAKE-02
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T10、T11、T12、T13

## Goal

macOS向けnixpkgsをnixpkgs-unstableへ切り替え、nix-darwinをorganization移管後のcanonical URLで追跡する。

## Architecture

flake.nixのnixpkgs inputをgithub:NixOS/nixpkgs/nixpkgs-unstableへ変更する。
nix-darwin inputはgithub:nix-darwin/nix-darwin/masterへ変更し、nixpkgsへのfollowsを維持する。
flake.lockはNix commandで対象inputを更新し、手で編集しない。
ほかのinputは意図的に更新しない。

## 対象ファイル

- 変更: nix/flake.nix
- 変更: nix/flake.lock

## 未チェックの実施手順

- [ ] 作業開始時にflake.lockの既存差分を確認する。
- [ ] flake.lockに別作業の未コミット差分がある場合は着手せず、ユーザーがその差分を確定または退避するまで停止する。
- [ ] nixpkgs URLをnixpkgs-unstableへ変更する。
- [ ] nix-darwin URLをcanonical ownerとmaster branchへ変更する。
- [ ] nixディレクトリで対象inputだけを指定してlockを更新する。
- [ ] lock差分を確認し、nixpkgsとnix-darwin、およびそれらに従属する必須node以外が動いていないことを確認する。
- [ ] flake.lockを手動で修正しない。
- [ ] flake.nixへnixfmtを実行する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] HunkでURLとlock更新の範囲を確認する。

## 検証コマンドと期待結果

~~~console
cd nix
nix flake update nixpkgs nix-darwin
nixfmt --check flake.nix
nix flake metadata
cd ..
just check
just build
~~~

metadataがnixpkgs-unstableとcanonicalなnix-darwin inputを示し、just checkとjust buildが成功すること。
既存のClaude、Crit、Herdr、Hunkなどの入力方針が変わっていないこと。

適用を許可された場合はjust switch後に、Fish、Home Manager package、Homebrew activation、主要CLI、GUI applicationの起動を確認する。

## 完了条件

- flake.nixがnixpkgs-unstableとcanonicalなnix-darwin URLを使う。
- flake.lockがNix commandで更新され、無関係なinput更新を含まない。
- full evaluationとdarwin buildが成功する。
- 主要packageの回帰確認結果が記録される。

## ロールバック

着手前に保存したtask単位のpatchを逆向きに適用し、flake.nixとflake.lockを同じ時点へ戻す。
flake.lockは断片的に手編集しない。
switch済みなら前のdarwin generationへ戻し、古いlockでjust buildが通ることを確認する。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
