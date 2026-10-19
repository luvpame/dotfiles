# Claude Code on the web 用スキル（試験導入）

dotfiles 管理の20件から、専用CLIの導入が不要な12件を `dotfiles` プラグインとして配布する。
Git・シェル・標準Python・同梱スクリプトと、同梱する別スキルへの依存は許容する。
ローカル用のスキル配置や Nix の設定とは独立している。

## 生成・検証

リポジトリ直下で実行する。Python 3、Git、patch と、GitHub への接続が必要。

```sh
python3 config/claude/cloud-skills/generate.py
python3 config/claude/cloud-skills/generate.py --check
python3 config/claude/cloud-skills/test-generate.py
claude plugin validate config/claude/cloud-skills/plugin
claude plugin validate .
```

`--dry-run` は再生成した差分のファイル名だけを表示し、配布物を変更しない。
`--check` は同じ比較を行い、差分があれば終了コード1を返す。

取得元と版は `nix/flake.lock`、ローカルの原本は `config/agents/skills/` を使う。
既存の `skill-patches/` と原本ハッシュも再利用し、上流更新で適用できなくなったら停止する。
外部スキルの同梱資料・ライセンス表記を保持し、取得元を `plugin/SOURCES.json` に記録する。
日本語規範2件の上流gistにはライセンス表記がない。

生成時には日本語スキル間の参照と yomiyasu のスクリプトパスを
`${CLAUDE_PLUGIN_ROOT}` 配下に向け、show-me の macOS 専用 `open` を成果物の案内に置き換える。
eli33 の説明欄の `<topic>` は、同期時の警告を避けるため `{topic}` に変換する。
内容からプラグインのバージョンを生成するため、更新時に手動で版番号を付ける必要はない。
原本や `flake.lock` を更新したら再生成し、`plugin/` の差分も一緒にコミットする。

## クラウドで使う

1. この変更を GitHub に反映する。
2. [Claude のプラグイン設定](https://claude.ai/customize/plugins)でマーケットプレイスを追加し、
   `luvpame/dotfiles` を接続して `dotfiles` を有効にする。
3. Claude Code on the web の新しいセッションで `/dotfiles:eli33` などを呼び出す。
   セッション開始前の最初の入力では一覧に出ない場合があるため、開始後に確認する。
4. 更新が取り込まれない場合は、マーケットプレイスの「アップデートを確認」を実行する。

ローカルでの二重読み込みは `config/claude/settings.json` の
`"dotfiles@synced": false` で防ぐ。
既存の pstack・mattpocock などは今回のプラグインには含めない。

## 対象

- agent-memory-repo
- code-simplifier
- cognitive-rhythm-writing
- eli33
- empirical-prompt-tuning
- evidence-code-review
- japanese
- japanese-end-focus
- japanese-tech-writing
- no-ai-slop
- show-me
- yomiyasu

agent-memory-repo のメモはセッションのファイルシステムに依存する。
継続利用のための private remote は、この試験では設定しない。
empirical-prompt-tuning は Claude Code の subagent 機能を使う。

除外する8件は agent-browser、conventional-commit、explainer、git-surgeon、
herdr、mo、obsidian、pr-review-assist。
conventional-commit も部分ステージ時に専用の git-surgeon CLI を要求するため除外する。

## 撤去

1. Claude 側で `dotfiles` をアンインストールし、`luvpame-dotfiles` マーケットプレイスを削除する。
2. この `config/claude/cloud-skills/` ディレクトリと、ルートの `.claude-plugin/marketplace.json` を削除する。
3. `config/claude/settings.json` から `"dotfiles@synced": false` を削除する。

Nix の設定変更や `just switch` は不要。

参考：[マーケットプレイス作成](https://code.claude.com/docs/en/plugin-marketplaces)、
[スキルのパス変数](https://code.claude.com/docs/en/skills#available-string-substitutions)、
[元記事](https://zenn.dev/yasu888/articles/976b6d16ee68d7)。
