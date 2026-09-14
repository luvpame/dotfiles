# 単独で導入したスキルを Nix で管理する

Date: 2026-09-14

## Status

Accepted

## Decision

プラグイン経由で導入したスキルは、そのプラグインで管理を続ける。
Codex の組み込みスキルである `.system` と、Codex の画面記録機能に依存する `chronicle` は Codex に管理を委ねる。
これらを除く外部スキルは agent-skills-nix の管理対象とする。
ローカルスキルは dotfiles の作業ツリーからスキル単位で直接リンクし、既存ファイルの編集を即時反映する。
スキルの追加と削除は `just switch` で反映する。
Cursor への配布と、このリポジトリで管理する Cursor 連携設定は廃止する。

## Reasons

agent-skills-nix はソースを Nix store に取り込むため、ローカルスキルも任せると編集のたびに再ビルドと適用が必要になる。
編集の即時反映を維持するため、外部スキルの管理とローカルスキルの配置を分ける。
プラグインには hooks などの機能も含まれ得るため、スキルだけを重ねて配布せず、既存の管理を続ける。

## Implementation

ローカルスキルは `config/agents/skills/` に維持する。
Home Manager がスキルごとに作業ツリーへの直接リンクを配置する。
外部スキルは agent-skills-nix の Home Manager モジュールから配布する。
初回に移行した `cloudflare-deploy` と `web-perf` は利用しなくなったため、配布宣言と取得元の入力を削除した。
その後、コピーしていた show-me、japanese-tech-writing、cognitive-rhythm-writing、code-simplifier、empirical-prompt-tuning、herdr を外部取得に変更した。
配布する構成はローカル7件と外部6件とする。
ローカルと外部の両方を `.agents/skills` と `.claude/skills` に配置する。
親ディレクトリ全体への既存リンクは個別配置へ変更し、リポジトリ内のスキル実体は維持する。
外部スキルには `structure = "link"` を使い、同じ配置先で名前が重複した場合は上書きせず停止する。
上流モジュールの `force = true` は無効化する。
配置前に親リンク、ローカルスキルの欠落、Home Manager が管理していない同名項目を検査する。

外部ソースは flake input として宣言し、`nix/flake.lock` で固定する。
初回移行時は、その時点の内容と一致する次のリビジョンを使用した（現在は両入力とも削除済み）。

| スキル | 取得元 | リビジョン | 一致確認 |
| --- | --- | --- | --- |
| cloudflare-deploy | openai/skills の skills/.curated/cloudflare-deploy | `49f948faa9258a0c61caceaf225e179651397431` | サポートを含む312ファイルの Git blob ハッシュが一致 |
| web-perf | cloudflare/skills の skills/web-perf | `22a32f5f10eedd4428b26597406804ddf43b747d` | SKILL.md がバイト単位で一致 |

初回の切り替えでは `.codex/skills` にある外部2スキルを検出対象外の場所へ退避し、配布後の二重登録を防ぐ。
`.system`、`chronicle`、プラグインのファイルはそのまま維持する。
設定の評価とビルドを確認した後に `just switch` を実行し、配布先、旧リンクの解消、既存ファイルの編集の即時反映を確認する。

## Operations

コピー済み6件を外部取得へ切り替えるときは、リポジトリのルートで次を実行する。

```sh
bash script/migrate-external-skills.sh
```

スクリプトは `just switch` の成功と両配布先のリンクを確認してから、旧原本を `archive/agents/skills/` へ移動する。
反映前に旧原本を移動すると、使用中のリンクが切れるため、この順序を守る。
内容は `external-skills.nix` で取得と整形を行い、`skill-patches/` のパッチで従来の変更を維持する。
相対参照を配布先へ書き換える前に、6原本の SHA-256 と一致することをビルド中に検証する。

旧来の親ディレクトリ全体へのリンクから初めて移行する環境では、先に次を実行する（この環境では完了済み）。

```sh
bash script/migrate-agent-skills.sh --dry-run
bash script/migrate-agent-skills.sh
```

移行スクリプトはビルドと `sudo` 認証を済ませてから、旧親リンクと外部2スキルを `~/.local/state/dotfiles/agent-skills.*` に退避し、`just switch` を実行する。
反映に失敗したら元の配置への復元を試み、復元できないパスとバックアップの位置を報告する。
バックアップ内の `paths.tsv` に、退避ファイルと元の配置先の対応を記録する。

ローカルスキルを追加または削除するときは、ディレクトリと `nix/nix-darwin/home-manager/skills.nix` の `localSkills` を変更し、`just switch` で反映する。
外部スキルのバージョンは `nix/flake.nix` の入力URLで指定する。
更新時はリビジョンを変更し、`nix/` で `nix flake lock path:.` と `nix flake check path:.` を実行してから `just switch` で反映する。
コピー済み6件の内容を意図的に更新する場合は、パッチと `skill-patches/original-skills.sha256` も更新する。

## References

- [編集の即時反映を維持する既存の決定](unify-dotfiles-configuration_2026-08-24.md)
- [agent-skills-nix の bundle 実装](https://github.com/Kyure-A/agent-skills-nix/blob/master/lib/bundle.nix)
- [agent-skills-nix の Home Manager モジュール](https://github.com/Kyure-A/agent-skills-nix/blob/master/modules/home-manager/agent-skills.nix)
- [現在の cloudflare-deploy を再現するソース](https://github.com/openai/skills/tree/49f948faa9258a0c61caceaf225e179651397431/skills/.curated/cloudflare-deploy)
- [現在の web-perf を再現するソース](https://github.com/cloudflare/skills/tree/22a32f5f10eedd4428b26597406804ddf43b747d/skills/web-perf)
