---
name: implement-from-spec
description: SPEC（仕様書）を実装しながら、SPEC からの逸脱・解釈・トレードオフ・残課題を `implementation-notes.html` に発生直後に追記し続けるスキル。Design decisions / Deviations / Tradeoffs / Open questions の 4 カテゴリで、判断が起きた瞬間に逐次記録するためバッチ更新はしない。ユーザーが SPEC ファイルや要件記述を渡して「実装して」「仕様書のとおり作って」と頼んだとき、特に後で第三者がレビューしたり未来の自分が再現できるよう実装側の判断を残したいときに使う。
---

# Implement From Spec

SPEC を実装しつつ、SPEC を読んだだけでは分からない「実装側で発生した判断」を `implementation-notes.html` に **発生した直後** に書き続ける。後でまとめて書くと判断根拠が再構成不能になるので必ず逐次。

## 引数

`/implement-from-spec <SPEC のパス or インライン記述>`

- ファイルパスが渡されたら Read で読み込む
- インラインテキストならそのまま要件として扱う
- 何も渡されなかったらユーザーに「SPEC のパス or 要件を渡して」と聞き返す

## ワークフロー

1. **SPEC を理解する**
   SPEC 内容を把握。曖昧な点はメモするだけで即座にユーザーに聞き返さない（実装中の判断として記録対象になる）。

2. **`implementation-notes.html` を初期化**
   - cwd に作る。**初期化前に必ず存在確認**する（Bash で `test -f ./implementation-notes.html` 等）。
   - **新規作成時**: `/Users/nasuno.ayumu/.claude/skills/implement-from-spec/template.html` を Read し、その内容を Write で `./implementation-notes.html` に複製してから、次を置換:
     - `{{SPEC_REF}}`: SPEC ファイルパス（ファイル渡し時）または `inline: <SPEC の一行サマリ>`（インライン渡し時、80 文字以内、SPEC 原文の冒頭を切り出して可）
     - `{{ISO_TIMESTAMP}}`: 現在時刻を **ローカル TZ オフセット付き ISO 8601 拡張形式**（`±HH:MM` のコロン区切り）で（例: `2026-05-19T14:32:00+09:00`。`Z`/UTC や `+0900` のコロン無しは使わない）
   - **既存ファイルあり**: 上書きせず **必ずユーザーに確認**。続きの作業なら「追記モード」を提案。追記モードは Edit で該当 `<section>` の `<ul></ul>` の中に `<li>` を追加する（HTML 構造は触らない、header の `{{...}}` 置換やり直しもしない）

3. **実装を進めながら 4 カテゴリ発生時に逐次追記**
   次のどれかが起きた **直後** に、Edit で該当 `<section>` の `<ul></ul>` の中に `<li>` を 1 件追加する。複数まとめて書かない。`<time datetime>` は **追記する時点で取り直した現在時刻** を入れる（初期化時刻からの推定は使わない）。

   - **Design decisions**: SPEC が曖昧で自分が選んだ選択
   - **Deviations**: 意図的に SPEC から離れた箇所と理由
   - **Tradeoffs**: 検討した代替案と選んだ理由
   - **Open questions**: ユーザーに確認・修正してもらいたい点

4. **完了時にサマリ**
   実装が一段落したら次の 2 つを必ず出す:
   - **集計行**: `` `implementation-notes.html` に合計 N 件記録（DD: a, Dev: b, TO: c, OQ: d） `` の形で 1 行。略号は **DD** = Design decisions, **Dev** = Deviations, **TO** = Tradeoffs, **OQ** = Open questions
   - **Open questions 再掲**: Open questions に記録した各 `<li>` の **本文を要約せず原文のまま** 1 件 1 行で列挙。`<time>` と `<span class="why">` は省き、`<code>file:line</code>` は元の位置のまま残す（移動も別形式への変換もしない）。最後に「確認をお願いします」と添える

## エントリ記載フォーマット

各 `<li>` は次の形:

```html
<li>
  <time datetime="2026-05-19T14:32:00+09:00">2026-05-19 14:32</time>
  本文 1〜2 文。<code>path/to/file.ts:42</code> のように関連箇所を併記。
  <span class="why">理由 / 代替案: ...（Tradeoffs と Open questions では必須、他は任意）</span>
</li>
```

最小例:

```html
<li>
  <time datetime="2026-05-19T14:32:00+09:00">2026-05-19 14:32</time>
  SPEC に「ファイル数を数える」とあるが、ドットファイルを含めるか不明だったため除外する選択にした。<code>scripts/count.sh:3</code>
  <span class="why">理由: 一般的な "ファイル一覧" の感覚に揃えた。Open questions にも転記済み。</span>
</li>
```

冗長にしない。後から読んで判断を再現できる粒度に留める。

## ルール

- **バッチ更新禁止**: 判断が起きた直後に書く。「キリのいいところまで実装してから」は禁止
- **HTML 以外の形式を使わない**: md などへの変換も行わない
- **自明だと思っても迷ったら書く**: 「自明」だと感じた判断ほど後で「なぜ？」になりがち
- **Open questions に書いたものは完了時報告で必ず再掲**: 埋もれさせない

## Red flags

| 出てくる合理化 | 実態 |
|---|---|
| 「いったん全部実装してから記録しよう」 | 判断根拠が再構成不能になる。逐次が原則 |
| 「自明な判断は省こう」 | 自明性は時間経過で失われる。迷ったら書く |
| 「Tradeoffs は些細だから書かない」 | 一度でも代替案が頭をよぎったら書く対象 |
| 「Open questions は最後にまとめて確認しよう」 | 完了時にユーザーに渡すのは良いが、記録は発生時に書く |
