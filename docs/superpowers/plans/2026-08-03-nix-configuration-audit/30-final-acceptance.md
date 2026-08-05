# T30 全変更を統合検証する

- **Status**: 未着手
- **Audit IDs**: 実施対象として選ばれた全監査ID
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: 実施対象に選ばれたT01からT29までの全タスク

## Goal

実施したタスクが一つのdarwin構成として評価、build、適用でき、日常利用するshell、app、security設定、runtime stateが正常に動くことを確認する。
未実施タスクは完了扱いにせず、受け入れ対象から外す。

## Architecture

受け入れ確認を三段階に分ける。
最初に差分、format、flake評価を読み取り専用で確認する。
次に`just check`と`just build`で適用前の構成を検証する。
最後の`just switch`、logout、app削除、state移行は自動実行せず、影響と退避状況を提示してユーザーが明示した場合だけ進める。

失敗を統合タスク内で場当たり的に修正しない。
失敗した設定を所有する元タスクへ戻し、そのタスクの検証とロールバック手順を使う。

## 対象ファイル

- Verify: 実施対象の各タスクが変更した全ファイル
- Verify: `docs/superpowers/plans/2026-08-03-nix-configuration-audit/guardrails.md`
- Source changes: なし

## 実施手順

- [ ] 実施したタスクIDと未実施タスクIDを一覧化し、受け入れ範囲を固定する。
- [ ] `git status --short`、`git diff --stat`、`git diff`を確認し、棚卸し前から存在した変更を分ける。
- [ ] `nix/local.nix`が未追跡のままで、内容がdiffやlogへ出ていないことを確認する。
- [ ] `system.nix`のHot Corner差分が保全され、実施タスクへ混入していないことを確認する。
- [ ] `guardrails.md`の見送り項目と現状維持項目に反する差分がないことを確認する。
- [ ] 各実装タスクでコード変更後に`code-simplifier`を適用し、再検証した記録があることを確認する。
- [ ] 変更した全Nixファイルへ`nixfmt --check`を実行する。
- [ ] `git diff --check`、`just check`、`just build`を順に実行する。
- [ ] build結果から対象darwin configurationが作成され、warningとtraceに新しい未解決事項がないことを確認する。
- [ ] state移行を含むT22、T23、T24、T27、T28を実施した場合、退避先と復旧手順を再確認する。
- [ ] T25を実施した場合、復旧用shellを起動したterminalが残っていることを確認する。
- [ ] 適用される変更、logoutの要否、外部stateへの影響をユーザーへ提示する。
- [ ] ユーザーが明示的に適用を選んだ場合だけ`just switch`を実行する。
- [ ] switch後のsmoke testを、実施したタスクだけについて行う。
- [ ] logoutが必要なT21またはT29を実施した場合、作業中のアプリを保存し、ユーザーが明示した後にlogoutする。
- [ ] 最後に`git status --short`と`git diff --check`を再実行し、検証が新しいrepo変更を作っていないことを確認する。
- [ ] Gitコミットは、ユーザーが明示的に依頼した場合だけ別途行う。

## 検証コマンドと期待結果

### 差分とformat

```bash
git status --short
git diff --stat
git diff --check
git diff --name-only -- '*.nix'
```

期待結果は、変更が実施対象タスクと既存の保全対象だけに限られ、空白エラーがないことである。
最後の出力にある全Nixファイルを明示して、次を実行する。

```bash
nixfmt --check <変更したNixファイル...>
```

期待結果は、出力なしで終了コードが0になることである。

### Flakeとdarwin build

```bash
just check
just build
```

期待結果は、両方が終了コード0で完了し、対象darwin configurationのbuild結果を得られることである。

```bash
nix flake show ./nix
```

期待結果は、対象darwin configuration、formatter、実施したchecksが評価できることである。

### 明示的な適用段階

次のコマンドは自動実行しない。
ユーザーがbuild結果、退避状態、影響範囲を確認して適用を明示した場合だけ実行する。

```bash
just switch
```

期待結果は、新しいsystem generationへ切り替わり、activationが終了コード0で完了することである。

### 適用後のsmoke test

実施したタスクに対応する項目だけを確認する。

```bash
fish --login -i -c 'echo fish-login-ok'
fish --login -c 'type -q direnv; and direnv version'
zsh -lic 'command -v direnv && direnv version'
command -v git
command -v luarocks
command -v tree-sitter
```

期待結果は、移行したshellとCLIが一意の供給元から起動し、終了コード0になることである。

```bash
test -d "$HOME/.config/herdr" && test ! -L "$HOME/.config/herdr"
for file in agent-git-metadata.py config.toml worktree-fzf.fish; do
  test -L "$HOME/.config/herdr/$file"
done
test -d "$HOME/.config/hunk" && test ! -L "$HOME/.config/hunk"
test -L "$HOME/.config/hunk/config.toml"
test -f "$HOME/.config/hunk/state.json"
```

期待結果は、T23とT24を実施した場合にすべて終了コード0となり、runtime stateがlocal directoryへ残ることである。

```bash
test -d "$HOME/Applications/Home Manager Apps"
test ! -L "$HOME/Applications/Home Manager Apps"
brew list --cask chatgpt
brew list --cask codex
brew list --cask codex-app
find '/Library/Fonts/Nix Fonts' -maxdepth 2 -type f | rg -i 'HackGen|Monaspace'
```

期待結果は、対応タスクを実施した場合にHome Manager Appsが実directoryになり、ChatGPTとterminal用Codexが残ることである。
`codex-app`の確認だけは非0で終了し、Nix Fonts配下で両fontを確認できる。

Application Firewall、ロック直後の再認証、Dock、AeroSpace、Spotlight、Font Book、WezTerm、ZedはGUIで確認する。
複数displayとfontの変更は、明示的なlogout後にも確認する。

## 完了条件

- 実施対象と未実施タスクが明確に分かれている。
- guardrailに反する変更と、既存変更の巻き込みがない。
- 変更した全Nixファイルで`nixfmt --check`が成功している。
- `git diff --check`、`just check`、`just build`が成功している。
- `just switch`はユーザーが明示した場合だけ実行している。
- 実施したタスクのCLI、GUI、runtime state、security設定のsmoke testが成功している。
- state移行の退避copyを削除していない。
- 検証後に新しい意図しないrepo変更がない。

## ロールバック

`just switch`前に失敗した場合は適用せず、失敗した設定を所有する元タスクへ戻す。
switch後に失敗した場合は、既知の正常なsystem generationへ戻し、元タスクのロールバック手順を実行する。
Herdr、Hunk、Fish、Home Manager Apps、Codex appのstateは、各タスクの退避copyから復元するまで削除しない。
複数タスクを同時に戻さず、失敗との因果が確認できる最小のタスク単位で戻して`just check`と`just build`を再実行する。

## 実装時の制約

- `just switch`、logout、app削除、runtime state移行を自動実行しない。
- Nixファイルを変更したタスクでは`nixfmt`、`just check`、`just build`が成功していることを確認する。
- コードを変更したタスクでは`code-simplifier`を適用し、検証をもう一度実行したことを確認する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
