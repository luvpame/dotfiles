# Crit の Claude Code 導入設計

## 目的

Claude Code の計画とコード変更を Crit のブラウザ画面でレビューできるようにする。

Plan mode の終了時に Crit を開き、利用者が計画を承認するまで実装へ進まないレビュー経路を設ける。

Crit CLI と Claude Code plugin は Nix と Home Manager だけで配布し、インストールコマンドを直接実行しない。

## 背景

従来は `PreToolUse` の `ExitPlanMode` hook が最新の計画ファイルを `mo` で開いていた。

この hook は計画を表示するだけであり、行単位のコメント、修正ラウンド、承認状態を Claude Code へ返さない。

Crit の公式 Claude Code plugin は `/crit` skill、`crit-cli` skill、`ExitPlanMode` の review hook をまとめて提供する。

Claude Code の `enabledPlugins` は plugin の有効状態だけを管理し、外部 plugin 自体はインストールしない。

## 方針

Crit の公式 flake を input に追加し、Crit CLI を仕事用 Home Manager package として導入する。

Claude Code は `writeShellScriptBin` でラップし、公式 plugin directory を `--plugin-dir` へ常に渡す。

`--plugin-dir` は plugin を Marketplace cache へコピーせず、指定 directory から session ごとに読み込む Claude Code の公式機能である。

この方式により、`brew install`、`claude plugin marketplace add`、`claude plugin install` を実行せずに plugin の skills と hook を有効にする。

## 変更範囲

### `nix/flake.nix`

`github:tomasz-tomczyk/crit` を input に追加し、`nixpkgs` はルート input に追従させる。

### `nix/flake.lock`

Crit の revision と依存関係を固定する。

### `nix/nix-darwin/home-manager/packages/work.nix`

Crit CLI を `inputs.crit.packages.${system}.default` から仕事用 package に追加する。

既存の `claude-code` package は、同じバイナリへ `--plugin-dir ${inputs.crit}/integrations/claude-code` を付けて委譲する wrapper に置き換える。

### `nix/nix-darwin/homebrew/work.nix`

誤って追加した Homebrew formula `crit` を削除する。

### `config/claude/settings.json`

`mo` の `ExitPlanMode` 表示 hook と `SessionEnd` cleanup hook は削除した状態を維持する。

Marketplace install を前提とする `crit@crit` の `enabledPlugins` entry は削除する。

## 動作

Home Manager の反映後、`claude` wrapper は Nix store 内の Claude Code を Crit plugin directory 付きで起動する。

Plan mode で Claude Code が `ExitPlanMode` の許可を求めると、plugin の `PermissionRequest` hook が PATH 上の `crit plan-hook` を実行する。

Crit は計画をブラウザで開き、行単位のコメントを受け取る。

未解決のコメントがあれば Claude Code は Plan mode を続け、コメントなしで承認されると Plan mode を終了する。

計画以外のファイル、コード差分、PR、実行中の画面は `/crit` から任意にレビューする。

## エラー処理

Crit CLI、Claude Code、plugin directory は同じ Home Manager generation に含め、片方だけが有効になる状態を作らない。

一時的に Plan mode のレビューを止める場合は、Claude Code の起動環境で `CRIT_PLAN_REVIEW=off` を設定する。

初期導入では `~/.crit.config.json` を作らず、bind 先や共有設定を含む既定値を変更しない。

## 検証

- `nixfmt` で変更した Nix ファイルを整形する。
- `jq empty config/claude/settings.json` で JSON の構文を確認する。
- `nix flake check` で flake と darwin 構成を評価する。
- Home Manager package list に Crit CLI と Claude wrapper が含まれることを評価する。
- wrapper が公式 Crit plugin directory を `--plugin-dir` へ渡すことを確認する。
- Crit plugin の manifest と `PermissionRequest: ExitPlanMode` hook を確認する。
- Home Manager 反映後に Claude Code の Plan mode から Crit が開くことを手動確認する。

## 非対象

- Codex への Crit 導入
- Homebrew による Crit 導入
- Claude Marketplace への登録と plugin install
- Crit plugin または skills のリポジトリ内への複製
- `mo` のアンインストール
- Crit の Share、認証、セルフホスト設定
- `agent_cmd` の設定
- Crit のグローバル設定ファイル追加
