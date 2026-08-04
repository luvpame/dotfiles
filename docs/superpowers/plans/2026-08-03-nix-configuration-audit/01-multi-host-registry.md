# T01 ホストから仕事用と私用の構成を一意に選ぶ

- Status: 未着手
- Audit IDs: `FLAKE-03`, `FLAKE-07`, `SYS-07`, `SYS-14`, `BREW-03`
- 原典: [Nix構成棚卸し](../../../research/nix-configuration-audit-2026-07-31.md)
- 調査結果: [仕事用Macとプライベート用Macの構成を分離する設計](../../../research/nix-darwin-work-private-configuration-2026-08-04.md)
- 依存先: `T06 設定ファイルの所有境界を整理する`、`T23 Herdrのruntime stateをrepoから分離する`、`T24 Hunkのruntime stateをrepoから分離する`

## Goal

各Macの`LocalHostName`から、そのホストに許されたroleとアプリ集合を一意に決める。

プライベート用Macへ仕事専用アプリが入り、仕事用Macへ私用専用アプリが入る事故を、運用上の注意ではなく構成のinterfaceで防ぐ。
日常操作は、role名や構成名を引数に取らない`just switch`へ統一する。

このタスクを完了した時点では、次の状態が成り立つ。

```text
desiredSoftware(host) = commonSoftware ∪ roleSoftware(host.role)
```

`work`と`private`の専用集合は重ならない。
両方で使う項目は`common`へ置く。
ホスト固有moduleにはハードウェア差だけを置き、アプリの例外を追加しない。

## この計画で変更する判断

2026-08-04の調査結果を優先し、以前の棚卸しで維持するとした次の判断を撤回する。

- `SYS-07`の「host identityをNixから宣言しない」は撤回し、`networking.localHostName`をホスト台帳から設定する。
- `BREW-03`の`cleanup = "zap"`維持は撤回し、移行中は`"check"`、収束後は`"uninstall"`を使う。
- `programs.mas.cleanup`の一律禁止は撤回し、Mac App Storeを完全に管理できるホストだけで有効にする。

`autoUpdate = true`と`upgrade = true`は、このタスクでは変更しない。
Homebrew Caskの更新主体はT07で決める。

## 対象外

このタスクは、MDM、会社の管理ツール、vendor installerが所有するアプリを削除しない。
それらの管理主体がnix-darwinではないためである。

過去のNix generationやNix storeに残るpackageも削除対象に含めない。
新しいgenerationの利用環境から外れていれば、role分離の完了条件を満たす。

同じ一台のMacを仕事用と私用へ切り替える構成は作らない。
将来その要件が生じた場合は、別のmacOS user、VM、MDMを改めて評価する。

## Architecture

### 利用者が触るinterface

日常操作は二つだけにする。

```console
$ just build
$ just switch
```

どちらもrole名とhostnameを受け取らない。
`darwin-rebuild`へ`#構成名`を渡さず、実機の`LocalHostName`と同名の`darwinConfigurations`を選ばせる。

新しいMacを追加するときだけホスト台帳へ一件追加する。
新しいMacの`LocalHostName`は、最初のswitchより前に台帳のkeyと一致させる。

### tracked inventory

```text
nix/
├── inventory/
│   ├── hosts.nix
│   └── software.nix
├── lib/
│   └── mk-darwin-hosts.nix
└── nix-darwin/
    ├── default.nix
    ├── roles/
    │   ├── private.nix
    │   └── work.nix
    └── hosts/
        └── <LocalHostName>.nix
```

`hosts.nix`のkeyは、各Macで`scutil --get LocalHostName`が返す値と一致させる。
値には、構成生成に必要な非秘密のmetadataだけを置く。

```nix
{
  "private-mac" = {
    system = "aarch64-darwin";
    userName = "user";
    role = "private";
    masCleanup = true;
  };

  "work-mac" = {
    system = "aarch64-darwin";
    userName = "user";
    role = "work";
    masCleanup = false;
  };
}
```

`homeDirectory`は、全ホストが標準形を使うと確認できた場合に`/Users/${userName}`から導く。
実際に非標準のhomeがある場合だけ、ホスト台帳へ`homeDirectory`を追加する。
存在しない差異を想定したoptionは作らない。

