# コピー済み6スキルの取得元と外部管理への移行

調査日: 2026-09-14

## 結論

6件とも、内容の一致または同系統の本文を確認できる公開取得元が見つかった。
`show-me` と `japanese-tech-writing` は現在のファイルと完全一致する公開版を固定できる。
残り4件は、ローカル差分の保持、ファイル名の変換、上流の更新内容の採用判断が必要になる。
今回の調査ではスキル本体と Nix 設定を変更していない。

コピー時の取得URLは、このリポジトリの確認した履歴とスキルロックに記録されていなかった。
以下は取得元として使える原著または公式版との比較であり、当時どの転載先からコピーしたかまで特定したものではない。

## 取得元と差分

| スキル | 確認した公開版 | 現在のファイルとの差分と移行方法 |
| --- | --- | --- |
| show-me | [humanlayer/skills](https://github.com/humanlayer/skills/blob/3c2629142c5d437428269b1b722b08c0b87f574d/plugins/show-me/skills/show-me/SKILL.md) | バイト単位で完全一致。ディレクトリには SKILL.md のみ。通常の外部ソースとして選択できる。 |
| japanese-tech-writing | [k16shikano の原著Gist](https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d/5ed08e4475365fd233aa0d3ab71c19b87e1a5732) | この過去版と完全一致。Gist内のファイル名は SKILL.md。GistをGit入力として固定できる。現行版では「整形」節の削除などがあり、現行版への更新と管理方式の移行を区別する。 |
| cognitive-rhythm-writing | [k16shikano の原著Gist](https://gist.github.com/k16shikano/eb2929f13ed19c97188393d297be8432/a3b1e26beced71d582e13314fb6f5b179b023c76) | ローカルで japanese-end-focus への参照を追記した1行以外は完全一致。Gist内のファイル名は SKILL.md。この追加規範を維持するなら外部取得後の変換に残す。 |
| code-simplifier | [Anthropic公式](https://github.com/anthropics/claude-plugins-official/blob/022b3c274938ddfb9fd928fc582eb9b9ed0f537f/plugins/code-simplifier/agents/code-simplifier.md) | 公式から frontmatter の `model: opus` 1行を除くと完全一致。公式はエージェント定義の `code-simplifier.md` なので、Nixで SKILL.md として配置する処理が必要。 |
| empirical-prompt-tuning | [mizchi/skills の日本語版](https://github.com/mizchi/skills/blob/66dadd9613719251c1501ba482c08cbd7f55ffee/meta/empirical-prompt-tuning/SKILL-ja.md) | 上流日本語版245行、ローカル186行。上流にはTrace、構造化振り返り、失敗パターン台帳、バリアント探索などの追加がある。日本語を維持するなら SKILL-ja.md を SKILL.md として配置する。既定の SKILL.md は英語版。完全一致する過去版は未特定。 |
| herdr | [herdrdev/herdr 公式](https://github.com/herdrdev/herdr/blob/c77af1892ff121736ecb103b32d504d6f1b31805/skills/herdr/SKILL.md) | 同系統の本文で、通常の外部ソースとして選択できる。現行上流にはmachine/SSH、複数クライアントのseen状態、prompt送信と待機、再送、workspace group、Git trust、client/serverの版差に関する変更がある。導入済みCLIに合う版を選ぶ。 |

上のリンクは、比較に使用したリビジョンを固定している。
`code-simplifier` と `empirical-prompt-tuning` はファイル名も変える必要があるため、SKILL.md の本文を変換する `transform` だけでは配置を完結できない。
取得元のファイルを SKILL.md として提供する小さなNixの処理を用意する。

## ローカル履歴で確認できた変更

| スキル | このリポジトリでの履歴 |
| --- | --- |
| show-me | [f924d4f](https://github.com/luvpame/dotfiles/commit/f924d4f288d95f9b90f62d0b6dee556886db92c7) で追加後、変更なし。 |
| japanese-tech-writing | [264f33e](https://github.com/luvpame/dotfiles/commit/264f33e68f914b98d57bcaaed4a54c7666d80c4f) で追加後、変更なし。 |
| cognitive-rhythm-writing | [5aaa351](https://github.com/luvpame/dotfiles/commit/5aaa35104d2faee5b8fa2128378d049a3eb88862) で追加。[e104493](https://github.com/luvpame/dotfiles/commit/e104493093f784667cad1f1fef6c939c11337474) で japanese-end-focus の参照を追記。 |
| code-simplifier | [e420860](https://github.com/luvpame/dotfiles/commit/e420860092d8368132cc9760fee25b284b045611) で現在版を追加後、変更なし。以前のバンドルコピーは一度削除されている。 |
| empirical-prompt-tuning | [a1d22b7](https://github.com/luvpame/dotfiles/commit/a1d22b7eee836fdd81a67608fa1f662b10a09f16) で追加。[3745b54](https://github.com/luvpame/dotfiles/commit/3745b54666e366bbb1deeedd013b44048a4118e1) で関連リンク6行を削除。現在版のdescriptionには上流にない AGENTS.md の記載もある。 |
| herdr | [b19e38e](https://github.com/luvpame/dotfiles/commit/b19e38e19ab6b2d3877a9796a7a98138739f031f) で追加後、[1a0ec9e](https://github.com/luvpame/dotfiles/commit/1a0ec9e2efcd93da039f10ecbb3431c988052a9a) と [44f16f9](https://github.com/luvpame/dotfiles/commit/44f16f96d838a0013a13e1600fcc98ab2810d990) で更新。初回300行から現在195行への更新と、現在の公式版との差分は別の比較である。 |

6件とも調査時の作業ツリーと Git HEAD の内容は一致した。
追加後に変更がないことは、追加時から上流と同一だったことを意味しない。

## 日本語系スキルの相対参照

今回対象外のローカルスキルにも、移行対象への参照がある。

- `japanese/SKILL.md` は `../japanese-tech-writing/SKILL.md`、`../japanese-end-focus/SKILL.md`、`../cognitive-rhythm-writing/SKILL.md` を参照する。
- `japanese-end-focus/SKILL.md` は `../japanese-tech-writing/SKILL.md` を参照する。
- `cognitive-rhythm-writing/SKILL.md` は、ローカル版では上記2規範、原著では japanese-tech-writing を参照する。

ディレクトリのシンボリックリンクを経由した `../` は、配布先ではなくリンクの実体側を基準に解決される。
そのため、ローカル原本を退避した後も従来の兄弟相対参照を残すと、参照切れや別の版の参照につながる。
一時ディレクトリで、配布先には存在する外部スキルが、ローカルスキル経由の兄弟相対パスでは見つからないことを再現した。
実装時は対象外の2スキルも含め、配布先の実際の絶対パスを使うなどして参照を揃える必要がある。

## ライセンスと転載先

`show-me` の取得元は [MIT](https://github.com/humanlayer/skills/blob/3c2629142c5d437428269b1b722b08c0b87f574d/LICENSE)。
日本語2件の原著者は [公開Gist全体へのUnlicense宣言](https://gist.github.com/k16shikano/67625f2a7d96e3bbdfae8d571a936063) を公開している。
`code-simplifier` の [プラグイン個別ライセンス](https://github.com/anthropics/claude-plugins-official/blob/022b3c274938ddfb9fd928fc582eb9b9ed0f537f/plugins/code-simplifier/LICENSE) と `herdr` の [公式ライセンス](https://github.com/herdrdev/herdr/blob/c77af1892ff121736ecb103b32d504d6f1b31805/LICENSE) は Apache-2.0。
`mizchi/skills` は [READMEのLicense節](https://github.com/mizchi/skills/blob/66dadd9613719251c1501ba482c08cbd7f55ffee/README.md#license) で、個別LICENSE.txtがないスキルの既定をMITとしている。対象ディレクトリには個別LICENSE.txtがない。

日本語2件には [trapple/skills の転載](https://github.com/trapple/skills/tree/5b38c79f2f125bfce4688a0dc8b15a6e80e3e344) もあるが、descriptionの英語化や規則の追加があり、現在版を保つ用途では原著Gistを直接使う方が差分を小さくできる。

## 推奨する移行方針

取得元の切り替えと内容の更新を分ける。
まず完全一致版または差分の小さい版を固定し、現在のローカル規範を維持する。
`empirical-prompt-tuning` と `herdr` は上流との差分があるため、その更新内容を採用するかを決めてから切り替える。
移行時は `localSkills` から対象名を外し、外部の選択に登録して、同名スキルの重複を避ける。

## 実装時の追加確認

その後の実装では、現在の本文に近い次の旧版を特定できた。

- empirical-prompt-tuning: [mizchi/skills@95b8a50](https://github.com/mizchi/skills/blob/95b8a50edf0684620c29d09848591de453b99831/empirical-prompt-tuning/SKILL.md)。この時点の SKILL.md は日本語で、descriptionと関連リンクの差分をパッチで適用すると現在版を再現できる。
- herdr: [v0.8.2 の固定コミット](https://github.com/herdrdev/herdr/blob/9eb521456ac0d19d3ab3d9d7cea3cca10baa8a4c/skills/herdr/SKILL.md)。agent start と agent prompt の2段落の差分をパッチで適用すると現在版を再現できる。

他の4件は比較表の固定版を採用し、6件とも現在の本文を再現する方針とした。
日本語系の参照は配布先へ変更し、旧原本は反映成功後に退避する。
