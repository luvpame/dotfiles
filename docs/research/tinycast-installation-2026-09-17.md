# Tinycastの導入方法

調査日: 2026-09-17。対象: [abue-ammar/tinycast](https://github.com/abue-ammar/tinycast)。インストール・Nix設定変更は未実施。

## このMacでの推奨方法

実機は `sw_vers -productVersion` が `26.6.2`、`uname -m` が `arm64`。Apple Silicon向け安定版の要件（macOS 26以降）を満たす。[公式導入手順](https://abue-ammar.github.io/tinycast/docs/install/)

このリポジトリでは `nix/nix-darwin/homebrew.nix` に登録する。

1. `tapNames` に `"abue-ammar/tinycast"` を追加する。
2. `caskNames` に `"tinycast"` を追加する。試用中は既存の `"raycast"` を残す。
3. `nixfmt nix/nix-darwin/homebrew.nix` と `just check` を実行する。
4. `just switch` で反映し、`open -a Tinycast` で起動する。

既存の `trustedTaps` が各tapに `trusted = true` を設定するため、その仕組みを利用できる。`just switch` はTinycastだけでなく宣言全体を適用する。

## 手動で試す場合

公式コマンドは以下。

```sh
brew trust --tap abue-ammar/tinycast
brew install --cask abue-ammar/tinycast/tinycast
open -a Tinycast
```

ただし、このリポジトリは `homebrew.onActivation.cleanup = "zap"` を設定している。未登録のまま次回 `just switch` を実行すると、アプリと関連データが削除対象になる。継続利用には上記の宣言登録が必要。

Tinycastは自己署名で、Appleの公証を受けていない。公式caskはインストール時にアプリのquarantine属性を解除する。調査時のcaskバージョンは `0.10.23`。[cask定義](https://github.com/abue-ammar/homebrew-tinycast/blob/main/Casks/tinycast.rb)

## 初回設定とRaycastとの併用

1. 起動ショートカットを設定する。初期状態では未割り当て。Raycastと重ならないキーを選ぶ。
2. 貼り付け・ウィンドウ操作などを使う場合にアクセシビリティを許可する。ランチャーだけなら不要。
3. 必要なら `Settings → Extensions → Install → Import from Raycast` で既存拡張を取り込む。ビルド済み拡張の取り込みにNodeは不要。

クリップボード履歴は初期状態で有効。不要なら `Settings → Clipboard` で無効にする。[初期設定](https://abue-ammar.github.io/tinycast/docs/)・[権限](https://abue-ammar.github.io/tinycast/docs/permissions/)・[拡張導入](https://abue-ammar.github.io/tinycast/docs/extensions/installing/)

Raycast拡張は完全互換ではない。メニューバーコマンド、Raycast側のAI API、一部OAuthなどは未対応。両アプリが `raycast://` を扱うため、併用時はリンクや認証の戻り先が競合しうる。[互換性と制限](https://abue-ammar.github.io/tinycast/docs/extensions/compatibility/)

GitHubのソースから拡張を導入する場合はNodeとパッケージマネージャーが必要。Nix経由の実行ファイルを検出できない場合は、拡張のRegistries設定のCustom search pathsに実際の配置ディレクトリを指定する。[拡張導入](https://abue-ammar.github.io/tinycast/docs/extensions/installing/)

## 更新と試用終了

アプリ内の `Check for Updates` で更新確認できる。公式ドキュメントは `brew upgrade` が更新をスキップすると説明しているが、調査時のcaskには `auto_updates true` がないため、その挙動は断定しない。[更新の説明](https://abue-ammar.github.io/tinycast/docs/install/)・[cask定義](https://github.com/abue-ammar/homebrew-tinycast/blob/main/Casks/tinycast.rb)

手動導入のアンインストールは `brew uninstall --cask abue-ammar/tinycast/tinycast`。宣言管理した場合は宣言も削除する。ただし本環境の `cleanup = "zap"` は保存データも削除対象にするため、必要なデータを先に退避する。[公式アンインストール手順](https://abue-ammar.github.io/tinycast/docs/install/)
