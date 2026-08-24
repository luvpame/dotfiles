# Nix flakeで管理するdotfilesのパス移植性

調査日：2026-08-24

## 結論

今回調査した公開dotfilesでは、checkout先の絶対パスを完全に消すより、live linkの参照先を一つの規約へ寄せる構成が多い。

`mkOutOfStoreSymlink`を使う限り、Nixは実行時に存在するcheckoutを指す必要があるためである。
そのため、公開例は次の三つへ分かれる。

- `~/ghq/github.com/<owner>/<repo>` のようにclone先を固定する。
- `~/.dotfiles` のような安定したシンボリックリンクをbootstrapで作り、Nixはその入口だけを参照する。
- checkoutをNix storeへ取り込む通常の`home.file`や`programs.*`を使い、変更時にrebuildする。

H1ronoとjessfrazは、`home.file`の相対source（`./zshrc`や`./init.lua`）でstore-backedにする実装を示している。[H1ronoのrelative source](https://github.com/H1rono/dotfiles/blob/main/home.nix#L81-L99)[jessfrazのrelative source](https://github.com/jessfraz/.vim/blob/main/flake.nix#L105-L111)
機種ごとの差分を`nixConfigDirectory`のようなhost metadataへ集約する設計もある。[malobのprimary user metadata](https://github.com/malob/nix-config/blob/master/flake.nix#L93-L98)

今回の要件（設定ファイルの編集を即時反映し、機種変更時のcheckout差異にも耐える）には、二つめの「安定した入口」が最も合う。
Kunchenguidのdotfilesは、bootstrapで実際のclone先を`~/.dotfiles`へリンクし、Home Manager側は`${config.home.homeDirectory}/.dotfiles`を参照している。[bootstrapで入口を作る処理](https://github.com/kunchenguid/dotfiles/blob/main/README.md#L35-L57)[^kunchenguid]
lambdalisueのdotfilesは、ghqの既定pathを残しつつ、`hostCfg.dotfilesDir`で端末ごとのcheckout pathを上書きできる。[lambdalisueのpath override](https://github.com/lambdalisue/dotfiles/blob/main/flake.nix#L527-L580)
したがって、安定した入口を作らずhost metadataへpathを置く設計も成立するが、端末ごとの値をどこで管理するかを追加で決める必要がある。

ghqを使うこともできる。
ただし、今回確認した公開実装では、Nix評価中に`ghq root`を実行するのではなく、ghqが作るディレクトリ規約を文字列として参照している。
ghqのrootを全端末で統一できるなら、現在の構成を`${config.home.homeDirectory}/dev/github.com/luvpame/dotfiles`のように保つ方法が簡単である。
clone場所を端末ごとに変えたいなら、ghqのroot自体を動的に読むより、安定した入口を一度作るほうがNixの評価とbootstrapの責務を分離できる。

`~/`の扱いは、Nixのpath literalか、引用した文字列かで変わる。
非引用のpath literal `~/foo`はユーザーのhomeを基準に解決されるが、`~`で始まるpath literalはpure evaluationでは許可されない。[Nix公式manualのpath literal](https://nix.dev/manual/nix/2.28/language/syntax#path)
一方、引用文字列`"~/foo"`は通常の文字列なので、Nixはチルダを展開しない。
Home Managerの`home.homeDirectory`は絶対パスでなければならず、nix-darwinやNixOSのサブモジュールとして使う場合はOS側のユーザーhomeから設定される。[Home Managerの`home.homeDirectory`定義](https://github.com/nix-community/home-manager/blob/master/modules/home-environment.nix#L199-L212)
flakeのpure evaluationとlive linkを両立するには、`"${config.home.homeDirectory}/.dotfiles"`のように明示的な文字列を組み立てる。

## 調査方法

GitHubで公開されている、`flake.nix`とHome Managerまたはnix-darwinを組み合わせたdotfilesを検索した。
2026-08-24時点で`main`または`master`ブランチの実ファイルを閲覧でき、パスの扱いを確認できるリポジトリを対象にした。
「現役」はGitHub上の現行ブランチにflakeと設定実装が存在することとして扱い、スター数や更新頻度だけで判定していない。

比較した項目は次のとおりである。

- checkout先をNixがどう表現するか。
- 設定をNix storeから配るか、checkoutへlive linkするか。
- `home.homeDirectory`、ユーザー名、host名、CPU architectureをどこへ置くか。
- ghqのディレクトリ規約を使うか。
- 機種変更時に必要な作業と、即時反映の範囲。

根拠にはリポジトリの`flake.nix`、Home Manager module、bootstrapまたはREADMEを使った。
ブログや二次解説は根拠にしていない。

## 比較表

| リポジトリ | checkoutの扱い | 配布方式 | ユーザーとhostの持ち方 | ghq | 機種変更時の性質 |
|---|---|---|---|---|---|
| [yuucu/dotfiles](https://github.com/yuucu/dotfiles) | `${config.home.homeDirectory}/ghq/github.com/yuucu/dotfiles` | `mkOutOfStoreSymlink` | `DOTFILES_USER`を`builtins.getEnv`で読み、空なら既定値へフォールバック。host名は`${username}-mac` | 使う | ユーザー名は環境変数で変えられるが、clone先のghq規約は固定。`--impure`が必要 |
| [furedea/dotfiles](https://github.com/furedea/dotfiles) | `/Users/${username}/ghq/github.com/furedea/dotfiles` | `mkOutOfStoreSymlink` | `username = "kaito"`をflakeに置き、`mba`と`mbp`をdarwin configurationとして公開 | 使う | ユーザー名とghq配下のclone先を変更する手順が必要 |
| [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles) | `${darwinHomedir}/ghq/github.com/ryoppippi/dotfiles`をmoduleへ渡す | Home Managerのactivationで`link_force`を実行するlive link | `username`、`darwinHomedir`、`linuxHomedir`をflakeで定義し、darwin用とLinux用の出力を生成 | 使う | home pathとghq規約をそろえる必要がある。`mkOutOfStoreSymlink`の代わりにactivationを使う例 |
| [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles) | 実際のclone先は自由。bootstrapが`~/.dotfiles`へリンク | `mkOutOfStoreSymlink` | flakeの一つの`user`からHome Managerのユーザーと`/Users/${user}`を組み立てる。host labelは`mac` | 使わない | clone先を変えても`~/.dotfiles`の入口を作り直せばよい。live linkと編集直後の反映を維持 |
| [DebopamParam/nix-darwin](https://github.com/DebopamParam/nix-darwin) | dotfilesのcheckoutをHome Managerのsourceとして参照しない | `programs.*`と`home.file.*.text`で生成し、Nix storeから配置 | `private.nix`に`username`、`hostname`、`system`を置き、`specialArgs`と`extraSpecialArgs`でmoduleへ渡す | 使わない | clone先の差異に強い。機種固有値を一つのファイルへ集約するが、設定ファイルの編集はrebuildが必要 |
| [tskovlund/nix-config](https://github.com/tskovlund/nix-config) | 呼び出し側のcheckoutをflake sourceとして使い、dotfilesの固定絶対パスを公開moduleに置かない | 引用したflakeと`home/default.nix`にはlive link定義を確認できず、`programs.*`中心 | `personal` inputの`identity`から`username`を取り、`darwin`、`darwin-base`などの出力を生成。任意のlocal moduleは`~/.config/nix-config/local.nix`から読む | 使わない | store-backedへ寄せやすい。local overrideは純粋評価と再現性とのトレードオフがある |
| [lambdalisue/dotfiles](https://github.com/lambdalisue/dotfiles) | home pathから組み立てたghq既定値。`hostCfg.dotfilesDir`で上書きできる | `mkOutOfStoreSymlink` | `hostCfg`から`username`、`system`、`dotfilesDir`を受け、role別のdarwin出力を生成 | 既定で使う | ghq規約を保ちつつ、hostごとのcheckout pathをmetadataとして上書きできる |
| [H1rono/dotfiles](https://github.com/H1rono/dotfiles) | checkoutの固定pathを設定moduleへ渡さない | `home.file.*.source = ./relative-path`でstore-backedにする | `user`と`homePrefix`から`home.username`、`home.homeDirectory`を生成 | 使わない | checkout場所に依存しない。設定変更はHome Managerのrebuildで反映 |
| [malob/nix-config](https://github.com/malob/nix-config) | `nixConfigDirectory`をhost metadataとして明示し、darwin systemとregistryへ渡す | ハイブリッド。[`home/claude.nix`](https://github.com/malob/nix-config/blob/master/home/claude.nix#L23-L28)が`${nixConfigDirectory}/configs/claude`をlive linkし、他の設定は生成する | `primaryUserDefaults`に`username`、identity、`nixConfigDirectory`を置き、`mkDarwinSystem`へ渡す | 使わない | clone先をhost metadataの一項目として変更できる。CI用overrideも同じ構造で表現 |

比較表の「配布方式」は、引用したファイルで確認できる範囲を記した。
特にstore-backedについて、Home Managerの`home.file.*.text`や`programs.*`が生成物を作ることと、同じリポジトリの別moduleがlive linkを追加していないことは別の事実である。
後者まで断定する場合は、リポジトリ全体のmoduleを確認する必要がある。

## 各リポジトリで確認できる実装

### ghqの固定規約を使う例

yuucuは、live linkのコメントで「repoの絶対パスに依存する」と明記し、`config.home.homeDirectory`から`ghq/github.com/yuucu/dotfiles`を組み立てている。[yuucuのlive link module](https://github.com/yuucu/dotfiles/blob/main/home/links.nix#L307-L319)
同じリポジトリのflakeは、ユーザー名だけを`DOTFILES_USER`から読み、host名を`${username}-mac`としている。[yuucuのflake出力](https://github.com/yuucu/dotfiles/blob/main/flake.nix#L430-L505)

furedeaは、`username`から`/Users/${username}/ghq/github.com/furedea/dotfiles`を組み立て、Home Managerへ`dotfilesDir`として渡している。[furedeaのflake](https://github.com/furedea/dotfiles/blob/main/flake.nix#L34-L38)[furedeaのHome Manager module](https://github.com/furedea/dotfiles/blob/main/nix/home/default.nix#L15-L17)
clone手順も同じghq階層を指定している。[furedeaのREADME](https://github.com/furedea/dotfiles/blob/main/README.md#L30-L54)

ryoppippiも`darwinHomedir`からghq配下の`dotfilesDir`を作り、darwin moduleへ渡している。[ryoppippiのflake](https://github.com/ryoppippi/dotfiles/blob/main/flake.nix#L124-L127)[darwin moduleへ渡す箇所](https://github.com/ryoppippi/dotfiles/blob/main/flake.nix#L571-L593)
ただし、実際のリンクはHome Manager activation内の`link_force`で作っている。[ryoppippiのlive link module](https://github.com/ryoppippi/dotfiles/blob/main/nix/modules/home/dotfiles.nix#L285-L327)

三つとも、Nixからghqコマンドを呼び出してrootを検出するのではない。
「全端末のghq rootとrepository owner/nameが同じ」という運用規約をNix側へ写している。
したがって、`ghq.root`を端末ごとに変える運用では、そのままでは追従しない。

lambdalisueは、この規約にhostごとの上書きを加えている。
`mkHome`の既定値は`/Users/<user>/ghq/github.com/lambdalisue/dotfiles`またはLinuxの対応するhome pathだが、`hostCfg.dotfilesDir`があればそれを使う。[lambdalisueのflake](https://github.com/lambdalisue/dotfiles/blob/main/flake.nix#L527-L580)
Home Manager側は、渡された`dotfilesDir`を`mkOutOfStoreSymlink`へ渡している。[lambdalisueのHome Manager files module](https://github.com/lambdalisue/dotfiles/blob/main/nix/home/files.nix#L305-L377)
固定規約を既定値として残しながら、機種ごとの例外をmetadataで表現する型である。

### 安定した入口をbootstrapで作る例

Kunchenguidは、clone後のbootstrapでrepositoryを`~/.dotfiles`へシンボリックリンクする。[Kunchenguidのbootstrap手順](https://github.com/kunchenguid/dotfiles/blob/main/README.md#L35-L57)
Home Managerは、`config.home.homeDirectory`から作った`dotfiles`変数を使い、`.config/nvim`などをその入口へ`mkOutOfStoreSymlink`する。[Kunchenguidのhome path](https://github.com/kunchenguid/dotfiles/blob/main/home.nix#L0-L8)[Kunchenguidのlive link](https://github.com/kunchenguid/dotfiles/blob/main/home.nix#L51-L75)

この方式では、clone先の実体だけが機種ごとに違い、Nixが参照する文字列は常に`$HOME/.dotfiles`になる。
Nixの評価時に現在の作業ディレクトリを調べる必要も、`ghq root`の結果を評価へ持ち込む必要もない。

### store-backedとmachine metadataを分ける例

DebopamParamは、flakeの`private.nix`から`username`、`hostname`、`system`を読み、nix-darwinの`specialArgs`とHome Managerの`extraSpecialArgs`へ渡している。[DebopamParamのflake](https://github.com/DebopamParam/nix-darwin/blob/main/flake.nix#L44-L86)
新しいMacでは`private.nix.example`をコピーし、端末固有値を一つのファイルへ記入する。[private.nixのテンプレート](https://github.com/DebopamParam/nix-darwin/blob/main/private.nix.example#L1-L25)

設定ファイルはGhosttyの内容を`home.file.*.text`で生成し、shellやGitなどは`programs.*`で宣言している。[生成されたGhostty設定](https://github.com/DebopamParam/nix-darwin/blob/main/modules/home/shell.nix#L113-L123)[Gitのprogram module](https://github.com/DebopamParam/nix-darwin/blob/main/modules/home/git.nix#L0-L16)
この方式ではcheckout先をruntimeの設定ファイルへ埋め込まない。
代わりに、設定の変更を反映するにはrebuildが必要になる。

tskovlundは、共通moduleとpersonal moduleを分け、`personal` inputの`identity`からユーザー名を読み込む。[tskovlundのflake](https://github.com/tskovlund/nix-config/blob/main/flake.nix)[tskovlundのHome Manager集約module](https://github.com/tskovlund/nix-config/blob/main/home/default.nix#L0-L21)
Home Managerの通常設定とは別に、`~/.config/nix-config/local.nix`を任意で読み込む仕組みも持つ。[local moduleの読み込み](https://github.com/tskovlund/nix-config/blob/main/flake.nix)
このlocal overrideはmachine差を外へ出せる一方、flakeの純粋評価だけで完結しない。

H1ronoは、checkoutのpathを設定へ渡さず、`home.file`のsourceに`./zshrc`や`./config/nvim/init.vim`のようなflake相対pathを置いている。[H1ronoのflake](https://github.com/H1rono/dotfiles/blob/main/flake.nix#L41-L107)[H1ronoのHome Manager設定](https://github.com/H1rono/dotfiles/blob/main/home.nix#L81-L99)
このsourceはflake sourceからstoreへ取り込まれるため、Nix管理の設定としては移植しやすい。
編集を即時反映するlive linkではなく、Home Managerのrebuildで世代を更新する方式である。

同じrelative sourceの型は、Vim設定だけを配るjessfrazの`.vim`にも見られる。
Home Manager moduleが`./init.lua`と`./lua`を`home.file`へ設定している。[jessfrazの`.vim` flake](https://github.com/jessfraz/.vim/blob/main/flake.nix#L50-L119)

malobは、checkoutの場所を単なる文字列として散在させず、`primaryUserDefaults`の`nixConfigDirectory`へまとめている。[malobのprimary user metadata](https://github.com/malob/nix-config/blob/master/flake.nix#L93-L98)
`mkDarwinSystem`は`username`、identity、`nixConfigDirectory`を引数として受け、Home Managerとsystem moduleへ配る。[malobの`mkDarwinSystem`](https://github.com/malob/nix-config/blob/master/lib/mkDarwinSystem.nix#L1-L52)
`home/claude.nix`は、その値から`${nixConfigDirectory}/configs/claude`を組み立て、`mkOutOfStoreSymlink`でClaude設定をlive linkしている。[malobのClaude設定](https://github.com/malob/nix-config/blob/master/home/claude.nix#L23-L28)[live linkの定義](https://github.com/malob/nix-config/blob/master/home/claude.nix#L133-L144)
CI構成では同じmetadataをrunner用pathへoverrideしている。[malobのCI override](https://github.com/malob/nix-config/blob/master/flake.nix#L258-L266)
この設計は、hostごとの差分を一つの入力値へ閉じ込める。

### checkout pathを明示的なruntime worktreeへ分離する例

colonelpanic8は、flake sourceからファイル一覧を列挙し、実際のsymlink先は`nixos.config.dotfiles-worktree`で別に指定している。[colonelpanic8のdotfiles link module](https://github.com/colonelpanic8/dotfiles/blob/master/nixos/dotfiles-links.nix#L7-L24)
`mkOutOfStoreSymlink`にはruntime worktreeを渡し、編集をrebuildなしで反映する。[live linkの生成](https://github.com/colonelpanic8/dotfiles/blob/master/nixos/dotfiles-links.nix#L55-L76)
この設計は、Nixが「どのファイルを管理するか」をflake sourceから決め、Nixが「どこにcheckoutがあるか」をmachine設定から受け取る分離である。
Mac向け実装へそのまま移植するにはnix-darwin側のmodule配線が必要だが、固定パスを一つのmodule optionへ閉じ込める考え方は利用できる。

## パターン分類

### パターンA：固定したclone規約とlive link

`homeDirectory`とrepositoryのowner/nameからcheckout pathを組み立て、`mkOutOfStoreSymlink`またはactivationの`ln -s`で設定を配る。

yuucu、furedea、ryoppippiがこの型であり、lambdalisueは固定された既定pathへhostごとのoverrideを加えている。

編集は即時反映される。
一方で、ユーザー名、ghq root、repository階層のどれかが変わるとlinkが壊れる。
ユーザー名を環境変数で補う例はあるが、その場合は`--impure`とbootstrapの責務が増える。[yuucuの`builtins.getEnv`利用](https://github.com/yuucu/dotfiles/blob/main/flake.nix#L430-L441)

### パターンB：安定した入口とlive link

bootstrapや手動初期化で、実際のcheckoutを`$HOME/.dotfiles`や`$HOME/.local/share/dotfiles-source`へリンクする。
Nixは`${config.home.homeDirectory}/.dotfiles`のような一つの絶対パスだけを参照する。

Kunchenguidの実例では、実体のcheckout pathとNixが読むpathが分離している。
機種変更時に必要なのは、clone後に入口を作る一回の処理だけである。

この型では、flake sourceではなく、実行時checkoutを指す明示的な絶対path文字列をlive linkへ渡す必要がある。[Home Manager upstream issue #2085](https://github.com/nix-community/home-manager/issues/2085)
しかし、その絶対pathがユーザーのhomeから決まる安定した入口になるため、Git管理するNix codeへcheckout先を直接埋め込まずに済む。

### パターンC：store-backed配布

flake内のsourceや`programs.*`、`home.file.*.text`からNix storeの生成物を作り、Home Managerにhomeへ配置させる。

checkout pathの差異をruntime設定から除ける。
その代わり、設定ファイルを編集しただけでは反映されず、rebuildが必要になる。

DebopamParamの`programs.*`中心の構成がこの型に近い。
H1ronoとjessfrazのrelative sourceもこの型である。
furedeaも、頻繁に編集する設定はlive linkにし、Nixが生成するplugin pathは`home.file.*.text`へ分けている。[furedeaのHome Manager設定](https://github.com/furedea/dotfiles/blob/main/nix/home/default.nix#L236-L242)
これは二つの性質を一つの配布方式へ押し込めず、ファイル単位で使い分けるハイブリッドである。

### パターンD：machine metadataへcheckout pathを置く

ユーザー名、host名、CPU architecture、checkout rootなどの端末固有値を、host台帳や`private.nix`へ集約する。
moduleは`specialArgs`や`extraSpecialArgs`から受け取る。

DebopamParamは`private.nix`へidentityとhost metadataを集約している。
colonelpanic8はruntime worktreeをmodule optionから受け取る。
lambdalisueは`hostCfg.dotfilesDir`を、malobは`nixConfigDirectory`をhost metadataへ置いている。

この型は複数台を明示的に管理しやすい。
ただし、machine-local fileをflakeの外へ置く場合は、pure evaluation、CI、初回bootstrapのどこまで同じ値を見られるかを決めなければならない。
tskovlundのlocal module読み込みは、そのトレードオフを明示した例である。

## このリポジトリへの提案

現在の構成は、flakeで`repoRoot`を作り、Home Manager moduleへ渡し、各設定を`mkOutOfStoreSymlink`で配っている。[現在の`repoRoot`](../../nix/flake.nix#L40-L53)[現在のlive link設定](../../nix/nix-darwin/home-manager/files.nix#L8-L18)
また、`just switch`はcanonical checkoutの絶対pathと一致することを確認してからswitchしている。[現在のcanonical checkout検査](../../justfile#L1-L20)

要件ごとの選択は次のようになる。

| 要件 | 推奨する方式 | 理由 |
|---|---|---|
| 即時反映を優先し、全Macでcheckout場所を統一できる | ghq規約を固定 | `${config.home.homeDirectory}/dev/github.com/luvpame/dotfiles`を一つの規約として維持できる。Nix評価へ外部状態を持ち込まない |
| 即時反映を優先し、clone場所は機種ごとに自由にしたい | 安定した入口 | `~/.local/share/dotfiles-source`などを一度作り、Nixは入口だけを参照する。Kunchenguidの方式をこのリポジトリへ適用できる |
| 即時反映を維持し、hostごとのcheckout pathを明示管理したい | `dotfilesDir`をhost metadataへ置く | lambdalisueの`hostCfg.dotfilesDir`のように例外を一か所へ集約できる。metadataの値自体は端末ごとに管理する |
| checkout pathをGit管理するNix codeから完全に消したい | store-backedまたはmachine metadata | 前者はrebuildが必要。後者はlocal値の扱いと`--impure`の境界を決める必要がある |

このリポジトリでは、まずパターンBを採用するのがよい。
具体的には次の契約にする。

```text
実際のclone先
    ↓ bootstrapで一度だけ作る
~/.local/share/dotfiles-source
    ↓ Nixが参照
    ${config.home.homeDirectory}/.local/share/dotfiles-source
    ↓ mkOutOfStoreSymlink
~/.config、~/.codex、~/.claude、~/.zshenv
```

Home Manager module側では次のようにする。

```nix
let
  repoRoot = "${config.home.homeDirectory}/.local/share/dotfiles-source";
in
{
  # 既存のoos定義へ接続する。
}
```

現在のように`repoRoot`をflakeの`specialArgs`から渡す構成を維持するなら、flake側では`homeDirectory`から入口を組み立てる。[現在のspecialArgs](../../nix/flake.nix#L46-L55)
Home Manager module側で`config.home.homeDirectory`から再計算するか、flake側で計算した値を渡すかは一つに決める。

bootstrap側では、既存の入口が正しいsymlinkか確認してから作成する。
入口の実体が変わったときだけリンクを更新し、Nix module側でcheckoutの存在を自動検出しない。
そうすれば、初回セットアップの失敗を隠さず、pureなflake評価も保てる。

ghqを使う場合は、入口の実体をghqで取得すればよい。
例えば`ghq.root = ~/dev`を全Macの規約にして`ghq get github.com/luvpame/dotfiles`を実行し、その結果を入口へ向ける。
Nixはghqを呼ばず、入口だけを参照する。

既存の`just switch`にあるcanonical checkout検査は、入口方式へ移行した後は「親directoryが固定pathか」を検査する責務を持てない。
検査を残すなら、入口が存在し、symlinkの実体がGit worktreeであることを確認する形へ変える。
検査を薄くするなら、入口が壊れていると`mkOutOfStoreSymlink`のactivationが失敗するため、canonical checkoutそのものの比較は削除できる。

設定ファイルの一部をstore-backedへ移す判断は、live linkの要件とは独立させる。
`direnvrc`のようにNix store pathを埋め込む生成ファイルは現状の`text`方式を残し、編集頻度が高く、アプリが書き戻す必要がある設定だけを入口からlive linkする。[現在の生成ファイル](../../nix/nix-darwin/home-manager/files.nix#L40-L44)

## 一次資料一覧

### NixとHome Manager

- [Nix公式manualのpath literal](https://nix.dev/manual/nix/2.28/language/syntax#path)：非引用の`~/foo`はhome相対pathとして解決されるが、pure evaluationでは`~`始まりのpath literalを使えない。引用文字列`"~/foo"`は展開されない。
- [Home Manager `home.homeDirectory` option](https://github.com/nix-community/home-manager/blob/master/modules/home-environment.nix#L199-L212)：home pathは絶対pathであり、nix-darwinやNixOSのsubmoduleではOS側のhomeから設定される。
- [Home Manager file option type](https://github.com/nix-community/home-manager/blob/master/modules/lib/file-type.nix#L653-L668)：`home.file.*.source`はsource fileまたはdirectoryを受け取る。
- [`mkOutOfStoreSymlink`とflake pathに関するupstream issue](https://github.com/nix-community/home-manager/issues/2085)：flake sourceをそのまま渡した場合にNix store側を指す問題が議論されている。

### 調査対象のdotfiles

- [yuucu/dotfilesのflake](https://github.com/yuucu/dotfiles/blob/main/flake.nix#L430-L505)
- [yuucu/dotfilesのlive link](https://github.com/yuucu/dotfiles/blob/main/home/links.nix#L307-L319)
- [furedea/dotfilesのflake](https://github.com/furedea/dotfiles/blob/main/flake.nix#L34-L38)
- [furedea/dotfilesのHome Manager module](https://github.com/furedea/dotfiles/blob/main/nix/home/default.nix#L15-L17)
- [furedea/dotfilesのHome Manager生成設定](https://github.com/furedea/dotfiles/blob/main/nix/home/default.nix#L236-L242)
- [ryoppippi/dotfilesのflake](https://github.com/ryoppippi/dotfiles/blob/main/flake.nix#L124-L127)
- [ryoppippi/dotfilesのdarwin用path注入](https://github.com/ryoppippi/dotfiles/blob/main/flake.nix#L571-L593)
- [ryoppippi/dotfilesのactivation live link](https://github.com/ryoppippi/dotfiles/blob/main/nix/modules/home/dotfiles.nix#L285-L327)
- [kunchenguid/dotfilesのbootstrap](https://github.com/kunchenguid/dotfiles/blob/main/README.md#L35-L57)
- [kunchenguid/dotfilesのHome Manager path](https://github.com/kunchenguid/dotfiles/blob/main/home.nix#L0-L8)
- [kunchenguid/dotfilesの`mkOutOfStoreSymlink`](https://github.com/kunchenguid/dotfiles/blob/main/home.nix#L51-L75)
- [DebopamParam/nix-darwinのflake](https://github.com/DebopamParam/nix-darwin/blob/main/flake.nix#L44-L86)
- [DebopamParam/nix-darwinのmachine metadata template](https://github.com/DebopamParam/nix-darwin/blob/main/private.nix.example#L1-L25)
- [DebopamParam/nix-darwinの生成設定](https://github.com/DebopamParam/nix-darwin/blob/main/modules/home/shell.nix#L113-L123)
- [tskovlund/nix-configのflake](https://github.com/tskovlund/nix-config/blob/main/flake.nix)
- [tskovlund/nix-configのHome Manager集約module](https://github.com/tskovlund/nix-config/blob/main/home/default.nix#L0-L21)
- [lambdalisue/dotfilesのhost path override](https://github.com/lambdalisue/dotfiles/blob/main/flake.nix#L527-L580)
- [lambdalisue/dotfilesのlive link module](https://github.com/lambdalisue/dotfiles/blob/main/nix/home/files.nix#L305-L377)
- [H1rono/dotfilesのflake](https://github.com/H1rono/dotfiles/blob/main/flake.nix#L41-L107)
- [H1rono/dotfilesのrelative source](https://github.com/H1rono/dotfiles/blob/main/home.nix#L81-L99)
- [jessfraz/.vimのHome Manager module](https://github.com/jessfraz/.vim/blob/main/flake.nix#L50-L119)
- [malob/nix-configのprimary user metadata](https://github.com/malob/nix-config/blob/master/flake.nix#L93-L98)
- [malob/nix-configの`mkDarwinSystem`](https://github.com/malob/nix-config/blob/master/lib/mkDarwinSystem.nix#L1-L52)
- [malob/nix-configのClaude設定live link](https://github.com/malob/nix-config/blob/master/home/claude.nix#L23-L28)
- [malob/nix-configのlive link定義](https://github.com/malob/nix-config/blob/master/home/claude.nix#L133-L144)
- [malob/nix-configのCI path override](https://github.com/malob/nix-config/blob/master/flake.nix#L258-L266)
- [colonelpanic8/dotfilesのruntime worktree link](https://github.com/colonelpanic8/dotfiles/blob/master/nixos/dotfiles-links.nix#L7-L24)
- [colonelpanic8/dotfilesのlive link生成](https://github.com/colonelpanic8/dotfiles/blob/master/nixos/dotfiles-links.nix#L55-L76)

### このリポジトリ

- [現在のflake path注入](../../nix/flake.nix#L40-L53)
- [現在のHome Manager live link](../../nix/nix-darwin/home-manager/files.nix#L8-L18)
- [現在のcanonical checkout検査](../../justfile#L1-L20)

[^kunchenguid]: このリポジトリは、実体のclone先を`~/.dotfiles`へリンクした後に`darwin-rebuild`を実行する手順を明記している。