`masCleanup`はアプリの例外ではなく、Mac App Store全体をnix-darwinが所有できるかを表す。
MDMなど別の管理主体があるホストでは`false`にする。

### software inventory

`software.nix`は`common`、`work`、`private`の三つのscopeを持つ。
各scopeのschemaは同じにする。

```nix
{
  common = {
    nixPackages = { inputs, pkgs }: [ ];
    brews = [ ];
    taps = [ ];
    casks = [ ];
    masApps = { };
  };

  work = { /* 同じschema */ };
  private = { /* 同じschema */ };
}
```

独自の汎用package DSLは作らない。
`nixPackages`だけを関数にするのは、Nixpkgsとflake inputのpackageを同じ台帳で組み立てるためである。

`mk-darwin-hosts.nix`は、次のinterfaceだけを公開する。

```nix
import ./lib/mk-darwin-hosts.nix {
  inherit inputs hosts software;
}
```

戻り値は`darwinConfigurations`と`checks`にする。
ホストの検査、roleの選択、moduleの合成、softwareの正規化、全ホストのcheck生成は、このmoduleの内側へ隠す。

### moduleの責務

- `nix-darwin/default.nix`は、全Macで共通のsystem、Homebrew、Home Manager moduleだけをimportする。
- `nix-darwin/roles/work.nix`と`private.nix`は、AeroSpaceやCodexなどrole固有の設定だけをimportする。
- `nix-darwin/hosts/<LocalHostName>.nix`は、実際に差があるハードウェア設定だけを持つ。
- アプリを追加する場所は`inventory/software.nix`だけにする。

roleの条件を複数moduleへ`lib.mkIf`として散らさない。
`mk-darwin-hosts.nix`が選択したrole moduleを一つだけimportする。

### 不変条件

評価時に次を検査する。

| 条件 | 識別子の扱い | 違反時の結果 |
|---|---|---|
| roleは`work`または`private` | 文字列 | evaluation error |
| 一つのhostは一つのroleを持つ | host属性 | evaluation error |
| workとprivateの専用項目は重ならない | installerごとに正規化 | evaluation error |
| commonとrole専用項目は重ならない | installerごとに正規化 | evaluation error |
| 全hostにnamed configurationがある | host key | flake check failure |
| 全hostのsystem closureを参照できる | `checks.<system>.<host>` | flake check failure |

HomebrewのformulaやCaskが属性setの場合は`name`を比較する。
Mac App Storeアプリは表示名ではなくApp IDを比較する。
Nix packageは`lib.getName`で比較する。

## 実装前に集める情報

`nix/local.nix`は読まない。
各Mac上で次のcommandを直接実行し、ホスト台帳へ記録してよい非秘密値だけを集める。

```console
$ scutil --get LocalHostName
$ id -un
$ uname -m
$ dscl . -read "/Users/$(id -un)" NFSHomeDirectory
```

各Macについて、仕事用か私用か、Mac App StoreアプリをMDMなどが管理しているかも確認する。
次の表が埋まるまでは`hosts.nix`を作らない。

| LocalHostName | role | system | userName | home | MASを完全管理できるか |
|---|---|---|---|---|---|
| 未収集 | workまたはprivate | 未収集 | 未収集 | 未収集 | yesまたはno |

## 対象ファイル

### 新規作成

- `nix/inventory/hosts.nix`
- `nix/inventory/software.nix`
- `nix/lib/mk-darwin-hosts.nix`
- `nix/nix-darwin/roles/work.nix`
- `nix/nix-darwin/roles/private.nix`
- `nix/nix-darwin/hosts/<LocalHostName>.nix`（実際にホスト差がある場合だけ）

### 変更

- `nix/flake.nix`
- `nix/nix-darwin/default.nix`
- `nix/nix-darwin/nix-core.nix`
- `nix/nix-darwin/system.nix`
- `nix/nix-darwin/users.nix`
- `nix/nix-darwin/homebrew/common.nix`
- `nix/nix-darwin/home-manager/default.nix`
- `nix/nix-darwin/home-manager/files/common.nix`
- `nix/nix-darwin/home-manager/files/work.nix`
- `nix/nix-darwin/home-manager/files/private.nix`
- `justfile`
- `AGENTS.md`
- `nix/AGENTS.md`
- このディレクトリの`README.md`と、T01に反する関連計画

### 削除

