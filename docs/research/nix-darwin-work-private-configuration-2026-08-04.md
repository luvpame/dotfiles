# 仕事用Macとプライベート用Macの構成を分離する設計

調査日：2026-08-04

## 結論

`work` と `private` の二つを直接選ぶだけなら、設定は小さく見える。
しかし、その選択を毎回人に任せるかぎり、プライベート用Macへ仕事用アプリを適用する事故は残る。

推奨するのは、**物理ホストをデプロイ単位、roleをアプリ集合の分類単位にする構成**である。
Git管理するホスト台帳で各Macを一つのroleへ結び、台帳からホスト名付きの `darwinConfigurations` を生成する。
共通設定、role別設定、ホスト固有設定はNix moduleとして分ける。

日常のinterfaceは一つでよい。

```console
$ just switch
```

その内側では `darwin-rebuild switch --flake <flake-path>` を実行し、構成名を指定しない。
`darwin-rebuild` は `--flake` の `#構成名` が省略されると `scutil --get LocalHostName` を使って `darwinConfigurations.<LocalHostName>` を選ぶため、利用者は `work` か `private` かを入力しない。[nix-darwinの `darwin-rebuild` 実装](https://github.com/nix-darwin/nix-darwin/blob/master/pkgs/nix-tools/darwin-rebuild.sh#L148-L165)

最終的な構成は次の関係になる。

```text
LocalHostName
    ↓
hosts.<LocalHostName>
    ├── system
    ├── userName
    └── role = work | private
                 ↓
common module + role module + host module
                 ↓
darwinConfigurations.<LocalHostName>
```

この設計だけでは、macOS上にある全アプリを完全には収束させられない。
NixとHome Managerが管理するパッケージは新しい世代の利用環境から外せるが、Homebrew、Mac App Store、MDMやvendor installerでは削除能力が異なるからだ。
Homebrew formulaとcaskは `homebrew.onActivation.cleanup = "uninstall"` で宣言外を削除できる一方、nix-darwinは `homebrew.masApps` から消したMac App Storeアプリを同じcleanupでは削除できないと明記している。[nix-darwin Homebrew options](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.onActivation.cleanup)、[nix-darwin `homebrew.masApps` option](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.masApps)
Mac App Storeアプリを削除まで収束させる場合は、別の `programs.mas.packages` と `programs.mas.cleanup` を使う。[nix-darwin `programs.mas` options](https://nix-darwin.github.io/nix-darwin/manual/#opt-programs.mas.cleanup)

したがって、「反対roleのアプリを残さない」という保証はインストール経路ごとに定める。

- Nix packageとHome Manager packageは、`common` と選択されたroleだけから構成する。
- Homebrew formulaとcaskは、全手動インストールも宣言へ移したうえで `cleanup = "uninstall"` を使う。
- role専用のMac App Storeアプリは `homebrew.masApps` ではなく `programs.mas.packages` へ一本化する。
- Mac App Storeアプリを完全な宣言管理に含めるホストでは、現在の全アプリを台帳へ移したあと `programs.mas.cleanup = true` を有効にする。

この範囲を越えて、Webから手動で入れたアプリや会社のMDMが配布したアプリまでnix-darwinが削除するとは考えない。
それらは別の管理主体が所有している。

## 収束させる状態

各ホストで有効にするアプリ集合は、次の式で定める。

```text
desiredApps(host) = commonApps ∪ roleApps(host.role)
```

`workApps` と `privateApps` は互いに素とする。
両方で使うアプリは重複してroleへ書かず、`commonApps` へ移す。
ホスト固有moduleにはディスプレイ設定やハードウェア差だけを置き、アプリの例外を許さない。
ホスト固有のアプリ例外を許すと、どのMacに仕事用アプリが入るかをroleだけでは説明できなくなるためである。

アプリの分類は、設定moduleへ散らさず一つのsoftware台帳へ集約する。
台帳を `common`、`work`、`private` の三つに分け、各scopeの中でNix package、Homebrew formula、cask、Mac App Store App IDを宣言する。

```nix
{
  common = {
    nixPackages = pkgs: [ pkgs.ripgrep ];
    casks = [ "wezterm" ];
    mas = { };
  };

  work = {
    nixPackages = pkgs: [ pkgs.awscli2 ];
    casks = [ "orbstack" ];
    mas = { };
  };

  private = {
    nixPackages = _: [ ];
    casks = [ "discord" ];
    mas.Xcode = 497799835;
  };
}
```

構成生成moduleは `common` とホストのroleだけを合成し、installerごとのnix-darwin／Home Manager optionへ変換する。
同じ識別子が複数scopeに現れた場合はflake checkで失敗させる。
この小さな台帳なら、独自の汎用package DSLを作らずに、アプリの所属と供給元を一か所で確認できる。

ここでいう収束は、「選択した構成をswitchしたあと、有効な利用環境と管理対象アプリに反対roleの項目がない」ことを指す。
過去のNix世代がNix storeに残っているか、アプリが作成したデータまで消えているかは別の性質であり、この保証には含めない。

Home Managerは `home.packages` を「ユーザー環境に現れるpackageの集合」と定義している。[Home Manager `home.packages`](https://nix-community.github.io/home-manager/options/home-manager/home.html#opt-home.packages)
Home Managerをnix-darwin moduleとして組み込むと、`darwin-rebuild` の一回のactivationでユーザー環境も適用される。[Home Managerのnix-darwin module](https://nix-community.github.io/home-manager/installation/nix-darwin.html)
この統合により、systemとhomeを別々にswitchして片方だけ古いまま残す操作を日常からなくせる。

## 設計案の比較

三つの案は、同じrole moduleを使っても、選択のseamが異なる。

| 案 | 日常操作 | 取り違えの防止 | ホスト差 | pure evaluation | 判定 |
|---|---|---|---|---|---|
| role名を直接公開 | `switch --flake .#work` | 利用者が毎回正しく選ぶ必要がある | 別の仕組みが必要 | 可能 | 不採用 |
| ホスト台帳からroleを導出 | `switch --flake .` | LocalHostNameと台帳の対応で固定する | 同じ台帳で表せる | 可能 | 推奨 |
| 非追跡のローカルファイルや環境変数でroleを選択 | `switch --impure` 相当 | 各Macのローカル状態に依存する | 表せる | 損なう | 不採用 |

### role名を直接公開する案

`darwinConfigurations.work` と `darwinConfigurations.private` は小さく、Macが一台しかなければ理解しやすい。
しかし、仕事用Macでも `#private` を指定でき、プライベート用Macでも `#work` を指定できる。
このinterfaceには「このMacに許されたrole」という不変条件がない。

roleはアプリ集合を再利用する単位として残す価値がある。
ただし、デプロイ先を識別する名前には向かない。

### ホスト台帳からroleを導出する案

nix-darwinの公式flake例は、`darwinConfigurations` の属性名にMacのホスト名を使う。[nix-darwin README](https://github.com/nix-darwin/nix-darwin#flakes-recommended-for-beginners)
さらに `darwin-rebuild` 自身がLocalHostNameを既定の属性名として選ぶため、ホスト名をinterfaceにすると独自のselectorが要らない。[`darwin-rebuild.sh`](https://github.com/nix-darwin/nix-darwin/blob/master/pkgs/nix-tools/darwin-rebuild.sh#L154-L165)

ホスト台帳には `role`、`system`、`userName` のように評価時に必要な非秘密値を置く。
`role` には `enum [ "work" "private" ]` 相当の型を与えるか、構成生成関数で同じ制約を検査する。
Nix module systemはoptionの型を検査し、許可されていない値や型の違う値を評価時にエラーにできる。[nix.dev Module system](https://nix.dev/tutorials/module-system/index.html)、[nix.devの `enum` 解説](https://nix.dev/tutorials/module-system/deep-dive.html#the-either-and-enum-types)

ホストを追加する頻度は、switchする頻度よりはるかに低い。
そのため、ホスト追加時に一件の台帳を編集する負担と引き換えに、毎日の選択をなくすほうが利用者の操作に合う。

### ローカル値でroleを選ぶ案

Git管理外の `local.nix` や環境変数にroleを置けば、表面上は自動選択に見える。
ところが、Git repositoryをflakeとして使う場合、Nixがbuild対象にするのは追跡済みファイルであり、flakeのsource treeはNix storeへコピーされる。[nix.dev Flakes](https://nix.dev/concepts/flakes.html)
外部の可変pathを読むには `--impure` が必要になりやすく、`--impure` はmutable pathへのaccessを許すoptionである。[Nix `nix eval`](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-eval.html#opt-impure)

この案ではCIが見ているroleと実機が選ぶroleが一致する保証を作りにくい。
ローカルファイルが壊れたときだけ構成選択に失敗し、repositoryだけを読んでも全ホストとの対応を確認できない。
role selectorをローカルへ置く利点は、LocalHostNameによる公式のselectorがすでにあるため残らない。

## 階層化moduleとnamed configurationの役割

階層化moduleとnamed `darwinConfigurations` は競合する案ではない。
前者は設定を合成するimplementationであり、後者は完成したホスト構成を公開するinterfaceである。

Nix module systemは複数のmoduleが定義した値をoptionの型に従ってmergeし、`imports` で設定を分割できる。[NixOS Manualのmodule解説](https://nixos.org/manual/nixos/stable/#sec-writing-modules)、[nix.devのmodule分割](https://nix.dev/tutorials/module-system/deep-dive.html#splitting-modules)
この機構をそのまま使い、次の三層だけを設ける。

```text
inventory/
├── hosts.nix        # LocalHostName、platform、user、role
└── software.nix     # common、work、privateのアプリ集合
modules/
├── common/          # 全Macで同じsystemとHome Manager設定
├── roles/
│   ├── work.nix     # 仕事用だけの設定
│   └── private.nix  # 私用だけの設定
└── hosts/           # 実際に差がある場合だけ置くハードウェア設定
```

roleの条件を各ファイルへ `mkIf role == ...` として散らさず、ホスト構成を作る一か所でrole moduleを一つだけimportする。
roleを増やしたときに変更する場所が構成生成moduleへ集中し、両role moduleを誤って同時にimportした状態も検出しやすい。
アプリはrole moduleへ直接追加せず、software台帳だけを編集する。

## 推奨moduleのinterface

### Interface

利用者に見せるentry pointは `just switch` 一つとする。
maintainerがホストを追加するときに扱うinterfaceは、ホスト台帳の一件だけである。

```nix
{
  "private-mac" = {
    system = "aarch64-darwin";
    userName = "user";
    role = "private";
  };

  "work-mac" = {
    system = "aarch64-darwin";
    userName = "user";
    role = "work";
  };
}
```

構成名は実機の `scutil --get LocalHostName` と一致させる。
CPU architectureは `nixpkgs.hostPlatform` へ設定する。
nix-darwinは `nixpkgs.system` より `nixpkgs.hostPlatform` を使うほうがよいと明記している。[nix-darwin `nixpkgs.hostPlatform`](https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.hostPlatform)、[nix-darwin `nixpkgs.system`](https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.system)

### 不変条件とエラー

| 不変条件 | 検査位置 | 違反時の結果 |
|---|---|---|
| 一つのhostは一つのroleだけを持つ | ホスト台帳の型 | evaluation error |
| roleは `work` または `private` | `enum` または構成生成関数 | evaluation error |
| 構成名はLocalHostNameと一致する | `darwin-rebuild` の既定選択 | 該当するflake outputがなくbuild前に失敗 |
| work専用集合とprivate専用集合は重ならない | flake `checks` またはmodule assertion | check/build failure |
| host moduleはrole専用アプリを追加しない | directory責務とapp集合check | reviewまたはcheck failure |
| Homebrew管理項目はすべて宣言にある | activationのcleanup | 宣言外をuninstall |
| 平文secretをNix評価へ渡さない | repository policyとsecret module | reviewまたはsecret復号時に失敗 |

設定の矛盾を検出できる場合、NixOS module systemは `assertions` を使ってbuild前に明確なerrorを返すことを勧めている。[NixOS ManualのWarnings and Assertions](https://nixos.org/manual/nixos/stable/#sec-assertions)

最初のbootstrapではLocalHostNameを台帳へ合わせるか、明示的に `--flake .#<host>` を一度だけ指定する。
以後は構成側でも `networking.hostName` または `networking.localHostName` を固定し、名前が偶然変わらないようにする。
`networking.hostName` は `scutil --set HostName` に相当するnix-darwin optionである。[nix-darwin `networking.hostName`](https://nix-darwin.github.io/nix-darwin/manual/#opt-networking.hostName)

### 利用例

日常操作ではrole名もhostnameも渡さない。

```console
$ just switch
```

wrapperの責務はflakeの場所を固定し、次のcommandを呼ぶことに限定する。

```console
$ sudo darwin-rebuild switch --flake ./nix
```

Home Managerはnix-darwin moduleとして組み込む。
`home-manager.useGlobalPkgs = true` を使うとsystemとHome Managerが同じ `pkgs` を受け取り、余分なNixpkgs evaluationを減らしながら一貫性を保てる。[Home Managerのnix-darwin module](https://nix-community.github.io/home-manager/installation/nix-darwin.html)

### Seamの内側へ隠すimplementation

`mkDarwinHost` 相当のmodule factoryは次を隠す。

1. ホスト台帳のvalidation。
2. `nix-darwin.lib.darwinSystem` の呼び出し。
3. common module、選択されたrole module、一つのhost moduleの合成。
4. `nixpkgs.hostPlatform`、ユーザー、Home Managerの配線。
5. Homebrew activation policy。
6. 全ホスト分のflake `checks` の生成。

概略は次の形になる。

```nix
let
  hosts = import ./hosts;

  roleModules = {
    work = ./modules/roles/work.nix;
    private = ./modules/roles/private.nix;
  };

  mkDarwinHost = hostName: host:
    nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/common
        roleModules.${host.role}
        ./modules/hosts/${hostName}.nix
        {
          networking.hostName = hostName;
          nixpkgs.hostPlatform = host.system;
        }
      ];
      specialArgs = { inherit host hostName; };
    };
in {
  darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinHost hosts;
}
```

このsketchはinterfaceの形を示すためのものであり、ファイル名やoptionの細部まで決める実装案ではない。
利用者はfactory、role moduleのpath、Homebrew Bundleのflagを知らなくてもswitchできる。

## アプリを置く場所

### NixとHome Manager

CLI、language tool、設定を伴うprogramはNixpkgsとHome Managerを第一候補にする。
Home Managerはpackageだけでなくprogram設定、環境変数、home directory内のfileを再現可能な形で管理する。[Home Manager Introduction](https://nix-community.github.io/home-manager/introduction.html)

common moduleと選択されたrole moduleだけが `home.packages` やprogram optionへ値を足す。
switch時に既存の非管理fileと衝突した場合、Home Managerは変更前にactivationを止める。[Home Managerのcollision保護](https://nix-community.github.io/home-manager/usage/dotfiles.html)
自動で上書きする設定はこの保護を弱めるため、初回だけ既存fileを移すほうがよい。

### Homebrew formulaとcask

nix-darwinのHomebrew moduleは、`brews`、`casks`、`masApps` などからBrewfileを生成し、system activationでHomebrew Bundleへ渡す。[nix-darwin `homebrew.enable`](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.enable)
Homebrew BundleもBrewfileを「到達したい状態」を指定するdeclarative interfaceとして説明している。[Homebrew Bundle documentation](https://docs.brew.sh/Brew-Bundle-and-Brewfile)

排他性を求めるなら、`cleanup = "none"` のままでは足りない。
`cleanup = "uninstall"` は生成したBrewfileにないformulaとcaskを削除する。
移行初回だけ `cleanup = "check"` で宣言外の一覧を確認し、必要な項目を `common`、`work`、`private` のどれかへ移したあと `uninstall` へ切り替えると、意図しない削除を避けやすい。[nix-darwin cleanup options](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.onActivation.cleanup)

既定値として `zap` は勧めない。
Homebrewの `--zap` はcaskに関連する全fileを削除し、他のapplicationと共有しているfileも消す可能性がある。[Homebrew manpage](https://docs.brew.sh/Manpage.html#uninstall-remove-rm-options-installed_formula-installed_cask-)
アプリ本体を反対roleのMacから外す目的には `uninstall` で足りる。
設定やcacheも破棄したいcaskだけを確認してから、明示的にzapするほうが安全である。

Homebrewのdeclarative性はversion固定を意味しない。
Homebrewはrolling releaseであり、Homebrew Bundleはlock fileによる任意versionのpinを提供しない。[Homebrew BundleのVersions](https://docs.brew.sh/Brew-Bundle-and-Brewfile#versions)
`flake.lock` で固定できるNix packageと違い、Homebrewでは「どのappを入れるか」は宣言できても、fresh installで同じversionになるとは限らない。

### Mac App Store

nix-darwinの `homebrew.masApps` はinstallとupgradeを扱うが、App Storeへのsign-inを必要とし、optionから削除したappは `cleanup = "uninstall"` や `"zap"` でも削除しない。[nix-darwin `homebrew.masApps`](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.masApps)
したがって、`homebrew.masApps` だけではworkとprivateの排他性を保証できない。

現在のnix-darwinには、Mac App Storeアプリ専用の `programs.mas` moduleがある。
`programs.mas.cleanup = true` にすると、`programs.mas.packages` と `homebrew.masApps` のどちらにもないApp IDをinstall/update前に削除する。[nix-darwin `programs.mas.packages`](https://nix-darwin.github.io/nix-darwin/manual/#opt-programs.mas.packages)、[nix-darwin `programs.mas.cleanup`](https://nix-darwin.github.io/nix-darwin/manual/#opt-programs.mas.cleanup)

排他性を優先する構成では、Mac App Storeアプリの正本を `programs.mas.packages` へ一本化する。
ただし、cleanupにはHomebrewの `"check"` に相当する非破壊modeがない。
有効化する前に `mas list` で全アプリを棚卸しし、`common`、`work`、`private` のいずれかへ分類しなければならない。

`mas` はinstalled appの検出にSpotlightを使い、App Storeのdataにはeventual consistencyがあると公式READMEに記載している。[masのKnown IssuesとSpotlight](https://github.com/mas-cli/mas#known-issues)
MDMや別の利用者が管理するMac App Storeアプリを残す必要があるホストでは、`programs.mas.cleanup` を有効にせず、MASだけを非収束領域として明示する。

## 秘密情報とローカル値

role、hostname、platform、usernameは構成を評価して選ぶためのdataであり、secretではない。
これらはホスト台帳へcommitし、全構成をCIから評価できるようにする。
usernameやhostnameを公開repositoryへ置きたくないというprivacy要件がある場合はprivate repositoryへ移す判断が必要だが、平文secretの問題とは分ける。

token、password、private keyの平文はNix expressionへ入れない。
Nix storeはsystem上の全userが読めるため、Nix manualはsecretをstoreへ入れず、実行時にaccess control付きfileから読むか、暗号化したままstoreへ置いてactivation時に復号する方式を案内している。[Nix Reference Manual: Secrets](https://releases.nixos.org/nix/nix-2.33.1/manual/store/secrets.html)

secretが必要になった時点で、sops-nixのnix-darwin moduleを選択肢にできる。
sops-nixは暗号化fileをversion controlへ置き、activation時に復号するnix-darwin moduleを提供している。[sops-nix README](https://github.com/Mic92/sops-nix#flakes-current-recommendation)
ただし、仕事用と私用のアプリ集合を選ぶだけならsecret管理dependencyを増やす理由はない。

checkoutの絶対pathも構成selectorにしない。
追跡済みdotfileはflake sourceからHome Managerへ渡せるため、repositoryがどこへcheckoutされたかをmoduleへ知らせずに済む。
これによりGit管理外のadapterと `--impure` を削除し、同じflake outputをlocalとCIで評価できる。

## 依存戦略

このmoduleの外部seamは `just switch` とホスト台帳だけである。
依存は性質ごとに扱いを変える。

- Nix moduleのmergeとrole選択はpureなin-process dependencyである。
- Nixpkgs、nix-darwin、Home Managerはflake inputとして `flake.lock` でrevisionを固定する。
- HomebrewとMac App Storeは実機状態を変更するexternal dependencyであり、nix-darwinのHomebrew moduleをadapterとして使う。
- Mac App Storeは `programs.mas` をadapterとし、完全な台帳を作れるホストだけでcleanupを有効にする。

Homebrewを独自shell scriptで全面的に包み直さない。
nix-darwinがBrewfile生成、install、cleanup、upgrade policyをすでに一つのmoduleへ隠しているからである。
独自implementationは、公式moduleが扱えないMDMやvendor installerの監査に限定する。

## 全構成の検証

`nix flake check` が自動で特別扱いするoutputには `checks.<system>.<name>` と `nixosConfigurations` などが列挙されているが、`darwinConfigurations` は列挙されていない。[Nix Reference Manual: `nix flake check`](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake-check.html#evaluation-checks)
そのため、ホスト台帳を作っただけでは全Darwin構成を強制評価したことにならない。

各 `darwinConfigurations.<host>.system` を対応する `checks.<system>.<host>` から参照する。
nix-darwinの評価結果は `config.system.build.toplevel` を `.system` として公開し、`darwin-rebuild` もflake構成の `.system` をbuildしている。[nix-darwin `eval-config.nix`](https://github.com/nix-darwin/nix-darwin/blob/master/eval-config.nix#L77-L81)、[`darwin-rebuild.sh`](https://github.com/nix-darwin/nix-darwin/blob/master/pkgs/nix-tools/darwin-rebuild.sh#L182-L190)

検証は二段階にする。

1. `nix flake check --no-build --all-systems` で、全ホストのmodule evaluation、roleの型、assertion、package attribute参照を検査する。
2. 各architectureのDarwin runnerで `nix flake check` を実行し、そのplatformのsystem closureをbuildする。

ローカルでは、変更対象のホストを次でもbuildできる。

```console
$ darwin-rebuild build --flake .#private-mac
$ darwin-rebuild build --flake .#work-mac
```

buildはHomebrew activation scriptを生成するが、実機のHomebrewやMac App Storeを変更しない。
cask名の誤り、App Storeのsign-in、Spotlightの状態、cleanupの実結果は、各Macでのswitchをintegration testとして確認する必要がある。

app集合には別のpure checkを加える。
少なくとも `workApps ∩ privateApps = ∅`、roleが二値であること、全hostに対応するnamed configurationがあることを検査する。
「共通に置くべきappを両roleへ重複して書いた」状態をevaluationで止めれば、分類が時間とともに崩れるのを防げる。

## Trade-off

ホスト台帳方式では、新しいMacを使い始める前にLocalHostNameを決め、台帳へ一件追加しなければならない。
一方、毎日のswitchではrole名を選ばずに済み、間違った構成を指定する自由もinterfaceから消える。

`cleanup = "uninstall"` を使うと、Homebrewで試しに入れたpackageも次のswitchで消える。
これは排他性を得るための意図した制約である。
実験中のpackageを残したいなら、宣言へ追加するか、switch時に消える一時状態として扱う。

同じ一台を仕事用と私用へ頻繁に切り替える用途には、この設計は向かない。
現在の要件は物理的に別のMacへ異なる集合を適用することであり、ホストとroleを一対一に固定するほうが安全だからだ。
将来一台で両環境を同時に隔離する必要が出た場合は、別のmacOS user、VM、会社のMDMなどを評価し直す必要がある。

Mac App Storeは `programs.mas.cleanup` で削除まで収束できるが、全未宣言アプリを対象にする。
そのため、全App IDを台帳へ移せる個人所有Macでは有効にし、MDMなど別の管理主体が存在するMacでは無効にする判断が必要になる。

この構成では、日々の判断は残らない。
プライベート用Macで `just switch` を実行すればprivate roleだけが選ばれ、仕事用Macで同じcommandを実行すればwork roleだけが選ばれる。
