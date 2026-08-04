# T07 Caskの更新責任とgreedy policyを確定する

- Status: 未着手
- Audit IDs: `BREW-13`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 依存先: `T01 ホストから仕事用と私用の構成を一意に選ぶ`

## Goal

自己更新するCaskをapplicationとHomebrewのどちらが更新するか決め、二重更新を避ける。

T01で確定した`autoUpdate = true`、`upgrade = true`、`cleanup = "uninstall"`は維持する。
`greedy`は全体へ一律適用せず、Homebrewに更新を任せると決めたCaskだけへ設定する。

## Architecture

`brew info --cask --json=v2`の`auto_updates`と`version`を使ってinventoryを作る。
自動更新機能を使うapplicationは現状どおりgreedy対象外とし、application側のupdaterへ任せる。

利用者がHomebrewへ更新を統一したいCaskだけ、string宣言を`{ name = "..."; greedy = true; }`へ変える。
globalな`homebrew.greedyCasks`は使わない。
選択対象が0件なら設定は変更せず、inventoryと「app updaterを使う」という判断だけを記録して完了する。

## 対象ファイル

- `nix/inventory/software.nix`
- `nix/nix-darwin/homebrew/common.nix`
- この計画ファイル（Caskごとの判断を記録する）

## 未チェックの実施手順

- [ ] `software.nix`のcommon、private、workからCask名を抽出する。
- [ ] 各Caskの`auto_updates`、version、更新方法を`brew info --cask --json=v2`で確認する。
- [ ] 自己更新するCaskごとに、application updaterかHomebrewのどちらへ任せるか利用者の現行運用と照合する。
- [ ] license prompt、大容量download、再起動、権限付与が必要なapplicationを識別する。
- [ ] Homebrew管理を選んだitemだけ`greedy = true`の属性setへ変える。
- [ ] app updater管理を選んだitemはstringのまま維持する。
- [ ] globalな`homebrew.greedyCasks`を追加しない。
- [ ] T01で設定したactivationの`autoUpdate`、`upgrade`、`cleanup`を変更しない。
- [ ] `brew upgrade --cask --greedy`を手動実行せず、変更対象のpreviewだけ確認する。
- [ ] 変更したコードへ`code-simplifier`スキルを適用する。
- [ ] 変更したNixファイルを`nixfmt`で整形する。

## 検証コマンドと期待結果

```sh
brew info --cask --json=v2 <cask-name>
brew outdated --cask --greedy
```

期待結果: 各Caskの自己更新flagを確認でき、greedy対象候補を更新せずにpreviewできる。

```sh
nixfmt nix/inventory/software.nix nix/nix-darwin/homebrew/common.nix
just check
just build
git diff --check
```

期待結果: stringと属性setを混在させたCask宣言を評価でき、darwin system buildが成功する。

switchを別途許可された場合だけ、適用後に次を確認する。

```sh
brew outdated --cask
brew outdated --cask --greedy
```

期待結果: 通常対象とgreedy対象の差が、記録した更新責任と一致する。

## 完了条件

- 自己更新するCaskごとに更新主体が決まっている。
- `greedy = true`はHomebrew管理を選んだitemだけに付いている。
- global greedy、activation policy変更、実際の大量upgradeを同じタスクへ含めていない。
- greedy対象が0件なら、その判断が記録されている。
- `just check`と`just build`が成功している。

## ロールバック

item単位の属性setを元のCask名stringへ戻す。
このタスクではupgradeを実行しないため、application versionのrollbackは不要である。

## 作業規約

`nix/local.nix`の内容を読んだり文書へ記載したりしない。
コードを変更した後は`code-simplifier`スキルを適用する。
Nix変更は`nixfmt`、`just check`、`just build`で検証する。
Git commitは利用者から明示的に依頼された場合だけ行う。