- `nix/local.nix.example`
- `nix/nix-darwin/homebrew/work.nix`
- `nix/nix-darwin/homebrew/private.nix`
- `nix/nix-darwin/home-manager/packages/common.nix`
- `nix/nix-darwin/home-manager/packages/work.nix`
- `nix/nix-darwin/home-manager/packages/private.nix`

非追跡の`nix/local.nix`は、参照をなくしても自動では削除しない。
両ホストの移行後に、利用者が不要と確認してから手元で削除できる。

## 実施手順

### 1. 作業前の状態を固定する

- [ ] `git status --short`と`git diff --name-only`を記録する。
- [ ] 既存の`config/codex/work/config.toml`、`config/nvim/lazy-lock.json`、`nix/flake.lock`、`nix/nix-darwin/nix-core.nix`の変更を本タスクへ混ぜない。
- [ ] `nix/local.nix`を開かず、diff、log、command出力にも含めない。
- [ ] T06、T23、T24を完了し、HerdrとHunkのruntime stateがrepo外へ移ったことを確認する。
- [ ] 仕事用と私用の両Macについて、前節のホスト情報を収集する。

### 2. Git flakeを入力の正本にする

- [ ] `justfile`と手動検証のflake参照を`path:.`から`.`へ変更する。
- [ ] `nix/`で`.`を評価すると、Git repository rootをsource、`nix`をflake directoryとして解決することを`nix flake metadata .`で確認する。
- [ ] Git管理外の`nix/local.nix`がflake sourceへ入らないことを確認する。
- [ ] 新規ファイルを検証するときは対象ファイルだけを一時的にGit indexへ追加し、既存のstaged状態を変えない。

この変更により、`nix/flake.nix`から追跡済みの`../config`をstore-backed sourceとして参照できる。
同時に、明示的な`path:.`が非追跡ファイルまで入力へ含める経路を閉じる。

### 3. ホスト台帳と構成生成moduleを追加する

- [ ] 収集済みの値だけで`inventory/hosts.nix`を作る。
- [ ] `mk-darwin-hosts.nix`でhost roleと必須属性を検査する。
- [ ] hostごとに`nix-darwin.lib.darwinSystem`を呼び、`darwinConfigurations.<LocalHostName>`を生成する。
- [ ] `nixpkgs.hostPlatform = host.system`をmodule側へ設定し、`darwinSystem.system`を削除する。
- [ ] `networking.localHostName = hostName`を設定する。
- [ ] `host`、`hostName`、`software`、`inputs`を`specialArgs`へ渡す。
- [ ] 実在するホスト差がある場合だけ`nix-darwin/hosts/<LocalHostName>.nix`をimportする。
- [ ] 互換用の`darwinConfigurations.work`や`private`は作らない。

### 4. アプリの正本をsoftware inventoryへ移す

- [ ] 現在のNix package、formula、tap、Cask、Mac App Store App IDを削除せず`software.nix`へ移す。
- [ ] 各項目を`common`、`work`、`private`のどれか一つへ分類する。
- [ ] 同じ項目が複数scopeにあれば、両方で必要な項目は`common`へ移す。
- [ ] `mk-darwin-hosts.nix`でscope間の重複を正規化して検出する。
- [ ] Home Managerのpackage adapterは`common`と選択roleの`nixPackages`だけを`home.packages`へ渡す。
- [ ] Homebrew adapterは同じ二scopeの`brews`、`taps`、`casks`だけを設定する。
- [ ] role moduleにはrole固有の設定fileだけを残す。
- [ ] 移行元のprofile別packageとHomebrewファイルを削除する。

この段階ではアプリの集合だけを移し、Homebrew cleanupを強めない。

### 5. `local`引数とout-of-store pathを除去する

- [ ] `local.userName`を`host.userName`へ置き換える。
- [ ] 標準homeだけなら`homeDirectory`を`/Users/${host.userName}`から導き、冗長な`users.users.<name>.name`を削除する。
- [ ] `system.primaryUser`とHomebrew activationの実行userを`host.userName`から設定する。
- [ ] Home Managerの追跡済み設定fileを`../config`以下のstore-backed sourceへ切り替える。
- [ ] T23とT24で分離したHerdr、Hunkのruntime directoryへ、管理対象fileだけを配置する。
- [ ] `flake.nix`から`local.nix`のimport、fallback、profile検査を削除する。
- [ ] `dotfilesRoot`、`darwinConfigName`、`profile`というローカルselectorがNix module graphに残っていないことを確認する。
- [ ] `nix/local.nix.example`を削除する。
- [ ] `AGENTS.md`と`nix/AGENTS.md`をホスト台帳とGit flakeの運用へ更新する。

