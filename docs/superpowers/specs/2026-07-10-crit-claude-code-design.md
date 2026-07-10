# Crit の Claude Code 導入設計

## 目的

Claude Code の計画とコード変更を Crit のブラウザ画面でレビューできるようにする。

Plan mode の終了時に Crit を開き、利用者が計画を承認するまで実装へ進まないレビュー経路を設ける。

## 背景

現在は `PreToolUse` の `ExitPlanMode` hook が最新の計画ファイルを `mo` で開いている。

この hook は計画を表示するだけであり、行単位のコメント、修正ラウンド、承認状態を Claude Code へ返さない。

Crit の公式 Claude Code プラグインは `/crit` skill、`crit-cli` skill、`ExitPlanMode` の review hook をまとめて提供する。

## 方針

Crit CLI は Homebrew で仕事用プロファイルへ追加する。

Claude Code との統合には、公式 Marketplace の `crit@crit` プラグインをユーザースコープで使う。

この方式は既存の Claude Code プラグイン管理と同じであり、プラグイン本体と更新は Claude Code に任せられる。

Crit の plugin ファイルや skills は dotfiles へ複製しない。

## 変更範囲

### `nix/nix-darwin/homebrew/work.nix`

`brews` に `crit` を追加する。

Claude Code 自体が仕事用プロファイルだけに導入されているため、Crit も同じプロファイルに限定する。

### `config/claude/settings.json`

`PreToolUse` から `ExitPlanMode` を対象に `mo` を起動する hook を削除する。

Crit への置換後は使われないため、`SessionEnd` の `mo --shutdown` と `mo --clear` を実行する hook も削除する。

`enabledPlugins` に `crit@crit` を追加する。

### Claude Code のユーザー状態

公式コマンドで Marketplace を登録し、プラグインをインストールする。

```sh
claude plugin marketplace add tomasz-tomczyk/crit
claude plugin install crit@crit --scope user
```

Marketplace の checkout、plugin cache、インストール記録は既存プラグインと同様に `~/.claude/plugins/` で Claude Code が管理する。

## 動作

Plan mode で Claude Code が `ExitPlanMode` の許可を求めると、プラグインの `PermissionRequest` hook が `crit plan-hook` を実行する。

Crit は計画をブラウザで開き、行単位のコメントを受け取る。

未解決のコメントがあれば Claude Code は Plan mode を続け、計画を修正する。

コメントなしで承認されると Plan mode を終了する。

計画以外のファイル、コード差分、PR、実行中の画面は `/crit` から任意にレビューする。

## エラー処理

Crit CLI を利用できない状態で plugin hook だけを有効にしないよう、CLI の導入と plugin のインストールを同じ変更で扱う。

一時的に Plan mode のレビューを止める場合は、Claude Code の起動環境で `CRIT_PLAN_REVIEW=off` を設定する。

初期導入では `~/.crit.config.json` を作らず、bind 先や共有設定を含む既定値を変更しない。

## 検証

- `jq empty config/claude/settings.json` で JSON の構文を確認する。
- `nixfmt nix/nix-darwin/homebrew/work.nix` を実行する。
- `just check` で Nix 設定を評価する。
- `crit --version` で CLI を確認する。
- `claude plugin list` で `crit@crit` がユーザースコープで有効なことを確認する。
- Claude Code の Plan mode を終了し、Crit が開いて承認後に Plan mode を抜けることを手動確認する。

## 非対象

- Codex への Crit 導入
- Crit plugin または skills のリポジトリ内への複製
- `mo` のアンインストール
- Crit の Share、認証、セルフホスト設定
- `agent_cmd` の設定
- Crit のグローバル設定ファイル追加
