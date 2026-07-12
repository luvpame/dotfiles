# Pique 導入設計

## 目的

macOS 26 以降の全プロファイルで、Pique による設定ファイルとスクリプトの Quick Look プレビューを使えるようにする。

## 方針

`nix/pkgs/pique/default.nix` を追加する。

この derivation は GitHub Releases の署名済み `Pique-0.1.0b5.pkg` を URL とハッシュで固定取得し、`Pique.app` を取り出して Nix ストアに配置する。

`nix/nix-darwin/home-manager/packages/common.nix` の `commonPackages` にこの derivation を加える。

Home Manager はアプリケーションへのリンクを `~/Applications/Home Manager Apps` に作成する。

初回適用後、ユーザーは Pique を起動し、システム設定で Quick Look 拡張を有効にする。

## 採用しない案

上流ソースをビルドしない。

上流のコード署名と公証を再現できないためである。

`installer` を activation で実行しない。

インストール済み状態が Nix の世代管理から外れるためである。

## 検証

`nixfmt` で変更した Nix ファイルを整形する。

`just check` で flake 評価を確認する。

`just switch` の後、Pique を起動して Quick Look 拡張を有効化し、対応ファイルを Finder でプレビューする。