### 6. 全ホストをflake checkへ接続する

- [ ] `darwinConfigurations.<host>.system`を`checks.<system>.<host>`から参照する。
- [ ] software scopeの重複検査を、全ホストをbuildしなくても評価できるcheckまたはassertionにする。
- [ ] host台帳の全keyと`darwinConfigurations`の全keyが一致することを検査する。
- [ ] `just check`を`nix flake check . --all-systems`へ変更する。
- [ ] `just build`と`just switch`から`-H`および`darwinConfigName`の評価を削除する。
- [ ] `just build`は`darwin-rebuild build --flake .`、`just switch`は`sudo darwin-rebuild switch --flake .`を呼ぶ。

### 7. Homebrewを非破壊modeで棚卸しする

- [ ] `homebrew.onActivation.cleanup`を`"zap"`から`"check"`へ変更する。
- [ ] `extraFlags = [ "--force-cleanup" ]`を削除する。
- [ ] 各Macで`brew list --formula`、`brew list --cask`、`brew tap`を保存する。
- [ ] 各Macで`just build`を成功させる。
- [ ] 利用者が明示した場合だけ`just switch`を実行し、cleanup checkが報告する宣言外項目を記録する。
- [ ] 宣言外項目を`common`、対応role、別管理、削除候補へ分類する。
- [ ] 残す項目を`software.nix`へ追加し、`cleanup = "check"`で差分がなくなるまで繰り返す。

`"check"`が宣言外項目を理由にactivationを止めることは、安全側の失敗として扱う。
この段階では`brew uninstall`や`brew bundle cleanup --force`を手動実行しない。

### 8. Homebrewを削除まで収束させる

- [ ] 両Macでcleanup checkの差分が空になったことを確認する。
- [ ] `homebrew.onActivation.cleanup = "uninstall"`へ変更する。
- [ ] `"zap"`と`--force-cleanup`がNix設定と関連計画に残っていないことを確認する。
- [ ] 一台ずつ`just switch`を実行し、反対roleのformulaとCaskが消えることを確認する。
- [ ] アプリの設定、cache、共有データが残っていても、自動でzapしない。

### 9. Mac App Storeの所有範囲を決める

- [ ] 各Macで`mas list`を実行し、App IDを保存する。
- [ ] `homebrew.masApps`の項目を`software.nix`の`masApps`へ移す。
- [ ] `programs.mas.enable = true`を設定する。
- [ ] `programs.mas.packages`へ`common`と選択roleの集合を設定する。
- [ ] 最初の適用では全ホストの`programs.mas.cleanup`を`false`にする。
- [ ] installとupdateが正常に動き、必要なApp IDが台帳に揃っていることを確認する。
- [ ] MDMなど別の管理主体がないホストだけ`host.masCleanup`を`true`にする。
- [ ] `masCleanup = true`のホストでは、利用者が削除対象を確認してから一台ずつswitchする。
- [ ] `masCleanup = false`のホストでは、MASアプリが完全には収束しないことをホスト台帳の近くへ記録する。

### 10. role分離を実機で確認する

- [ ] 適用前に各MacのNix package、Homebrew formula、Cask、MAS App IDを記録する。
- [ ] privateホストをbuildし、work専用項目が構成へ入らないことを確認する。
- [ ] workホストをbuildし、private専用項目が構成へ入らないことを確認する。
- [ ] 一台目へswitchし、shell、Home Manager file、代表的なGUIアプリを確認する。
- [ ] 一台目が安定してから二台目へswitchする。
- [ ] 両Macで`scutil --get LocalHostName`と選択されたconfiguration名が一致することを確認する。
- [ ] `just switch`以外のrole選択手順が運用文書に残っていないことを確認する。

## 検証コマンドと期待結果

### 静的検査

```console
$ rg -n 'local\.|local\.nix|dotfilesRoot|darwinConfigName|profile' nix justfile AGENTS.md --glob '!flake.lock'
```

