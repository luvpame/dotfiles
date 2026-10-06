# herdr-gpui 設定調査

- [x] 1. Route through the **how** skill. For motivation questions, also route through the **why** skill.
  - skip: why は動機の調査依頼ではないため適用しない。
- [x] 2. Throughput checkpoint stays one line: `throughput checkpoint: n/a, read-only investigation`.
- [x] 3. Produce the `how`-shaped output (Overview / Key Concepts / How It Works / Where Things Live / Gotchas), or a recommendation with a tradeoffs table if the request is a decision between alternatives.
- [x] 4. Apply the **unslop** skill to the reply.

throughput checkpoint: n/a, read-only investigation

- 最新 release v20261003.1 と main の設定保存実装を照合した。
- 実機の local 設定が通常ファイルとなり、dotfiles と差分があることを確認した。
- 設定・Nix は変更していない。
- 続きの管理方式の調査では、同一不具合の公式 Issue #163 が open であることを確認した。
- 自動 Git 反映は upstream のリンク保存修正、公式アプリを維持する最小案は通常ファイルと明示取り込みとして比較した。

## GUI の無効項目の調査

- [x] 1. Route through the **how** skill. For motivation questions, also route through the **why** skill.
  - skip: why は設計の動機ではなく現在の有効化条件の調査のため適用しない。
- [x] 2. Throughput checkpoint stays one line: `throughput checkpoint: n/a, read-only investigation`.
- [x] 3. Produce the `how`-shaped output (Overview / Key Concepts / How It Works / Where Things Live / Gotchas), or a recommendation with a tradeoffs table if the request is a decision between alternatives.
- [x] 4. Apply the **unslop** skill to the reply.

throughput checkpoint: n/a, read-only investigation

- ユーザーにより Sound の Play agent sounds と特定された。
- 最新 release の共有設定読み込みは NOFOLLOW を使い、config.toml のファイルリンクを拒否する。読み込み失敗で共有設定項目が無効になる条件を確認した。
- Play agent sounds は controls_shared_ready に依存し、共有 config.toml のリンクを拒否する条件に該当することを実機のリンク状態と照合した。

## config.toml を管理対象から外す

- [x] 1. `how` over the affected subsystem.
- [x] 2. `architect` for parallel design exploration.
  - skip: 宣言削除と archive への退避はリポジトリ方針で指定済み。新しい設計や関数境界はない。
- [x] 3. Write the throughput checkpoint as four todo items.
  - **Blocking first steps.** 実機リンクの内容を保持し、通常ファイルへ置き換えてから元の repo ファイルを退避する。
  - **Independent workstreams.** repo の編集は専用 worktree、実機設定の変換は親が担当する。
  - **Shared mutable state.** worker の worktree と main checkout を分離し、完了後に限定した diff を取り込む。
  - **Smallest safe decomposition.** 1 worker。変更は配置宣言の削除と設定の退避だけ。
- [x] 4. Delegate code-writing to a subagent using your configured feature model with a specific scope.
- [x] 5. Verify on the matching surface.
- [x] 6. Rebase into small, ordered commits. Stack follow-ups.
  - skip: コミットは依頼されていない。
- [x] 7. If the design is contested, `interrogate` before shipping.
  - skip: 管理解除はユーザーが明示したため設計の争点はない。
- [x] 8. Run **Opening a PR**.
  - skip: PR は依頼されていない。

- 配置宣言を削除し、旧設定を archive/herdr/config.toml へ内容保持で退避した。
- ~/.config/herdr/config.toml を内容保持で通常ファイルへ変更し、NOFOLLOW 読み込みと親パスにリンクがないことを確認した。
- nixfmt --check、nix-instantiate --parse、TOML 解析、元内容の SHA-256 一致、git diff --check が成功した。
- nix/AGENTS.md の指示に従い、flake check はユーザー環境で行う。switch は未実行。

## GUI 設定を正として管理へ戻す

- [x] 1. `how` over the affected subsystem.
- [x] 2. `architect` for parallel design exploration.
  - Follow Herdr は共有設定へのリンクで読み込みに失敗するため、通常ファイルで配布する 2 構造を比較する。
- [x] 3. Write the throughput checkpoint as four todo items.
  - **Blocking first steps.** GUI 側の共有設定と native local 設定を取得し、取り込み前後で内容一致を確認する。
  - **Independent workstreams.** 1 worker が専用 worktree で通常ファイル配布を実装し、親が最新の GUI 設定を取り込む。
  - **Shared mutable state.** worker と main checkout を分離し、GUI 側が変更されていないことを取り込み直前・直後に確認する。
  - **Smallest safe decomposition.** 1 worker。2 TOML と配置方法のみ。設計比較は独立した読み取り専用の候補で行う。
- [x] 4. Delegate code-writing to a subagent using your configured feature model with a specific scope.
- [x] 5. Verify on the matching surface.
- [x] 6. Rebase into small, ordered commits. Stack follow-ups.
  - skip: コミットは依頼されていない。
- [x] 7. If the design is contested, `interrogate` before shipping.
  - skip: GUI 設定を正として管理へ戻す方針はユーザーが指定済み。
- [x] 8. Run **Opening a PR**.
  - skip: PR は依頼されていない。

### Architect

- [x] Ground
- [x] Sketch
- [x] Agree
- [x] Implement
- [x] Scrap
  - skip: 検証で前提の破綻がない限り不要。

