# macOS Now Playing 統合設計

## 目的

メニューバーには、Spotify または Dia が macOS の Now Playing へ公開している再生中のメディアだけを表示する。

## 方式

`media-control get --micros` を一度実行し、macOS が現在選んでいる Now Playing セッションを JSON で取得する。

`bundleIdentifier` が `com.spotify.client` または `company.thebrowser.dia` で、`playing` が `true` の場合だけ、曲名とアーティストを表示する。

Spotify と Dia が同時に再生している場合は、macOS が現在の Now Playing セッションとして選んだ側を表示する。

既存の Spotify 用 AppleScript は削除し、ブラウザのタブ走査や SoundCloud API は使用しない。

## 依存関係

リポジトリが固定している nixpkgs には `media-control` がないため、Homebrew の `media-control` formula を宣言する。

JSON の抽出には、すでに Home Manager で管理している `jq` を使用する。

## エラー処理

`media-control` または `jq` が未導入の場合、Now Playing 情報を取得できない場合、対象外アプリの場合、停止中または一時停止中の場合は、何も出力せず正常終了する。

曲名またはアーティストの一方が欠けた場合は存在する値だけを表示し、両方が欠けた場合は `Playing` を表示する。

## テスト

外部コマンドをテスト用実装へ差し替え、Spotify の再生、Dia の再生、一時停止、対象外アプリ、取得失敗をシェルスクリプトから確認する。

Nix の評価と `nix flake check` で Homebrew formula の宣言を検証する。