期待結果は、移行済みの説明または削除確認以外に旧selectorの参照がないことである。

```console
$ rg -n 'cleanup = "zap"|--force-cleanup|homebrew\.masApps' nix docs/superpowers/plans/2026-08-03-nix-configuration-audit
```

期待結果は、現行設定として有効な参照がないことである。

```console
$ nixfmt --check <変更したNixファイル...>
$ git diff --check
```

期待結果は、すべて終了コード0で完了することである。

### flake評価

```console
$ cd nix
$ nix flake metadata .
$ nix eval '.#darwinConfigurations' --apply builtins.attrNames --json
$ nix flake check . --no-build --all-systems
```

期待結果は、Git flakeが`dir=nix`として解決され、ホスト台帳と同じ構成名が出力され、全ホストのevaluationが成功することである。

各ホストを明示してbuildする。

```console
$ darwin-rebuild build --flake '.#<private-host>'
$ darwin-rebuild build --flake '.#<work-host>'
```

期待結果は、両構成のsystem closureをbuildできることである。

最後に、実機の自動選択を適用なしで確認する。

```console
$ just build
```

期待結果は、現在の`LocalHostName`と同名の構成を選び、role引数なしでbuildできることである。

### 適用後の検査

`just switch`は、build結果と削除候補を利用者が確認して明示的に許可した場合だけ実行する。

```console
$ scutil --get LocalHostName
$ brew list --formula
$ brew list --cask
$ mas list
```

privateホストではwork専用項目がなく、workホストではprivate専用項目がないことを確認する。
`masCleanup = false`のホストでは、MASだけをこの判定から除外する。

## 完了条件

- Git管理するホスト台帳だけを読めば、各Macとroleの対応が分かる。
- `darwinConfigurations`のkeyが各Macの`LocalHostName`と一致する。
- 日常の`just build`と`just switch`がrole名とhostnameを受け取らない。
- `nix/local.nix`、`dotfilesRoot`、`darwinConfigName`をflake評価が参照しない。
- アプリの正本が`software.nix`一か所にあり、scope間の重複を評価時に拒否する。
- `nixpkgs.hostPlatform`がhost metadataから設定され、`darwinSystem.system`が残っていない。
- Homebrewは`cleanup = "uninstall"`で宣言外のformulaとCaskを削除する。
- `cleanup = "zap"`を通常運用に使っていない。
- MAS cleanupを有効にしたホストでは、宣言外のMac App Storeアプリがない。
- MAS cleanupを無効にしたホストでは、非収束である理由が記録されている。
- 全ホストのevaluationとbuildが成功している。
- privateホストとworkホストの実機確認が成功している。

## ロールバック

コードのロールバックと実機のロールバックを分ける。

構成生成に失敗した場合は、host registryとfactoryの差分だけを戻し、直前のknown-good generationを変更しない。
`nix/local.nix`は自動削除しないため、移行中の比較資料として手元に残る。

Homebrewの`cleanup = "check"`で止まった場合は、削除を実行せずsoftware inventoryを補う。
`"uninstall"`適用後に必要なアプリが消えた場合は、その項目を正しいscopeへ追加してswitchし直す。
設定やデータまで消す`"zap"`を使わないため、再installで復旧できる範囲を保つ。

MAS cleanupで必要なアプリが消えた場合は、App IDを正しいscopeへ追加し、App Storeへsign inした状態で再適用する。
MDM所有アプリへ影響した場合は、そのホストの`masCleanup`を`false`へ戻し、MDMを正とする。

system全体に問題が出た場合は、既知の正常なdarwin generationへ戻す。
二台へ同時適用しないため、未適用のMacを復旧手順と設定比較に使える。

## 実装時の規約

- コードを変更した後は`code-simplifier`スキルを適用する。
- Nix変更は`nixfmt --check`、`nix flake check`、両ホストの`darwin-rebuild build`で検証する。
- Hunkのdotfilesセッションが開いている場合は、最終差分を同セッションへreloadして確認する。
- `just switch`、Homebrewの削除、MAS cleanupは、利用者が対象を確認して明示した場合だけ実行する。
- 非追跡の`nix/local.nix`を読まず、削除せず、追跡しない。
- Git commitは、利用者から明示的に依頼された場合だけ行う。
