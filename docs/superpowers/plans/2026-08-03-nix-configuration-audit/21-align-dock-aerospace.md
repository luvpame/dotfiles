# T21 DockとAeroSpaceのdisplay設定を整合させる

- **Status**: 未着手
- **Audit IDs**: `SYS-01`, `SYS-15`
- **原典**: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- **依存先**: なし

## Goal

Dockを右側に置く現在の選択を維持し、設定値と食い違うコメントだけを直す。
AeroSpaceのwindow spanningと安定性を優先し、macOSの「ディスプレイごとに個別の操作スペース」を無効にする。

## Architecture

変更は`nix/nix-darwin/system.nix`の二点に限定する。
`system.defaults.dock.orientation = "right"`は値を変えず、コメントを右側に合わせる。
`system.defaults.spaces.spans-displays`は`false`から`true`へ変える。

`spans-displays`の反映にはlogoutが必要である。
buildとswitchを分け、Nix評価を確認してから明示的な適用段階へ進む。

同じファイルには、左上のHot Cornerを画面ロックへ変える未コミット差分がすでにある。
その差分はこのタスクへ取り込まず、変更も復元もしない。

## 対象ファイル

- Modify: `nix/nix-darwin/system.nix`

## 実施手順

- [ ] `git status --short`と`git diff -- nix/nix-darwin/system.nix`を保存し、既存のHot Corner差分を特定する。
- [ ] `defaults read com.apple.dock orientation`と`defaults read com.apple.spaces spans-displays`を実行し、適用前の実効値を記録する。
- [ ] `orientation = "right"`は維持したまま、コメントを「Dockの位置を右側に設定する」へ直す。
- [ ] `spans-displays = true`へ変更し、コメントを「ディスプレイ間で同じ操作スペースを使用する」という意味に合わせる。
- [ ] 差分を確認し、Hot Cornerの行が作業開始時の差分から変わっていないことを照合する。
- [ ] コード変更に`code-simplifier`を適用し、意図した二点以外を変えていないことを再確認する。
- [ ] Nixの静的検証とbuildを完了する。
- [ ] ユーザーが適用を明示した場合だけ`just switch`を実行する。
- [ ] 作業中のアプリを保存してlogoutし、再login後にAeroSpaceと複数displayの挙動を確認する。

## 検証コマンドと期待結果

```bash
nixfmt --check nix/nix-darwin/system.nix
```

期待結果は、出力なしで終了コードが0になることである。

```bash
just check
just build
```

期待結果は、両方が終了コード0で完了することである。

```bash
config_name="$(nix eval --file nix/local.nix darwinConfigName --raw)"
nix eval --raw "path:./nix#darwinConfigurations.${config_name}.config.system.defaults.dock.orientation"
nix eval --json "path:./nix#darwinConfigurations.${config_name}.config.system.defaults.spaces.spans-displays"
```

期待結果は、一つ目が`right`、二つ目が`true`を返すことである。
`nix/local.nix`の値そのものはログや文書へ転記しない。

適用を明示された後だけ、次を実行する。

```bash
just switch
defaults read com.apple.dock orientation
defaults read com.apple.spaces spans-displays
```

期待結果は、switchが成功し、実効値がそれぞれ`right`と`1`になることである。
logout後は、AeroSpaceでdisplayをまたぐ移動、workspace切替、native fullscreenを手動確認する。

```bash
git diff --check
git diff -- nix/nix-darwin/system.nix
```

期待結果は、空白エラーがなく、Hot Cornerの既存差分が作業開始時の記録と一致することである。

## 完了条件

- Dockの値は`right`のままで、コメントも右側を示している。
- `spans-displays`が`true`として評価される。
- Hot Cornerの既存未コミット差分を保全している。
- logout後もAeroSpaceのworkspace移動と複数display操作が成立する。
- `nixfmt`、`just check`、`just build`が成功している。

## ロールバック

`spans-displays`だけを`false`へ戻し、Dockの値とHot Cornerの既存差分には触れない。
`nixfmt`、`just check`、`just build`を再実行し、ユーザーの明示後に`just switch`とlogoutを行う。
設定変更前に記録した実効値へ戻ったことと、AeroSpaceの従来動作を確認する。

## 実装時の制約

- Nixファイルを変更したら`nixfmt`、`just check`、`just build`で検証する。
- コードを変更したら`code-simplifier`を適用し、検証をもう一度実行する。
- Gitコミットは、ユーザーが明示的に依頼した場合だけ作成する。
