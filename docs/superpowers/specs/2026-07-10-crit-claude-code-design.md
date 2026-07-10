# Crit の Claude Code 導入設計

## 目的

Claude Code の計画とコード変更を Crit のブラウザ画面でレビューできるようにする。

Plan mode の終了時に Crit を開き、利用者が計画を承認するまで実装へ進まないレビュー経路を設ける。

Crit CLI は Nix と Home Manager で配布し、Claude Code は既存どおり通常の package と plugin 導入フローを使う。

## 背景

従来は `PreToolUse` の `ExitPlanMode` hook が最新の計画ファイルを `mo` で開いていた。

この hook は計画を表示するだけであり、行単位のコメント、修正ラウンド、承認状態を Claude Code へ返さない。

Crit の公式 Claude Code plugin は `/crit` skill、`crit-cli` skill、`ExitPlanMode` の review hook をまとめて提供する。

Claude Code の外部 plugin は、Marketplace の信頼確認と plugin のインストール確認を利用者ごとに通す必要がある。

## 方針

Crit の公式 flake を input に追加し、Crit CLI を仕事用 Home Manager package として導入する。

Claude Code は `pkgs.claude-code` をそのまま Home Manager package に含め、wrapper を作らない。

`settings.json` の `extraKnownMarketplaces` に Crit の公式 repository を追加し、`enabledPlugins` で `crit@crit` を有効にする。

Home Manager の反映後、Claude Code の標準フローが Marketplace と plugin の信頼確認を表示する。

`brew install`、`claude plugin marketplace add`、`claude plugin install` はこちらから実行しない。

## 変更範囲

### `nix/flake.nix`

`git+https://github.com/tomasz-tomczyk/crit.git` を input に追加し、`nixpkgs` はルート input に追従させる。

`git+https` fetcher を使い、GitHub REST API の未認証 rate limit に依存しない。

### `nix/flake.lock`

Crit の revision と依存関係を固定する。

### `nix/nix-darwin/home-manager/packages/work.nix`

Crit CLI を `inputs.crit.packages.${system}.default` から仕事用 package に追加する。

Claude Code は既存どおり `pkgs.claude-code` を追加する。

### `config/claude/settings.json`

`mo` の `ExitPlanMode` 表示 hook と `SessionEnd` cleanup hook は削除した状態を維持する。

Crit の公式 Marketplace source と `crit@crit` の有効状態を宣言する。

## 動作

Home Manager の反映後、PATH 上で Crit CLI と通常の Claude Code を利用できる。

Claude Code は Crit Marketplace を検出し、未導入なら利用者へ信頼とインストールの確認を求める。

承認後、Plan mode で Claude Code が `ExitPlanMode` の許可を求めると、plugin の `PermissionRequest` hook が PATH 上の `crit plan-hook` を実行する。

Crit は計画をブラウザで開き、未解決のコメントがあれば Claude Code は Plan mode を続け、コメントなしで承認されると Plan mode を終了する。

計画以外のファイル、コード差分、PR、実行中の画面は `/crit` から任意にレビューする。

## エラー処理

外部 plugin の信頼確認は迂回しないため、利用者が承認するまでは Crit plugin を利用できない。

Crit CLI は先に Home Manager で利用可能になるため、plugin 承認後に hook の command が見つからない状態を避けられる。

一時的に Plan mode のレビューを止める場合は、Claude Code の起動環境で `CRIT_PLAN_REVIEW=off` を設定する。

初期導入では `~/.crit.config.json` を作らず、bind 先や共有設定を含む既定値を変更しない。

## 検証

- `nixfmt` で変更した Nix ファイルを整形する。
- `jq empty config/claude/settings.json` で JSON の構文を確認する。
- `nix flake check` で flake と darwin 構成を評価する。
- Home Manager package list に Crit CLI と通常の Claude Code が含まれることを評価する。
- Crit Marketplace source と `crit@crit` の有効状態を検査する。
- Crit plugin の manifest と `PermissionRequest: ExitPlanMode` hook を確認する。
- Home Manager 反映後に標準の信頼確認を通し、Claude Code の Plan mode から Crit が開くことを手動確認する。

## 非対象

- Codex への Crit 導入
- Homebrew による Crit 導入
- Claude Code wrapper の作成
- Claude Marketplace と plugin の信頼確認の迂回
- Crit plugin または skills のリポジトリ内への複製
- `mo` のアンインストール
- Crit の Share、認証、セルフホスト設定
- `agent_cmd` の設定
- Crit のグローバル設定ファイル追加
