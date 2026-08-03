# T25 Fish login shellをnix-darwinへ移管する

- **Status**: 未着手
- **Audit IDs**: `SHELL-01`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T01（マルチホスト定義）

## Goal

Fishのinstall、`/etc/shells`への登録、login shellの選択をnix-darwinで宣言する。
Home Managerの直接package指定と手動の`set-fish-default.sh`を廃止する。

## Architecture

system設定で`programs.fish.enable = true`を宣言し、対象userの`users.users.<name>.shell`を`pkgs.fish`へ設定する。
Home Managerの`home.packages`から`fish`を外し、login shell変更用scriptを削除する。

このタスクはFish設定ファイルとpluginの所有権を変えない。
FisherからHome Manager Fish moduleへの移行はT27で行う。

適用前に現在のlogin shellと復旧用shellを記録する。
新しいFishでloginできるまで既存terminalを閉じず、問題があればそのterminalから戻す。

## 対象ファイル

- Modify: `nix/nix-darwin/system.nix`
- Modify: T01で確定したuser module（`nix/nix-darwin/users.nix`を維持した場合は同ファイル）
- Modify: `nix/nix-darwin/home-manager/packages/common.nix`
- Delete: `script/set-fish-default.sh`

## 実施手順

- [ ] T01で確定したuser定義が、現在の全対象ホストに適用されることを確認する。
- [ ] `dscl`、`$SHELL`、`command -v fish`、`/etc/shells`を調べ、現在のshell pathを記録する。
- [ ] `/bin/zsh`などの復旧用shellが起動し、管理者権限を使えることを確認する。
- [ ] `nix/nix-darwin/system.nix`へ`programs.fish.enable = true`を追加する。
- [ ] T01で確定したuser宣言へ`pkgs`を渡し、対象userの`shell = pkgs.fish`を宣言する。
- [ ] Home Managerのpackage一覧から直接指定した`fish`を削除する。
- [ ] `set-fish-default.sh`への参照がないことを確認してからscriptを削除する。
- [ ] コード変更に`code-simplifier`を適用し、Fishのinstall元とlogin shellの宣言が重複していないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] ユーザーが適用を明示した場合だけ、復旧用terminalを残した状態で`just switch`を実行する。
- [ ] 新しいterminalでFishがlogin shellとして起動し、既存のFish設定を読み込めることを確認する。
- [ ] logoutが必要な場合は作業中のアプリを保存し、明示的に行う。

## 検証コマンドと期待結果

```bash
current_user="$(id -un)"
dscl . -read "/Users/${current_user}" UserShell
printf '%s\n' "$SHELL"
command -v fish
grep -n '/fish$' /etc/shells
```

期待結果は、移行前のshellとFish pathを記録でき、復旧時に戻す値が決まることである。

```bash
nixfmt --check \
  nix/nix-darwin/system.nix \
  nix/nix-darwin/home-manager/packages/common.nix
# T01で確定したuser moduleもnixfmt --checkの対象へ加える。
just check
just build
```

期待結果は、すべて終了コード0で完了することである。

```bash
rg -n "set-fish-default|^[[:space:]]+fish$|programs\.fish|shell = pkgs\.fish" nix script justfile
```

期待結果は、手動scriptとHome Managerの直接package指定がなく、nix-darwinのFish有効化とuser shell宣言だけが見つかることである。

適用を明示された後だけ、次を実行する。

```bash
just switch
current_user="$(id -un)"
dscl . -read "/Users/${current_user}" UserShell
grep -n '/fish$' /etc/shells
/run/current-system/sw/bin/fish --login -c 'status is-login; and echo fish-login-ok'
```

期待結果は、user shellがNix管理のFishを指し、`/etc/shells`へ登録され、最後に`fish-login-ok`と表示されることである。

```bash
git diff --check
```

期待結果は、出力なしで終了コードが0になることである。

## 完了条件

- nix-darwinがFishを有効化している。
- 対象userのlogin shellが`pkgs.fish`で宣言されている。
- Home Managerの直接Fish packageと手動scriptがなくなっている。
- 新しいlogin sessionでFishと既存設定が正常に動く。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

動作している復旧用terminalを閉じず、Nix宣言を移行前へ戻す。
Home ManagerのFish packageと必要なら手動scriptを復元する。
`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後に`just switch`を行う。
Nixの適用ができない場合は、事前に記録したshell pathへ`chsh -s`で戻し、新しいlogin sessionを確認する。

## 実装時の制約

- 復旧用shellを確認せず、現在のlogin shellを切り替えない。
- `nix/nix-darwin/system.nix`の既存Hot Corner差分を保全する。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
