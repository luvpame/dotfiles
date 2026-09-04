---
name: conventional-commit
description: Use this skill when creating git commits, writing commit messages, or when the user asks to commit changes. Generates Conventional Commits messages with automatic type/scope inference, optional commit splitting, and asks the user only when split decisions are ambiguous.
argument-hint: "message/type hint"
---

# Conventional Commit Message and Commit Execution

## Overview

このスキルは Conventional Commits 形式のコミットメッセージを自動生成し、通常はユーザー承認なしで `git commit` まで実行します。

- 変更内容を分析して `type` / `scope` / `subject` / `body` を推定する
- 複数の論理単位が混在する場合はコミット分割を検討する
- 分割方針が曖昧な場合のみユーザーに確認する
- 既定言語は日本語（ユーザーまたはプロジェクト規約の指定があれば従う）

最初に次の原則で迷いを減らす。

- 変更が 1 つの論理単位なら、確認せず 1 コミットで完了させる
- `scope` は「共通モジュール名が自然に 1 語で言えるときだけ」付ける
- 振る舞いが変わる設定変更は `fix` または `feat` を優先し、単なる整理なら `refactor` / `chore` を使う
- 分割コミットでは、毎回 `git add <対象>` -> `git commit` の順で 1 コミットずつ閉じる

## Arguments

`$ARGUMENTS` は次のヒントとして解釈します。

- type ヒント（例: `/conventional-commit feat`）
- subject ヒント（例: `/conventional-commit "認証エラーを修正"`）

## Commit Message Rules

### Format

- 基本: `{type}(scope): {subject}`
- scope 不要時: `{type}: {subject}`
- 絵文字は使わない

### Allowed types

`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

### Subject

- 必須
- 簡潔で具体的に「何をどうしたか」を書く
- 動詞から書き始める
- 文末に句読点を付けない
- 長すぎない（目安: 64 文字以内）

### Body (optional)

- 必要な場合のみ付ける
- 1 行目に背景・理由
- 2 行目以降に主な変更点を箇条書きで記述
- 1 行 72 文字以内を目安にする

## Inference Rules

### type inference

差分とファイル種別から推定する。

- 機能追加・新規公開 API 追加: `feat`
- 不具合修正: `fix`
- ドキュメントのみ変更: `docs`
- テスト追加・更新: `test`
- CI/CD、ビルド設定: `ci` / `build`
- パフォーマンス改善: `perf`
- 振る舞いを変えない構造改善: `refactor`
- その他の雑多な調整: `chore`

迷いやすい境界は次で固定する。

- 設定・スクリプト変更で実行時の挙動や失敗条件が改善される: `fix`
- 設定整理、命名整理、コメント整理のみで挙動不変: `refactor` または `chore`
- README やガイド、コメント文面だけの更新: `docs`
- 新しい設定スイッチや新規の利用者向け導線を追加する: `feat`

### scope inference

変更ファイルの共通ディレクトリやモジュール名から推定する。

- 例: `frontend`, `backend`, `api`, `auth`, `docs`, `config`
- 明確に推定できない場合は scope を省略する
- プロジェクト固有の scope 規約がある場合はそれを優先する

次のときは scope を省略してよい。

- 単一ファイル変更でも、そのファイル名を scope にすると不自然
- 複数ファイル変更だが、共通モジュール名より上位ディレクトリしか共有していない
- README や雑多なトップレベルファイル変更で、scope を足すとかえって冗長になる

次のときは scope を付ける。

- 変更が特定サブディレクトリやモジュールに閉じている
- その scope を付けることで履歴検索がしやすくなる

## Split Decision Rules

次の条件に当てはまる場合、分割を検討する。

1. 変更が明確に複数責務へ分かれる
2. 異なる type が強く混在する
3. 変更対象の領域が独立している

分割が明確な場合は、コミット案ごとに対象ファイル一覧を整理したうえで、そのまま自動で分割コミットしてよい。

次のような場合だけユーザーに確認する。

- どのファイルをどのコミットに含めるべきか複数案が成立する
- 単一コミットでも妥当だが分割コミットも妥当で、履歴上の意図が読み切れない
- 変更の依存関係が曖昧で、分割すると壊れる可能性がある

## Question Policy

### When an interactive question tool is available

`AskUserQuestion` や `request_user_input` のような選択式ツールが使えるなら、それを優先して使う。

- 確認が必要なのは、分割判断が曖昧なときだけ
- 単一コミットで問題ない場合や、分割方針が明確な場合は質問しない

### Fallback

選択式ツールがない場合は、通常のテキスト質問で必要最小限の確認を行う。

- 単一コミットで問題ない場合は確認せずそのまま実行する
- 分割が明確な場合は確認せずそのまま実行する
- 質問するときは、判断に必要な選択肢と推奨案を短く示す

## Workflow

1. 変更内容を確認する
2. `type` / `scope` / `subject` / `body` を自動生成する
3. 分割可能性を判定する
4. 単一コミットで十分なら、必要なファイルを stage してそのままコミットを実行する
5. 分割が明確なら、コミットごとに対象ファイルを stage して複数コミットを実行する
6. 分割判断が曖昧な場合のみ、推奨案つきでユーザーに質問する
7. 実行後に結果を確認する

## Commands

```bash
# 変更確認
git status --short
git diff --staged
git diff

# 単一コミット前の stage
git add <対象ファイル>

# 単一コミット（body なし）
git commit -m "type(scope): subject"

# 単一コミット（body あり）
git commit -m "$(cat <<'EOF'
type(scope): subject

背景や理由
- 変更点1
- 変更点2
EOF
)"

# 実行結果の確認
git log -1 --oneline
git status
```

分割コミットの場合は、各コミットで次の順序を守る。

1. そのコミットに含めるファイルだけ `git add <対象ファイル...>` する
2. 対応するメッセージで `git commit` する
3. 残りの変更に対して 1, 2 を繰り返す

## Safety Requirements

1. 分割判断が曖昧な場合を除き、不要な確認を挟まない
2. 実行前にコミットメッセージ案を必ず確定させる
3. 分割コミット時は各コミットの対象ファイルを明示する
4. 失敗時はエラー内容を示し、再実行可能な形で案内する
