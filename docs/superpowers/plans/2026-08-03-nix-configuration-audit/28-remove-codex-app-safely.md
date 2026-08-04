# T28 廃止済みCodex appを安全に撤去する

- **Status**: 未着手
- **Audit IDs**: `BREW-01`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: T01（ホストからroleを選ぶ構成）、T14（Homebrew formulaとprefixの整理）

## Goal

廃止済みの`codex-app` caskを撤去し、replacementであるChatGPT desktop appへ移行する。
旧Codex appと新ChatGPT appが共有する可能性のある履歴、project state、設定は失わない。

## Architecture

T01の完了後は`homebrew.onActivation.cleanup = "uninstall"`になっている。
宣言だけを削除して`just switch`してもzapは実行されないが、退避前に旧appを自動撤去させない。

最初にChatGPT appで必要なstateを確認し、旧Codex appの関連データをrepo外へ退避する。
次に、ユーザーの明示的な承認を受けて`brew uninstall --cask codex-app`を一度だけ実行する。
このコマンドへ`--zap`を付けず、`brew uninstall --zap`、`brew zap`、cleanupによる自動撤去も使わない。

通常uninstallが完了してHomebrewのinstall記録から消えた後に、Nixの`codex-app`宣言を削除する。
terminal用の`codex` caskと新しい`chatgpt` caskは維持する。

## 対象ファイル

- Modify: `nix/inventory/software.nix`
- External state backup: 旧Codex appに関連する`~/Library`配下のdata

## 実施手順

- [ ] T01とT14が完了し、`cleanup = "uninstall"`で`zap`を使わない方針を再確認する。
- [ ] `brew info --json=v2 --cask codex-app`で旧caskのartifactsとzap対象を記録する。
- [ ] `brew list --cask codex-app`、`brew list --cask chatgpt`、`brew list --cask codex`で三者を区別する。
- [ ] ChatGPT desktop appへloginし、必要な履歴、project、設定へアクセスできることを手動確認する。
- [ ] 旧Codex appとChatGPT appを終了する。
- [ ] cask metadataに記載された旧Codex appの関連dataを、repo外の権限700の時刻付きdirectoryへ退避する。
- [ ] 退避元と退避先の通常fileについてSHA-256と容量を比較し、backupを検証する。
- [ ] ユーザーからapp削除の明示的な承認を得る。
- [ ] `brew uninstall --cask codex-app`を`--zap`なしで一度だけ実行する。
- [ ] 通常uninstall後も関連dataと退避copyが残り、ChatGPT appが正常起動することを確認する。
- [ ] `nix/inventory/software.nix`から`"codex-app"`だけを削除し、`"codex"`と`"chatgpt"`を維持する。
- [ ] コード変更に`code-simplifier`を適用し、cleanup policyやほかのcaskを変えていないことを確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] ユーザーが適用を明示した場合だけ`just switch`を実行する。
- [ ] 退避directoryは移行完了後もこのタスクでは削除しない。

## 検証コマンドと期待結果

```bash
brew info --json=v2 --cask codex-app
brew list --cask codex-app
brew list --cask chatgpt
brew list --cask codex
```

期待結果は、作業前に旧app、新app、terminal用Codexの状態を個別に記録できることである。

明示的な削除承認を受けた後だけ、次を実行する。

```bash
brew uninstall --cask codex-app
```

期待結果は、`--zap`を使わず旧appだけをuninstallでき、退避対象のuser dataが残ることである。

```bash
brew list --cask codex-app
brew list --cask chatgpt
brew list --cask codex
command -v codex
```

期待結果は、一つ目だけが非0で終了し、ChatGPT app、terminal用Codex、`codex` commandは残ることである。

```bash
nixfmt --check nix/inventory/software.nix
just check
just build
```

期待結果は、すべて終了コード0で完了することである。

```bash
rg -n '"codex-app"|"codex"|"chatgpt"' nix/inventory/software.nix
rg -n 'cleanup = "uninstall"' nix/nix-darwin/homebrew/common.nix
git diff --check
```

期待結果は、`codex-app`だけがなく、`codex`、`chatgpt`、`cleanup = "uninstall"`が残り、空白エラーがないことである。

## 完了条件

- ChatGPT desktop appで必要なstateを確認している。
- 旧Codex appの関連dataを検証済みの退避先に保持している。
- `zap`を一度も使わず、通常uninstallで旧appだけを撤去している。
- `codex-app`宣言だけが削除され、terminal用CodexとChatGPT appが残っている。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

旧caskは廃止済みのため、Homebrewから再installできるとは仮定しない。
通常uninstall直後に問題が見つかった場合は、旧app bundleと関連dataを検証済みbackupから元の場所へ戻す。
Homebrewがまだ`codex-app`を提供している場合に限り宣言を戻し、それ以外はbackupしたapp bundleを一時的な復旧手段とする。
Nix宣言を戻した場合は`nixfmt`、`just check`、`just build`を実行し、ユーザーの明示後だけ`just switch`を行う。
backupは復旧確認が終わっても、このタスク内では削除しない。

## 実装時の制約

- `brew uninstall --zap`、`brew zap`、cleanupによる旧appの自動撤去を使用しない。
- user dataの退避を検証するまで旧appをuninstallしない。
- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