### Arena

- [x] Frame
- [x] Fan out
- [x] Cross-judge
- [x] Pick
- [x] Graft
  - skip: 両候補は同じ毎 switch コピー方式を支持した。cmp と hidden staging は不要として追加しない。
- [x] Verify

採点基準は GUI の原文維持、通常ファイル、繰り返しの収束、dry-run、変更の小ささ。

設計は毎 switch の activation で GNU install を 2 回実行する方式を採用した。通常ファイルを維持し、消失やリンク化からも再実行で収束する。onChange 方式は基準が変わらない場合に修復しないため不採用。cross-judge は採用案 10 点、onChange 案 8 点。最初の候補 agent は capacity エラーとなり、新しい agent で同じ設計を検討した。

- 調査中の追加 GUI 保存も取り込み、共有 config.toml の SHA256 b6726c21ed3f808ff125984ac3e7bff2a39f3dec3b58749b7230c99de4bf8233 と native local の SHA256 695e9e64397b51ef09e578e3333ebebbf2092b2df8f38c57a4f8a3b928743525 が実機・repo 間で一致した。
- archive/herdr/config.toml は管理復帰に伴い除去した。実機は両設定とも通常ファイルを維持した。
- python3 .cache/test-herdr-copy.py が actual activation の配置・再実行・既存リンク置換・消失からの復元・bytes・600・dry-run を検証した。
- nixfmt --check、nix-instantiate --parse、git diff --check が成功。full flake check と switch は nix/AGENTS.md の指示に従いユーザー環境で行う。


## herdr-gpui の prefix-p

- [x] 1. Reproduce it yourself on the matching surface via the driver skill (Non-negotiables), even when a debug or instrumentation protocol says to ask the user to reproduce.
  - skip: GPUI は現在未起動。System Events の読み取りがアクセス権違反で拒否され、GUI 操作による再現はできない。別の操作経路で回避しない。
- [x] 2. Binary-search the cause.
  - 設定・配置・依存コマンドは正常。リリース v20261005.1 の DaemonKeys が previous_tab 省略時に prefix+p を追加し、runs_custom が既存 chord と重なる popup を除外する。ソースで確認した原因。GUI 実測は未確認。
- [x] 3. Plan the fix.
  - previous_tab の標準割り当てを空にする。1 worker は共有設定の1行だけ所有し、親は実機への反映を担当。
- [ ] 4. Verify on the same surface.
  - GUI 実測はユーザーの Ctrl+j、p で確認する。TOML と反映先は親が検証する。
- [x] 5. Stage the commits so the failing repro lands before the fix in git history.
  - skip: コミットは依頼されていない。設定のみの変更で、新規テストは不要。
- [x] 6. Run **Opening a PR**.
  - skip: PR は依頼されていない。

- repo と実機 ~/.config/herdr/config.toml に previous_tab = "" を追加。両ファイルの byte 一致、TOML 解析、prefix+p popup 保持、git diff --check が成功。
- GUI 上での動作確認は未完了。System Events アクセス権違反のため、ユーザーに Ctrl+j → p の確認を引き継ぐ。
- 指定された w2G:t8 は tab_not_found のため rename は実行しない。他のタブへ変更対象を広げない。

## Tinycast 設定ファイルの dotfiles 管理

- [x] 1. `how` over the affected subsystem.
- [x] 2. `architect` for parallel design exploration.
  - skip: 既存の Home Manager 配置方式を利用する設定追加。保存実装の確認でリンク方式を決め、新しいアーキテクチャは導入しない。
- [x] 3. Write the throughput checkpoint as four todo items.
  - **Blocking first steps.** 現行設定の秘密情報と Tinycast の保存方式を確認する。
  - **Independent workstreams.** upstream 調査と独立 worktree の設定追加を分離する。
  - **Shared mutable state.** worker は .cache/tinycast-worktree を所有し、親は完了後に変更を取り込む。
  - **Smallest safe decomposition.** 設定 JSON と配置宣言を1 workerが担当する。
- [x] 4. Delegate code-writing to a subagent using your configured feature model with a specific scope.
- [x] 5. Verify on the matching surface.
  - Nix flake と switch は nix/AGENTS.md に従ってユーザー環境で実行。親は JSON と Nix 構文、実機のリンクと内容を確認する。
- [x] 6. Rebase into small, ordered commits. Stack follow-ups.
  - skip: コミットは依頼されていない。
- [x] 7. If the design is contested, `interrogate` before shipping.
  - skip: 設計の争点はない。
- [x] 8. Run **Opening a PR**.
  - skip: PR は依頼されていない。

- 指定された w2G:t8 は tab_not_found。別のタブへ変更対象を広げない。

- 設定 JSON とファイル単位の配置宣言を追加。実機はバックアップを残して ~/.dotfiles/config/tinycast/settings.json へのリンクに切り替えた。
- JSON とバックアップの内容一致、nixfmt --check、nix-instantiate --parse、git diff --check が成功。lsof で稼働中 Tinycast が repo の settings.json を開いていることを確認した。
- UI 保存は upstream v0.11.12 の resolvingSymlinksInPath と testSymlink を確認。実機 GUI 操作は未実施。just check と just switch は nix/AGENTS.md に従いユーザー環境で実行する。
