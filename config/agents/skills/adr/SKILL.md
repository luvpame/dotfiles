---
name: adr
description: Architecture Decision Records を Markdown で作成し、決定の背景、選択肢、結果を後から追える形で残す。Use when ユーザーが ADR、Architecture Decision Record、設計判断、技術選定、意思決定ログ、決定記録を残したいと言ったとき。
---

# ADR

設計判断が後から読めるように、ADR を `docs/adr/{summary}_{yyyy-mm-dd}.md` に残す。
`summary` は短い kebab-case にする。
日付は ADR を作成する時点のローカル日付を使う。

## 作成する条件

次の三つがそろうときに ADR を作る。

- 後から変えるコストが意味を持つ
- 未来の読者が理由を知りたくなる
- 複数の選択肢の間で実際にトレードオフがあった

どれかが欠ける場合は、ADR ではなく作業ログやコメントで済ませる。

## ワークフロー

1. `docs/adr/` と、決定に関係するコードや設定を確認する。
2. 決定、候補、制約、根拠、結果を短く整理する。
3. `docs/adr/` がなければ作る。
4. ファイル名を `docs/adr/{summary}_{yyyy-mm-dd}.md` にする。
5. 同名ファイルがあれば上書きせず、summary を変えるかユーザーに確認する。
6. ADR を書いた後、矛盾する古い ADR があれば新 ADR の `References` から参照する。
7. 確認したファイル、同名衝突の有無、更新した古い ADR は作業報告で伝える。

## ファイル名

`summary` は内容を表す英語の短い kebab-case にする。
日本語タイトルを使う場合でも、ファイル名は検索しやすい ASCII を優先する。

例:

```text
docs/adr/use-nix-darwin-for-macos_2026-07-09.md
docs/adr/store-agent-skills-in-dotfiles_2026-07-09.md
```

## 本文テンプレート

```md
# {title}

Date: {yyyy-mm-dd}

## Status

Accepted

## Context

この決定が必要になった背景を書く。
制約、困っていたこと、未来の読者が知らない前提を含める。

## Decision

採用した方針を書く。
何をするか、何をしないかを分けて書く。

## Options Considered

- **{option}**: 選ばなかった理由、または選んだ理由を書く。
- **{option}**: 選ばなかった理由、または選んだ理由を書く。

## Consequences

この決定で良くなること、受け入れる制約、あとで見直す条件を書く。

## References

- 関連する issue、PR、仕様、コード、既存 ADR があれば書く。
```

## 書き方

- 一つの ADR には一つの決定だけを書く。
- 「何を選んだか」より「なぜ他を選ばなかったか」を具体的に書く。
- 自明な実装手順は書かず、判断の再現に必要な背景を書く。
- ADR 本文には決定の根拠になる情報だけを書く。確認作業のログは本文ではなく作業報告に書く。
- 未確定の案は `Status: Proposed` にする。
- 置き換えられた ADR は古い ADR を編集して `Status: Superseded by {new adr path}` にする。
- 古い ADR を読めない場合は、矛盾を断定せず、提供された情報に基づく前提として書く。
