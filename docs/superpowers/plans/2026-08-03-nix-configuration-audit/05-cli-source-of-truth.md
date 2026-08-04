# T05 GitとLuarocksの供給元を一本化する

- Status: 未着手
- Audit IDs: `PKG-08`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: `T01 マルチホスト構成を tracked host registry へ移行する`

## Goal

FishとZshで異なり得るGitとLuarocksの実行元を一つに決め、PATH順と宣言packageを一致させる。

測定後の既定選択は`git=Nix`、`luarocks=mise`とする。
helperやLua 5.1との互換性を確認してから、Nix側の重複packageとPATHの逆転を修正する。

## Architecture

Gitは`pkgs.git`を宣言的な供給元として維持し、Home Managerのuser profileをHomebrewより前に置く。
Homebrew Gitはこの構成で直接宣言していないため、このタスクでは命令的にuninstallしない。

Lua 5.1はmiseが管理しているため、Luarocksも同じruntimeに属するmise版を正とする。
`pkgs.luarocks`をHome Manager packageから外し、Lua ABIが分かれないようにする。

実測でGit helperがNix版では動かない、またはmise版Luarocksが存在しないと分かった場合は変更せず停止し、利用者へ供給元の再選択を求める。
調査だけで完了とはせず、互換性を確認できた選択を必ず設定へ反映する。

## 対象ファイル

- `nix/inventory/software.nix`
- `config/zsh/.zshenv`
- `config/fish/config.d/path.fish`
- `config/mise/config.toml`（必要な場合のみ）

## 未チェックの実施手順

- [ ] FishとZshのlogin shellで`git`、`luarocks`、`lua`の全候補pathとversionを採取する。
- [ ] `git-lfs`、credential helper、署名、GitHub CLI連携など、現在使うGit helperを確認する。
- [ ] miseのLuaとLuarocksが同じLua 5.1 treeを参照することを確認する。
- [ ] 互換性を確認できたら`pkgs.git`を維持し、`pkgs.luarocks`をsoftware inventoryのcommon `nixPackages`から削除する。
- [ ] ZshでHomebrew Gitが先なら、Home Manager user profileがHomebrewより前になるようPATH組立順を直す。
- [ ] Fishは実測で順序が誤っている場合だけ変更する。
- [ ] mise shimsの位置はNode、Python、Luaのversion選択を壊さない範囲で維持する。
- [ ] Homebrew Gitを命令的にuninstallせず、宣言管理外のcleanupを混ぜない。
- [ ] 両shellで基本Git操作とLuarocksのLua 5.1向けpathを再確認する。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
fish -lc 'type -a git; type -a lua; type -a luarocks; git --version; lua -v; luarocks --version'
zsh -lic 'whence -a git; whence -a lua; whence -a luarocks; git --version; lua -v; luarocks --version'
```

期待結果: 両shellの先頭GitがNix profileを指し、LuaとLuarocksがmise管理のLua 5.1系で一致する。

```sh
git status --short
git config --get credential.helper
luarocks --lua-version=5.1 path
```

期待結果: repository操作、credential helperの解決、Lua 5.1向けrock treeの表示が成功する。

```sh
nixfmt nix/inventory/software.nix
just check
just build
git diff --check
```

期待結果: `pkgs.luarocks`を外した構成をbuildでき、whitespace errorがない。

## 完了条件

- FishとZshでGitの先頭候補がNix版に揃っている。
- Luarocksがmise版に揃い、Nix packageの重複がない。
- Git helperとLua 5.1の基本操作が成功している。
- 測定結果が既定選択を否定した場合は、設定を半端に変えず停止している。
- `just check`と`just build`が成功している。

## ロールバック

`pkgs.luarocks`をsoftware inventoryのcommon `nixPackages`へ戻し、FishまたはZshのPATH変更を直前の順序へ戻す。
Gitは削除しないため、Nix版Gitの復元作業は不要である。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
