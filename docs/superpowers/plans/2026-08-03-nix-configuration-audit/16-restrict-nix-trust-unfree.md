# T16: Nixのtrusted userとunfree許可を絞る

- Status: 未着手
- Audit IDs: CORE-02、CORE-03、PKG-07
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: T15

## Goal

通常ユーザーへNix daemonのtrusted権限を与えず、root側nixpkgsが許可するunfree packageを必要な名前だけに限定する。
Claudeは回答どおりclaude-code-overlayのflake packageを直接使い、専用cacheも維持する。

## Architecture

nix.settings.trusted-usersの明示設定を削除し、Nixの既定でrootだけをtrusted userにする。
nixpkgs.config.allowUnfreeはallowUnfreePackagesへ置き換え、現在のroot nixpkgsで必要な7zzだけを許可する。
Claudeはglobal overlay経由のpkgs.claude-codeではなく、claude-code-overlay inputのdefault packageをsoftware inventoryのwork scopeから直接参照する。
claude-code-overlay input、extra-substituters、extra-trusted-public-keysは削除しない。
PKG-07は現状維持の注記に分けず、このタスクで供給方法まで確定する。

## 対象ファイル

- 変更: nix/nix-darwin/nix-core.nix
- 変更: nix/inventory/software.nix
- 確認のみ: nix/flake.nix

## 未チェックの実施手順

- [ ] 固定nixpkgsでpkgs.lib.getName pkgs._7zz-rarが7zzになることを再確認する。
- [ ] Claudeのdirect flake packageがaarch64-darwinで評価できることを確認する。
- [ ] allowUnfreeをallowUnfreePackagesの7zz allowlistへ置き換える。
- [ ] claude-code-overlayのglobal overlay登録を削除する。
- [ ] work scopeのClaude packageをflake inputへの直接参照へ変更する。
- [ ] trusted-usersの明示設定を削除し、通常ユーザー名をdaemonのtrusted userへ残さない。
- [ ] Claude用substituterと公開鍵が変更されていないことを確認する。
- [ ] 変更したNixファイルへnixfmtを実行する。
- [ ] コード変更後にcode-simplifierスキルを適用する。
- [ ] HunkでClaude inputとcacheを維持したまま権限だけを縮小していることを確認する。

## 検証コマンドと期待結果

~~~console
nix eval --raw --impure --expr 'let f = builtins.getFlake (toString ./nix); pkgs = f.inputs.nixpkgs.legacyPackages.aarch64-darwin; in pkgs.lib.getName pkgs._7zz-rar'
nixfmt --check nix/inventory/software.nix nix/nix-darwin/nix-core.nix
just check
just build
~~~

最初のcommandは7zzを出力し、Nixの検証はすべてexit 0になること。
Claudeのpackageを評価してもglobal overlayを必要としないこと。

適用を許可された場合だけ、次も確認する。

~~~console
just switch
nix config show trusted-users
nix config show extra-substituters
nix config show extra-trusted-public-keys
claude --version
7zz
~~~

trusted-usersはrootだけになり、Claude用cacheと公開鍵は残ること。
Claudeと7zzが起動すること。
通常ユーザーから未宣言のsubstituterを追加する操作が拒否されても、宣言済みcacheを使う通常buildは成功すること。

## 完了条件

- 通常ユーザーがtrusted-usersに含まれない。
- root nixpkgsのunfree許可が7zzへ限定される。
- Claudeがflake packageの直接参照から供給される。
- Claude用input、cache、公開鍵が維持される。
- just checkとjust buildが成功する。

## ロールバック

問題を権限、unfree allowlist、Claude供給元のどれかへ切り分け、このタスクの対応する差分だけを戻す。
緊急時は前のdarwin generationへ戻す。
Claude cache設定は本タスクで削除しないため、ロールバックでも変更しない。

## 実行上の規約

コミットはユーザーが明示的に依頼した場合だけ行う。
Nix変更後はnixfmt、just check、just buildを実行する。
コード変更後はcode-simplifierスキルを適用する。
