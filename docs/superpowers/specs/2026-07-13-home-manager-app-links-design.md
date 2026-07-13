# Home Manager アプリリンク設計

## 目的

Home Manager で導入する macOS アプリケーションを `~/Applications` 直下に配置し、Raycast と Spotlight から見つけられるようにする。

## 方針

Home Manager が生成する `Applications` ディレクトリから `.app` を列挙し、ユーザーの `~/Applications` 直下にシンボリックリンクを作る activation を追加する。

この activation は Pique を含む既存および将来の `home.packages` 内の GUI アプリへ共通で適用する。

## 衝突時の扱い

同名のアプリが `~/Applications` にすでに存在する場合は上書きしない。

Nix が管理する既存リンクだけを更新する。

## 検証

`just check` で flake 評価を確認する。

`just switch` の後、`~/Applications/Pique.app` が Nix ストアを指すリンクであることを確認する。

Raycast または Spotlight で Pique を検索し、起動できることを確認する。
