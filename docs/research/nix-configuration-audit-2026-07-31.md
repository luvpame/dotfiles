# Nix 構成棚卸しレポート

- 調査日: 2026-07-31
- 対象: `nix/` 全体、関連する Home Manager 配備先、Homebrew 宣言、macOS defaults、関連 shell 設定
- 基準: 固定中の `flake.lock`、実効 Nix 設定、公式ドキュメント、一次ソース、公式 API
- 変更方針: この調査では設定を変更せず、判断候補だけを列挙する

## 結論

現在の構成は、Nix Flake、nix-darwin、Home Manager、Homebrew の責務分割が概ね明確で、全面的な再設計は不要である。
一方、過去の不具合回避が残った箇所、Homebrew の強い cleanup 方針、実行時 state を dotfiles へ書き戻すリンク、macOS で既定無効の sandbox と firewall には、優先して判断すべき余地がある。

最初に採用しやすいのは、挙動をほぼ変えない次の整理である。

- `CORE-06`: 既定値と同じ `nix.package` と `keep-derivations` の明示を整理する。
- `TEMP-01`: 解消済みの documentation workaround を外す。
- `TEMP-03`: 通常 derivation を公式 cache から取得できた `direnv` と `statix` の test 無効化を外す。
- `PKG-02`: 通常 derivation の build/取得を確認できた `rtk` の test 無効化を外す。
- `PKG-01`: 独自 Tree-sitter 0.26.8 を固定 nixpkgs の 0.26.9 へ置き換える。
- `PKG-03`: site2skill を安定版 0.1.1 へ更新する。
- `FILE-04`、`FILE-05`: 重複 Zsh link と Tirith の残骸を削除する。
- `BREW-02`: 自動付加される `--force-cleanup` の重複指定を削除する。
- `BREW-06`: repo 内参照がない `roots` は削除有力だが、ad-hoc 利用を本人確認する。
- `BREW-07`: 不要になった Homebrew 版 ripgrep を外す。

先に方針を決めるべきなのは次の項目である。

- `BREW-01`: 廃止済み `codex-app` は削除候補だが、現在の `zap` で関連データを消さない移行手順が必要である。
- `BREW-03`: `switch` を更新・破壊的同期まで行う操作にするか、switch 中の外部変更を抑えるかを決める。
- `HM-01`: `home.stateVersion` の来歴を確認し、最新値へ機械的に上げない。
- `CORE-01`、`CORE-02`: sandbox と `trusted-users` の安全性を上げるが、ローカル build と flake cache 利用を先に確認する。
- `FILE-02`、`FILE-03`: Herdr/Hunk の runtime state を repo から分離する。
- `SYS-03`: Application Firewall を有効にするか選ぶ。
- `SYS-05`: `ignoreArd` は現在の書き方で実際に効くかを先に検証し、確認後維持、削除、別方式での実装から選ぶ。

## 判断方法

各項目には安定した ID を付けた。
回答時は、たとえば `採用: CORE-01, TEMP-01, PKG-01 / 保留: BREW-01 / 見送り: HM-04` のように指定できる。
選択肢や複数 package を束ねた ID は、`BREW-03:B`、`BREW-08:nix-cli+programs-mas`、`PKG-07:B`、`SYS-01:bottom`、`PKG-09:openssl_3削除` のように suffix まで指定する。

優先度は次の意味で使う。

- **高**: security、データ消失、明確な残骸、現在の挙動を既に損なう問題に関わる。
- **中**: 保守性、再現性、更新運用を改善するが、方針選択や移行確認が要る。
- **低**: 好み、将来対応、lint、軽微な簡素化である。

確度は「事実関係」と「その変更を採用すべきか」を分けて評価した。
事実の確度が高くても、利用実態を repo だけから確定できない項目は判断確度を中以下にしている。

## 調査時点の基線

- 実効 Nix は 2.34.8 である。
- Nix の公式ページでは 2.35.2 が最新リリースだが、Nixpkgs/NixOS 26.05 と rolling release が供給する系列は 2.34 であるため、実効値の判断には主に 2.34 の仕様を使った。[Nix reference manual](https://nix.dev/manual/nix)
- 実効値は `sandbox=false`、`max-jobs=8`、`keep-outputs=true`、`keep-derivations=true`、`min-free=0`、`max-free=infinity` である。
- `require-sigs=true`、`accept-flake-config=false` で、公式 cache と Claude 用 cache の 2 substituter、対応する 2 公開鍵が設定されている。
- user channel は空であるが、nix-darwin の `nix.channel.enable` は既定の `true` である。
- `nix flake check path:./nix --no-build` は `darwinConfigurations` を含めて正常に評価した。
- `deadnix nix` は `self`、`pkgs`、overlay の `final`、Homebrew の `lib`、private package file の `inputs` を未使用として検出した。
- `statix check nix` は flake の `or`/`inherit`、Home Manager の反復 `home.*` 属性などを警告した。
- `nix/local.nix` の値は本書に掲載しない。

## 判断用短縮リスト

この表は、優先度が高い項目、データ保護/security に関わる項目、結論で最初の batch に挙げた leaf cleanup だけを抜粋したものである。
全候補は後続の詳細と「全判断 ID の既定提案」を正とする。

| ID | 優先度 | 推奨判断 | 主なリスクまたは確認点 |
| --- | --- | --- | --- |
| `CORE-01` | 高 | `sandbox = "relaxed"` を試験導入 | `__noChroot` 依存を許す代わりに strict より弱い |
| `CORE-02` | 高 | 通常ユーザーを `trusted-users` から外す | user が任意 cache を使う workflow の確認 |
| `CORE-03` | 中〜高 | unfree を `7zz`/Claude 等へ限定 | Claude の供給元を先に決める |
| `CORE-04` | 中 | flakes-only なら channel を無効化 | legacy `<nixpkgs>` 利用の確認 |
| `CORE-05` | 中 | 週次 GC と空き容量閾値を追加 | 古い generation/cache の保持期間を決める |
| `FLAKE-01` | 中 | macOS 向け `nixpkgs-unstable` へ変更 | lock 更新と全 package 回帰試験 |
| `FLAKE-03` | 中 | `nixpkgs.hostPlatform` へ移行 | flake 評価と full build |
| `TEMP-01` | 高 | documentation を既定の有効へ戻す | closure が少し増える |
| `TEMP-02` | 中〜高 | darwin-uninstaller を有効へ戻す | recovery utility が増えるだけ |
| `TEMP-03` | 高 | direnv/statix の override を解除 | cache miss 時に test が戻る |
| `TEMP-04` | 中〜高 | mise は専用再検証まで維持 | comment の version は更新する |
| `HM-01` | 高 | stateVersion の来歴確認 | 最新値への追従は禁止 |
| `HM-02` | 高 | 独自 app link を `copyApps` へ置換 | 初回権限、容量、旧 link cleanup |
| `FILE-02` | 高 | Herdr は `config.toml` だけ管理 | state を保持して directory 移行 |
| `FILE-03` | 中 | Hunk は `config.toml` だけ管理 | notice state が端末別になる |
| `FILE-04` | 高 | 重複 Zsh directory link を削除 | 実効 `ZDOTDIR` を最終確認 |
| `FILE-05` | 高 | Tirith の hook/文書残骸を削除 | 外部導入していないことを確認 |
| `SHELL-01` | 高 | Fish login shell を nix-darwin 管理へ | recovery shell を確認 |
| `SHELL-02` | 高 | direnv を nix-darwin module へ統合 | Fish/Zsh hook 順が変わる |
| `PKG-01` | 高 | custom Tree-sitter を削除 | CLI の smoke test |
| `PKG-02` | 高 | RTK test override を削除 | 通常 derivation は確認済み |
| `PKG-03` | 高 | site2skill 0.1.1 へ更新 | beta 0.2.0b2 は別判断 |
| `BREW-01` | 高 | 移行後に `codex-app` を削除 | `zap` による関連データ消失 |
| `BREW-02` | 高 | 重複 `--force-cleanup` を削除 | 挙動変化なし |
| `BREW-03` | 高 | activation 方針を安全側へ再選択 | update/upgrade/cleanup の運用変更 |
| `BREW-04` | 高 | tap trust を item 単位へ縮小 | 完全修飾名の検証 |
| `BREW-05` | 高 | `im-select` を hash 固定する | 現在は mutable master を取得 |
| `BREW-06` | 高 | repo 外利用を確認後 `roots` を削除 | ad-hoc CLI 利用の確認 |
| `BREW-07` | 高 | Homebrew 版 ripgrep を削除 | Nix 版へ供給元が変わる |
| `SYS-03` | 高 | Application Firewall を有効化 | LAN/dev server/container の許可確認 |
| `SYS-04` | 中〜高 | 即時 password 要求を宣言 | 離席後すぐ再認証になる |
| `SYS-05` | 高 | `ignoreArd` の効力と必要性を確認 | defaults と profile で domain/key の表記・適用方式が異なる |
| `SYS-15` | 中〜高 | `spans-displays` を AeroSpace 方針で選ぶ | `true` への変更は logout が必要 |

## Nix daemon と store

### `CORE-01` — sandbox を `relaxed` で有効化する

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:38-53` に現在宣言がなく、Darwin 既定の `false` が有効である。
- **推奨**: 最初は `nix.settings.sandbox = "relaxed";` とし、通常 derivation を sandbox 化する。
- **根拠**: sandbox は未宣言の host file 依存を防ぐが、macOS の既定は無効である。
  `relaxed` は fixed-output derivation と `__noChroot=true` の derivation だけを sandbox 外へ出すため、strict `true` より既存 package との互換性を保ちやすい。[Nix 2.34 `sandbox`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-sandbox)
- **副作用**: 現在たまたま host tool/file に依存する source build が失敗し、隠れた不純性が表面化する。
  十分な試験後に strict `true` へ進める余地はあるが、最初からの採用は勧めない。

### `CORE-02` — 通常ユーザーを `trusted-users` から外す

- **カテゴリ**: security 改善。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:43-46`。
- **推奨**: system 側で substituter と公開鍵を宣言している現構成で足りるなら、通常ユーザーを除外する。
  `root` は既定に含まれるため、明示自体も整理できる。
- **根拠**: Nix は trusted user が daemon へ任意 substituter や署名要件を緩めた path を渡せるため、「実質的に root access」と明記している。[Nix 2.34 `trusted-users`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-trusted-users)
- **副作用**: user が CLI から未知の cache を一時追加する workflow や、信頼済み user を要求する分散 builder は失敗し得る。

### `CORE-03` — `allowUnfree = true` を package 単位へ絞る

- **カテゴリ**: security / policy 改善。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:9-10`。
- **推奨**: `nixpkgs.config.allowUnfreePackages` へ移し、現在必要な `7zz` と Claude の供給元だけを許可する。
- **根拠**: 現行 Nixpkgs は additive に merge でき、全 unfree package を許可しない `allowUnfreePackages` を提供している。[Nixpkgs manual](https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference)
- **副作用**: unfree package を将来追加するたび、名前を明示する必要がある。
  Claude を flake package から直接使うか、nixpkgs 版へ戻すかで必要な allowlist が変わるため、`PKG-07` と同時に決める。

### `CORE-04` — flakes-only なら channel を無効化する

- **カテゴリ**: 削除 / 警告解消候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: 現在未宣言で `nix.channel.enable = true` が有効である。
- **推奨**: `nix.channel.enable = false;` を追加する。
- **根拠**: user channel は空であり、評価時に root channel path 不在警告が出る。
  nix-darwin はこの option を無効にすると `nix-channel` と channel state file を作らない。[nix-darwin options](https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.channel.enable)
- **副作用**: legacy の `<nixpkgs>` lookup や `nix-channel` を使う script があれば動かなくなる。
  Flake registry は別機構であり、nix-darwin が root nixpkgs input へ自動 pin する既定は維持できる。[nix-darwin `nixpkgs.flake`](https://nix-darwin.github.io/nix-darwin/manual/#opt-nixpkgs.flake.setFlakeRegistry)

### `CORE-05` — GC と disk-pressure 閾値を追加する

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `justfile:28-30` に手動 `nh clean` だけがあり、実効 `min-free=0` である。
- **推奨**: まず週次 `nix.gc.automatic = true` を採用し、保持期間は `--delete-older-than 30d` など明示的に選ぶ。
  加えて、disk 容量に合わせて `min-free` と `max-free` の保守的な閾値を決める。
- **根拠**: nix-darwin の GC は既定で日曜 03:15 に実行でき、Nix は空き容量が `min-free` を下回ると GC を開始し `max-free` まで回復させる。[nix-darwin GC options](https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.gc.automatic) [Nix `min-free`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-min-free)
- **副作用**: 古い generation と未使用 cache を消すため、rollback や offline rebuild の余裕が減る。
  `just clean` の 4 日/3 generation と自動 GC の二重 policy は一本化する。

### `CORE-06` — 既定値と重複する明示設定を整理する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:36,42`。
- **推奨**: `nix.package = pkgs.nix;` と `keep-derivations = true;` を削除する。
- **根拠**: nix-darwin の `nix.package` 既定は `pkgs.nix` で、Nix 2.34 の `keep-derivations` 既定は `true` である。[nix-darwin `nix.package`](https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.package) [Nix `keep-derivations`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-keep-derivations)
- **副作用**: 現在はない。
  明示を policy documentation として残す選択も可能だが、既定変更への追従を止める意味を持つ。

### `CORE-07` — `keep-outputs` の必要性を確認する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:41`。
- **推奨**: build-time dependency の output を GC 後も保持する明確な offline/debug 要件がなければ削除する。
- **根拠**: `keep-outputs` は非既定であり、derivation が生きている限りその output も live とみなすため、GC の回収効率を落とす。[Nix `keep-outputs`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-keep-outputs)
- **副作用**: 削除後は cache miss 時の再 build が増え得る。

### `CORE-08` — `max-jobs = 8` を `auto` と比較する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:40`。
- **推奨**: 固定 8 に熱・メモリ・interactive latency の実測理由がなければ、宣言を外して nix-darwin 既定の `auto` を使う。
- **根拠**: `max-jobs` は同時 derivation 数で、各 derivation 内部の CPU 数を制御する `cores` とは別である。[nix-darwin `max-jobs`](https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.settings.max-jobs) [Nix `max-jobs`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-max-jobs)
- **副作用**: CPU 数が 8 を超える host では負荷・メモリ消費が増え得る。

### `CORE-09` — scheduled optimise を維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/nix-core.nix:37`。
- **判断**: `nix.optimise.automatic = true` を維持し、`auto-optimise-store` は追加しない。
- **根拠**: nix-darwin は既定で日曜 04:15 の store optimize を設定でき、build ごとの optimize より I/O をまとめられる。[nix-darwin optimise options](https://nix-darwin.github.io/nix-darwin/manual/#opt-nix.optimise.automatic)

### `CORE-10` — cache の署名検証と明示 cache を維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/nix-core.nix:47-52`。
- **判断**: `extra-substituters`、対応する公開鍵、実効 `require-sigs=true` を維持する。
- **根拠**: `extra-` は既定の `cache.nixos.org` を置換せず追加し、`require-sigs` は content-addressed path 以外へ信頼済み署名を要求する。[Nix configuration syntax](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html) [Nix `require-sigs`](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-require-sigs)
- **注意**: Claude の供給元を nixpkgs 版へ戻す場合は、この第三者 cache 自体を削除できる。

### `CORE-11` — experimental features は list 表記へ揃えるだけにする

- **カテゴリ**: 簡素化候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:39`。
- **推奨**: 変更するなら `[ "nix-command" "flakes" ]` と list で書く。
- **根拠**: 公式例は list 形式であり、現行の空白区切り string と実効動作は同じである。[nix.dev Flakes](https://nix.dev/concepts/flakes.html)
- **副作用**: なし。

### `CORE-12` — `accept-flake-config=false` などの安全側既定を維持する

- **カテゴリ**: 現状維持。
- **判断**: `accept-flake-config`、`restrict-eval`、`allow-import-from-derivation`、`allowed-users` を目的なしに変更しない。
- **根拠**: `accept-flake-config=false` は flake が提案する Nix 設定を無条件適用せず、IFD/restricted evaluation の禁止は互換性への影響が大きい。[Nix 2.34 configuration](https://nix.dev/manual/nix/2.34/command-ref/conf-file.html)

## Flake と入力

### `FLAKE-01` — macOS 向け `nixpkgs-unstable` へ変更する

- **カテゴリ**: 更新候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/flake.nix:5`。
- **推奨**: `github:NixOS/nixpkgs/nixpkgs-unstable` へ変更し、lock 更新後に full build と主要 CLI の smoke test を行う。
- **根拠**: Nixpkgs は非 NixOS 利用者へ `nixpkgs-unstable` を配布し、現行 nix-darwin の macOS 例も同 branch を使う。
  `nixos-unstable` と `nixpkgs-unstable` はともに master を追うが、Hydra の release job と公開時点が異なる。[Nixpkgs manual](https://nixos.org/manual/nixpkgs/unstable/) [nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md)
- **副作用**: lock revision が変わり、ほぼ全 package の rebuild/update になり得る。

### `FLAKE-02` — nix-darwin URL を canonical owner へ直す

- **カテゴリ**: 簡素化候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `nix/flake.nix:6-8`。
- **推奨**: `github:nix-darwin/nix-darwin/master` へ変更する。
- **根拠**: 現行公式 README が organization 移管後の URL を標準形としている。[nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md)
- **副作用**: 通常は redirect 先が同一だが、lock の original owner 表記が変わる。

### `FLAKE-03` — `darwinSystem.system` から `nixpkgs.hostPlatform` へ移る

- **カテゴリ**: 近代化候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/flake.nix:46,77-78`。
- **推奨**: module 側で `nixpkgs.hostPlatform = "aarch64-darwin";` を宣言し、`darwinSystem { system = ...; }` を外す。
- **根拠**: 最新 nix-darwin は `system` 引数を backward compatibility shim とし、公式例は `nixpkgs.hostPlatform` を要求している。[nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md) [nixpkgs module source](https://github.com/nix-darwin/nix-darwin/blob/master/modules/nix/nixpkgs.nix)
- **副作用**: 意図した挙動変更はないが、full evaluation/build で確認する。

### `FLAKE-04` — revision metadata を system へ記録する

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/flake.nix:38-47` で `self` が未使用、実効 `system.configurationRevision=null`。
- **推奨**: `system.configurationRevision = self.rev or self.dirtyRev or null;` を module へ渡す。
- **根拠**: nix-darwin は生成した system の revision 表示用 option を提供する。[nix-darwin options](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.configurationRevision)
- **副作用**: dirty tree では dirty revision が記録されるだけで、system behavior は変わらない。

### `FLAKE-05` — formatter と明示 checks を追加する

- **カテゴリ**: 便利な追加候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/flake.nix:75-91` は `darwinConfigurations` だけを出力する。
- **推奨**: `formatter.aarch64-darwin = ...nixfmt-tree` を追加し、`checks` に system closure と `deadnix`、`statix`、format check を置く。
- **根拠**: `nix fmt` は flake の `formatter.<system>` を使い、`nix flake check` は `checks` derivation を build する。[Nix formatter](https://nix.dev/manual/nix/2.35/command-ref/new-cli/nix3-formatter-run.html) [Nix flake check](https://nix.dev/manual/nix/2.34/command-ref/new-cli/nix3-flake-check)
- **副作用**: `nix flake check` が評価だけでなく lint/build を明示的に負い、所要時間が増える。
  現状でも `darwinConfigurations` 自体の評価は成功しているため、これは検査不能の修正ではなく品質 gate の拡張である。

### `FLAKE-06` — 未使用 binding と lint 警告を整理する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `nix/flake.nix:39-47`、`nix/nix-darwin/nix-core.nix:13`、`nix/nix-darwin/homebrew/common.nix:1`、`nix/nix-darwin/home-manager/packages/private.nix:1-8`。
- **推奨**: 現状のままなら `pkgs`、overlay の `final`、Homebrew の `lib`、private package の `inputs` を外す。
  `self` と `nixpkgs` は `FLAKE-04`、`FLAKE-05` を採用すれば利用する。
- **副作用**: なし。
  `statix` の `or`/`inherit`/属性集約は好みの簡素化であり、behavior change と混ぜない。

### `FLAKE-07` — `local.nix` を秘密情報の保管場所にしない

- **カテゴリ**: security policy の明文化。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/flake.nix:48-50`、`justfile:13-24`、`nix/AGENTS.md:46-58`。
- **推奨**: `local.nix` は host 名、user 名、path、profile など非 secret metadata だけに限定し、credentials/token を絶対に置かない。
  `nix/AGENTS.md` の「秘密情報を含む」という表現は「秘密情報を置かない」へ改める。
- **根拠**: `path:.` は untracked `local.nix` を flake source に含めるため現在の仕組みには必要だが、flake source は Nix store へ copy される。
  Git flake は通常 tracked file だけを扱い、untracked file を含めるには明示 `path:` が必要である。[Nix flake path behavior](https://nix.dev/manual/nix/2.34/command-ref/new-cli/nix.html)
  Nix store 内の設定に credential を置けば平文で読めるため不適切である。[nix.dev credential warning](https://nix.dev/tutorials/nixos/installing-nixos-on-a-raspberry-pi.html)
- **副作用**: secret が必要な将来機能は 1Password/sops-nix/agenix 等、store 外で materialize する別設計が必要になる。

### `FLAKE-08` — `follows` と lock 集約を維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/flake.nix:8,12,16,20,24,28,33`。
- **判断**: root nixpkgs への `follows` を維持する。
- **根拠**: input graph の nixpkgs 重複を避け、system と flake package の ABI/package set を揃えている。[nix.dev input follows](https://nix.dev/concepts/flakes.html)
- **注意**: upstream が特定 nixpkgs revision を必須にした場合だけ個別解除する。

### `FLAKE-09` — Crit の Git URL と Hunk の commit pin は解除条件付きで維持する

- **カテゴリ**: 現状維持 / 要確認。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/flake.nix:18-20,30-33`。
- **判断**: Crit の `git+https` は unauthenticated GitHub REST API rate limit 回避の設計記録があるため維持する。
  Hunk は event-driven watch を含む main commit を狙った pin なので、機能が release に入った時点を解除条件として記録する。
- **根拠**: Flake lock 自体が exact revision/hash を固定しており、URL 形式だけで再現性は失わない。
  Hunk は現行 release v0.17.7 より後の main commit を使っているため、盲目的な tag 回帰は避ける。[Hunk releases](https://github.com/modem-dev/hunk/releases)
- **副作用**: commit pin は `nix flake update` だけでは新 release へ追従しない。

## 一時的に無効化した設定と workaround

### `TEMP-01` — documentation を再有効化する

- **カテゴリ**: 一時無効化の解除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:30-31`。
- **推奨**: `documentation.doc.enable = false;` と古い comment を削除し、既定 `true` に戻す。
- **根拠**: comment が挙げる `--toc-depth` は固定中の nix-darwin/nixpkgs source に存在せず、現行 manual builder は別 option を使う。
  `documentation.doc.enable` の現行既定は `true` である。[nix-darwin documentation options](https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.doc.enable) [manual source](https://github.com/nix-darwin/nix-darwin/blob/master/doc/manual/default.nix)
  有効化した診断 build でも `darwin-manual-html` output が valid store path になり、過去の error は再現しなかった。
- **副作用**: documentation output の分だけ closure が増える。

### `TEMP-02` — darwin-uninstaller を再有効化する

- **カテゴリ**: 一時無効化の解除候補。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:32`。
- **推奨**: 明確な無効化理由が残っていないため行を削除し、既定 `true` に戻す。
- **根拠**: nix-darwin は recovery/uninstall 手段としてこの tool を標準提供し、Nix 自体を先に消すと nix-darwin の uninstall が壊れると案内する。[nix-darwin options](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.tools.darwin-uninstaller.enable) [nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md)
  有効化した診断 build でも `darwin-uninstaller` output が valid store path になった。
- **副作用**: system closure に小さな utility が増えるだけである。

### `TEMP-03` — direnv と statix の test 無効化を解除する

- **カテゴリ**: 一時無効化の解除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:14-17,22-25`。
- **推奨**: overlay の `direnv` と `statix` override を削除する。
  RTK は独立した `PKG-02` で扱う。
- **根拠**: 固定 nixpkgs の通常 derivation は direnv 2.37.1、statix 0.5.8-unstable-2026-07-17 である。
  両方を公式 binary cache から取得できた。[direnv package](https://github.com/NixOS/nixpkgs/tree/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/di/direnv) [statix package](https://github.com/NixOS/nixpkgs/tree/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/st/statix)
- **副作用**: cache miss 時は本来の test/install check が実行される。
  override は derivation hash を変えて公式 cache hit を失わせるため、不要になった時点で外す価値が高い。

### `TEMP-04` — mise の workaround は専用再検証まで残す

- **カテゴリ**: 一時無効化の継続 / 要確認。
- **優先度 / 確度**: 中〜高 / 中。
- **場所**: `nix/nix-darwin/nix-core.nix:18-21`。
- **推奨**: 今回は `doCheck=false` を解除しない。
  少なくとも comment の `2026.6.11` は固定版 `2026.7.10` と不一致なので、追跡 issue、失敗 test、解除条件を記録する。
- **根拠**: 通常 derivation は binary cache hit せず長時間のローカル build に入り、監査時間内に成否を確定できなかったため中断した。
- **副作用**: workaround を維持すると mise の upstream test を通さず、derivation hash 変更による cache miss も続く。

### Tree-sitter の `doCheck=false` は package 置換で解消する

- **カテゴリ**: 一時無効化の解消。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/pkgs/tree-sitter-cli/default.nix:19`。
- **判断**: check だけを戻すのではなく、`PKG-01` のとおり固定 nixpkgs package へ置換する。
- **根拠**: nixpkgs 側も既知 failure により check を無効化しているため、自前で同じ問題を抱える derivation を保守する利点がない。

### その他の disabled/TODO 調査結果

- `nix/nix-darwin/**` の system/Homebrew 領域に、一時停止された service/daemon や comment-out 設定は見つからなかった。
- Home Manager 対象にも `enable=false` や TODO はなく、一時無効化は上記 package test に限られる。

## Custom package と package source-of-truth

### `PKG-01` — 独自 Tree-sitter CLI を固定 nixpkgs 版へ置き換える

- **カテゴリ**: 削除 / 置換候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/pkgs/tree-sitter-cli/default.nix:1-28`、`nix/nix-darwin/home-manager/packages/common.nix:77`、`nix/AGENTS.md:11,31`。
- **推奨**: custom derivation を削除し、package list を `pkgs.tree-sitter` にする。
- **根拠**: custom package は 0.26.8 だが、固定 nixpkgs は CLI、main program、completion を持つ 0.26.9 を既に供給する。[固定 nixpkgs package](https://github.com/NixOS/nixpkgs/blob/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/tr/tree-sitter/package.nix)
  Web 調査時点の upstream latest は v0.26.11 であり、custom package を残しても最新版ではない。[Tree-sitter v0.26.11](https://github.com/tree-sitter/tree-sitter/releases/tag/v0.26.11)
- **副作用**: nixpkgs package は library も同 output 集合に含む可能性があるが、binary cache、補完、更新保守を得る。
  `nix/AGENTS.md` の「nixpkgs にない custom package」の例も更新する。

### `PKG-02` — RTK の stale override を外す

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:67-68`。
- **推奨**: comment と `overrideAttrs { doCheck = false; }` を削除し、plain `rtk` にする。
- **根拠**: comment は 0.43.0 の failure を説明するが、lock は 0.44.0 であり、通常 derivation の取得/build に成功した。[固定 nixpkgs RTK](https://github.com/NixOS/nixpkgs/blob/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/rt/rtk/package.nix)
- **副作用**: cache miss 時には本来の check が戻る。

### `PKG-03` — site2skill を安定版 0.1.1 へ更新する

- **カテゴリ**: 更新候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/pkgs/site2skill/default.nix:8-16`。
- **推奨**: まず Python stable 0.1.1 へ version/hash を更新する。
  Rust rewrite の 0.2.0b2 は別の beta 移行として試験する。
- **根拠**: PyPI は 0.1.1 を latest stable、0.2.0b2 を pre-release として公開している。[site2skill on PyPI](https://pypi.org/project/site2skill/)
  0.1.1 は現行 Python/wget 設計の最小更新であり、0.2 系は wget 不要・単一 binary・高速化を掲げる一方で互換性を別途確認する必要がある。[site2skill repository](https://github.com/laiso/site2skill)
- **副作用**: stable 更新は小さい。
  Rust beta は CLI、output、package 方法が変わる可能性がある。

### `PKG-04` — site2skill の Python package 属性を現行形へ直す

- **カテゴリ**: 近代化候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/pkgs/site2skill/default.nix:18-30`。
- **推奨**: 0.1.1 更新時に build backend を `build-system = [ hatchling ];`、runtime dependency を `dependencies = [ ... ];` へ移す。
  `makeWrapper` と `pythonImportsCheck` は維持する。
- **根拠**: 現行 Nixpkgs Python manual は PEP 517 backend と runtime dependency にこの属性を案内する。[Nixpkgs Python manual](https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md)
  PyPI sdist に test が含まれないため `doCheck=false` 自体は合理的だが、「network integration test」を理由にした comment は実体へ合わせる。
- **副作用**: 意図する dependency semantics は同じである。

### `PKG-05` — Pique は現状維持し、OS 要件だけ確認する

- **カテゴリ**: 現状維持 / 要確認。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/pkgs/pique/default.nix:9-32`。
- **判断**: 0.1.0b5 は latest なので維持する。
  対象 host が macOS 26 以上かを確認し、preview が stale な場合の `qlmanage` cache refresh を運用メモにする。
- **根拠**: upstream は 0.1.0b5 を latest とし、app/package が署名・notarize 済みと示す。[Pique releases](https://github.com/macadmins/pique/releases)
- **副作用**: `meta.platforms = darwin` は minimum OS を検証しない。
  毎 activation の Finder restart は UX を壊すため追加しない。

### `PKG-06` — Yazi と画像/PDF/圧縮 CLI の direct install を利用実態で絞る

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 低〜中 / 高。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:60-66`。
- **判断**: `_7zz-rar` を渡す Yazi override は有効なので維持する。
  `_7zz-rar`、resvg、Poppler、ImageMagick を Yazi 外で直接使わないものだけ package list から外す。
- **根拠**: Nixpkgs の Yazi wrapper は jq、Poppler、7zz、ffmpeg、fd、ripgrep、fzf、zoxide、ImageMagick、chafa、resvg を PATH へ含める。[固定 nixpkgs Yazi](https://github.com/NixOS/nixpkgs/blob/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/ya/yazi/package.nix)
- **副作用**: store object は shared されるため disk 削減は小さい場合が多く、主効果は global profile/PATH の縮小である。

### `PKG-07` — Claude package の供給方法を選ぶ

- **カテゴリ**: 要確認 / 簡素化候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/nix-core.nix:11-12,47-52`、`nix/nix-darwin/home-manager/packages/work.nix:12`。
- **選択肢 A**: 更新速度、upstream wrapper、telemetry 処理を重視し、`claude-code-overlay` と Cachix を維持する。
  その場合でも、唯一の利用箇所で `inputs.claude-code-overlay.packages.${system}.default` を直接参照すれば global overlay は外せる。
- **選択肢 B**: trust surface と lock graph を縮め、固定 nixpkgs の `pkgs.claude-code` を使って third-party input/cache を削除する。
- **回答値**: `PKG-07:A` または `PKG-07:B`。
- **根拠**: 調査時点では両者の version は 2.1.220 だが、overlay package は単なる version 差ではなく wrapper/telemetry 処理を持つ。[upstream flake source](https://github.com/ryoppippi/nix-claude-code/blob/main/flake.nix)
- **副作用**: A の直接参照は package behavior を保ったまま overlay scope を狭める。
  B は更新速度と wrapper behavior が変わり、`allowUnfreePackages` の対象も再確認する。

### `PKG-08` — Git と Luarocks の source-of-truth を決める

- **カテゴリ**: 削除候補 / PATH 整理。
- **優先度 / 確度**: 中〜高 / 中〜高。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:32-45`、`config/zsh/.zshenv`、`config/fish/config.d/path.fish`、`config/mise/config.toml`。
- **事実**: runtime PATH では Homebrew の Git と mise 管理の Lua/Luarocks が、Nix profile の同名 CLI を覆い得る。
- **推奨**: Nix を正にするなら PATH 順と Brew/mise package を直す。
  実行時の Brew/mise を正にするなら Nix 側を外す。
  Lua 5.1 を mise で明示管理しているため、Nix `luarocks` は強い削除候補である。
- **回答例**: `PKG-08:git=Nix,luarocks=mise`。
- **副作用**: Git helper/plugin discovery と Luarocks の Lua ABI が変わり得るため、`command -v`、version、基本操作を switch 後に確認する。
  ripgrep は `BREW-07` で Nix 版を正とする独立判断に統一する。

### `PKG-09` — repo 内で用途不明の global CLI を一つずつ確認する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 低〜中 / 中。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:43-78`。
- **候補**: `jnv`、`hyperfine`、`openssl_3`、`socat`、direct `wget`。
- **推奨**: 対話利用を本人確認し、project build だけで使う `openssl_3` などは project の devShell/mise へ寄せる。
- **回答例**: `PKG-09:openssl_3削除,socat維持` のように package ごとに指定する。
- **副作用**: repo 内未参照は未使用の証明ではないため、一括削除しない。
  `wget` は site2skill wrapper 内にも必要だが、direct command の要否とは分ける。
  direct `resvg` と `_7zz-rar` は Yazi wrapper との関係を含めて `PKG-06` だけで判断する。

### `PKG-10` — active な package と profile 組立を維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:8-81`、profile package files。
- **判断**: `ov`、tree/ghq/fzf/bat、LSP/formatter、gogcli、Guard-and-Guide、Herdr、Hunk、Crit などは config/history から用途が確認できるため維持する。
  `commonPackages ++ profilePackages` の単純な組立と private の空 extension point も維持してよい。
- **副作用**: strict lint を重視する場合だけ empty profile file の未使用引数を減らす。

## Home Manager の state と application 配備

### `HM-01` — `home.stateVersion = "24.11"` の来歴を確認する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 高 / 事実は高、変更判断は中。
- **場所**: `nix/nix-darwin/home-manager/default.nix:27`。
- **推奨**: repo 統合以前に Home Manager 24.11 の state を引き継いだか確認する。
  引き継いだなら維持し、そうでなく 2026-02-11 の初回導入が起点なら当時の 26.05 を基準として release note を読んで明示移行する。
- **回答値**: `HM-01:24.11継承`、`HM-01:2026-02初回`、または `HM-01:不明`。
- **根拠**: Home Manager は `home.stateVersion` を「現在の Home Manager version」ではなく、この home configuration を初めて使った release として維持するよう警告する。[Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html)
- **副作用**: 24.11 から上げると、25.11 の Darwin app copy、26.05 の GNU man package 既定など state-gated behavior が変わる。[25.11 notes](https://nix-community.github.io/home-manager/release-notes/rl-2511.html) [26.05 notes](https://nix-community.github.io/home-manager/release-notes/rl-2605.html)

### `HM-02` — 独自 app symlink activation を `copyApps` へ置き換える

- **カテゴリ**: 削除 / 追加候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/default.nix:31-45`。
- **推奨**: 独自 `linkApplications` を削除し、stateVersion と独立して `targets.darwin.copyApps.enable = true;` と `targets.darwin.linkApps.enable = false;` を明示する。
- **根拠**: 現 script は消えた app の stale link を掃除せず、既存 link の package 更新時に LaunchServices を再登録しない。
  現行 Home Manager の `copyApps` は `rsync --delete`、旧 linkApps migration、Spotlight 対応、App Management 権限 check を実装する。[Home Manager Darwin targets](https://nix-community.github.io/home-manager/options/home-manager/targets.html) [copyApps source](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/targets/darwin/copyapps.nix)
- **副作用**: app bundle を home へ実コピーするため容量を使う。
  初回 App Management 許可が必要で、SSH/headless activation は check で失敗し得る。
  独自 script が作った `~/Applications/*.app` は一度 target を確認して安全に掃除する必要がある。

### `HM-03` — 24.11 を維持するなら GNU man を明示的に外す

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/home-manager/default.nix:18-30`。
- **推奨**: `home.stateVersion` を 24.11 に据え置く場合は `programs.man.package = null;` を明示し、macOS の man を使う。
- **根拠**: Home Manager 26.05 は Darwin の GNU man による apropos/whatis 問題を避けるため、stateVersion 26.05 以上の package 既定を `null` に変更した。[Home Manager 26.05 notes](https://nix-community.github.io/home-manager/release-notes/rl-2605.html) [man module](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/programs/man/default.nix)
- **副作用**: GNU man 固有の挙動を使っていれば変わるが、manual outputs 自体は維持される。

### `HM-04` — `home-manager.minimal` は architecture を選んでから使う

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 低〜中 / 中。
- **場所**: `nix/nix-darwin/home-manager/default.nix:7-30`。
- **推奨**: Home Manager を file/package 配備器として小さく保つなら候補にする。
  Fish/Tmux/Yazi などを `programs.*` へ移す計画なら採用しないか、必要 module を明示 import する。
- **根拠**: 25.11 追加の minimal mode は core module と shell だけを読み、評価対象を減らす advanced option である。[Home Manager 25.11 notes](https://nix-community.github.io/home-manager/release-notes/rl-2511.html)
- **副作用**: programs/services option を使うたびに module import の保守が必要になる。

### `HM-05` — global package set と backup policy を維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/home-manager/default.nix:8-10`。
- **判断**: `useGlobalPkgs=true`、`useUserPackages=true`、`backupFileExtension="backup"` を維持する。
- **根拠**: system nixpkgs の共有、user profile への package 配置、衝突時の安全な退避という現在の設計に合う。[Home Manager nix-darwin module source](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/nixos/common.nix)
- **注意**: `overwriteBackup=true` は古い backup を失うため追加しない。

## Home Manager の file 境界

### `FILE-01` — out-of-store directory link の目的を明文化する

- **カテゴリ**: architecture 要確認。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/home-manager/files/common.nix:8-31`。
- **判断**: Neovim など即時編集したい config は live link を維持してよい。
  rollback 再現性を必要とする静的 config は store-backed source を選ぶ。
- **根拠**: `mkOutOfStoreSymlink` は現行の正式 API だが、directory の内容を generation へ固定せず、target app から repo へ書き戻せる。[Home Manager dotfile guide](https://nix-community.github.io/home-manager/usage/dotfiles.html)
- **副作用**: store-backed にすれば編集後 activation が必要になるが、generation rollback の意味が強くなる。

### `FILE-02` — Herdr の runtime state を repo から分離する

- **カテゴリ**: 変更候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/files/common.nix:24`。
- **推奨**: directory 全体ではなく `xdg.configFile."herdr/config.toml"` だけを管理する。
- **根拠**: 現在の `~/.config/herdr` 全体 link は sessions、logs、release notes、plugin lock などを repo へ流入させ、実際に `config/herdr/.plugins.lock` が untracked で現れた。
- **副作用**: directory symlink から real directory への一度きりの migration が要る。
  Herdr を停止し、既存 state を保持して切り替える。

### `FILE-03` — Hunk の machine-local state を分離する

- **カテゴリ**: 変更候補。
- **優先度 / 確度**: 中 / 中〜高。
- **場所**: `nix/nix-darwin/home-manager/files/common.nix:26`、`config/hunk/state.json`。
- **推奨**: version notice の既読状態を端末間同期する意図がなければ、`hunk/config.toml` だけを link する。
- **根拠**: Hunk が案内する設定先は `~/.config/hunk/config.toml` で、`state.json` は `lastSeenCliVersion` など runtime state を持つ。[Hunk config](https://github.com/modem-dev/hunk#config)
- **副作用**: notice/既読状態が端末ごとに分かれる。

### `FILE-04` — 重複した Zsh directory link を削除する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/files/common.nix:16,41`。
- **推奨**: 適用直前にも実効 `ZDOTDIR` が未設定であることを確認し、`xdg.configFile.zsh` を削除して `home.file.".zshenv"` だけを残す。
- **根拠**: `config/zsh` には `.zshenv` しかなく、同じ file を `~/.zshenv` へも配る。
  repo と調査時点の実効環境には `ZDOTDIR` の設定がなく、Zsh は `.zshenv` 読込前に `ZDOTDIR` を現在の file から設定できないため、`~/.config/zsh/.zshenv` は現在の実行経路に入らない。[Zsh startup files](https://zsh.sourceforge.io/Doc/Release/Files.html)
- **副作用**: shell behavior は変わらず、不要 link だけが消える。

### `FILE-05` — Tirith の残骸を削除する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `config/zsh/.zshenv:29-30`、`AGENTS.md:5`。
- **推奨**: 再導入予定がなければ conditional `tirith init` hook と、存在しない `config/tirith/` を列挙する repository guide の記述を同じ cleanup で削除する。
- **根拠**: Tirith の flake input/package/config directory は削除済みで、hook と文書参照だけが残る。
- **副作用**: PATH 外から Tirith を意図的に供給している場合だけ init が消える。

### `FILE-06` — Claude settings の `force=true` を方針として確認する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `nix/nix-darwin/home-manager/files/common.nix:47-50`。
- **判断**: repo を絶対的な正とするなら維持する。
  Claude が local permission/state を同 file に書き戻すなら、managed 部分の分割か non-force 化を選ぶ。
- **根拠**: Home Manager の `force` は target が通常 file/link でも無条件に削除し、ここだけ `backupFileExtension` の安全策を迂回する。[Home Manager file type source](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/lib/file-type.nix)
- **副作用**: force を外すと衝突時に activation が停止または backup し、維持すると未管理データを無言で消し得る。

### `FILE-07` — SOUL.md の相対参照が実際に load されるか確認する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 中 / 中。
- **場所**: `config/codex/AGENTS.md:21`、`config/claude/CLAUDE.md:13`、`nix/nix-darwin/home-manager/files/common.nix:40-57`。
- **推奨**: Codex と Claude を分け、`@SOUL.md` の import syntax、相対 path の基準、symlink の realpath 解決、実際の load を公式仕様または最小 load test で確認する。
  logical な `~/.codex` / `~/.claude` 相対で欠落すると確認できた runtime だけ、対応する SOUL.md を配備する。
- **根拠**: 両 instruction file に `@SOUL.md` があり、Home Manager 宣言と調査時点の実 home には対応 file がないことまでは確認できた。
  ただし、参照が symlink target の repo directory を基準に解決される可能性を除外できず、現在読み落とされているとは断定できない。
- **副作用**: 配備により今まで load されていなかった instruction が有効になる可能性がある一方、既に realpath 基準で load 済みなら重複または無変更になる。

## Shell と tool module の所有権

### `SHELL-01` — Fish login shell を nix-darwin 管理へ移す

- **カテゴリ**: 追加 / 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:35`、`script/set-fish-default.sh`。
- **推奨**: system 側で `programs.fish.enable = true;` と user shell を宣言し、Home Manager の direct Fish package と手動 script を廃止する。
- **根拠**: nix-darwin は Fish を `/etc/shells` と login shell に宣言的に統合できる。[nix-darwin Fish options](https://nix-darwin.github.io/nix-darwin/manual/#opt-programs.fish.enable)
- **副作用**: login shell の所有者が nix-darwin に変わる。
  反映前に recovery shell と rollback 手順を確認し、Fish config link はそのまま維持する。

### `SHELL-02` — direnv/nix-direnv を nix-darwin module へ統合する

- **カテゴリ**: 追加 / 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/packages/common.nix:55-57`、`nix/nix-darwin/home-manager/files/common.nix:33-37`、`config/fish/conf.d/direnv.fish`。
- **推奨**: nix-darwin の `programs.direnv.enable` を使い、2 package、生成 direnvrc、手動 Fish hook を一括で置換する。
- **根拠**: nix-darwin module は package install、Bash/Fish/Zsh hook、既定有効の nix-direnv をまとめて管理する。[nix-darwin direnv options](https://nix-darwin.github.io/nix-darwin/manual/#opt-programs.direnv.enable)
- **副作用**: hook 順と生成内容が変わり、Zsh にも hook が入る。
  `TEMP-03` の direnv override 解除と同じ build/switch で検証する。

### `SHELL-03` — TPM から Home Manager tmux module への移行を別タスクにする

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 中 / 中。
- **場所**: `config/tmux/tmux.conf:101-105`、`nix/nix-darwin/home-manager/files/common.nix:23`。
- **判断**: session 起動時に TPM を clone する mutable/network 依存を許容するなら維持する。
  Nix 固定を優先するなら `programs.tmux.plugins` へ config 全体を一括移行する。[Home Manager tmux module](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/programs/tmux.nix)
- **副作用**: parent `~/.config/tmux` link と managed child は同居できない。
  plugin 更新時点、key binding、起動 hook の回帰試験が必要である。

### `SHELL-04` — Fisher から Home Manager Fish module への移行は一括で行う

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 中 / 中。
- **場所**: `config/fish/fish_plugins`、`nix/nix-darwin/home-manager/files/common.nix:15`。
- **判断**: mutable な Fisher を維持するか、全 plugin を package 化して `programs.fish.plugins` へ一括移行するかを選ぶ。[Home Manager Fish module](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/programs/fish.nix)
- **副作用**: directory link と module 管理の部分混在はできず、未収録 plugin、prompt/hook 順、更新方法を検証する必要がある。

### `SHELL-05` — Yazi module 化は現状維持とする

- **カテゴリ**: 現状維持 / 将来候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `config/fish/conf.d/yazi.fish`、`nix/nix-darwin/home-manager/files/common.nix:22`。
- **判断**: 独自 `y` wrapper があるため今は維持する。
  将来 `programs.yazi` へ全体移行する場合は `shellWrapperName = "y"` を明示する。[Home Manager Yazi module](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/programs/yazi.nix)

### `SHELL-06` — module 化は tool ごとに所有権を丸ごと切り替える

- **カテゴリ**: 移行時の制約。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/home-manager/files/common.nix:14-31`。
- **判断**: Fish/Tmux/Yazi/direnv の module option を一個ずつ足さず、各 tool の parent directory link を外す migration と同時に行う。
- **根拠**: 現在の non-recursive parent directory symlink と Home Manager managed child file は target ownership が衝突する。[Home Manager files source](https://github.com/nix-community/home-manager/blob/e705714e918c3b11affcdd15db2cbe3a070420a0/modules/files.nix)
- **副作用**: 部分移行は activation failure、二重 hook、設定の重複を招く。

## Homebrew

### `BREW-01` — 廃止済み `codex-app` を安全に撤去する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:81-82,89`。
- **推奨手順**: OpenAI の案内に従って新 ChatGPT app への移行を確認し、履歴・project state を退避する。
  次に一度だけ `zap` ではない通常 uninstall、または一時的な `cleanup = "uninstall"` で旧 app を外し、その後 `codex-app` 宣言を削除する。
- **根拠**: Homebrew は `codex-app` を 2026-07-12 付で discontinued とし、replacement を `chatgpt` としている。[codex-app cask API](https://formulae.brew.sh/api/cask/codex-app.json)
  OpenAI も Chat、Work、Codex を統合した新 ChatGPT desktop app への移行を案内する。[OpenAI migration guide](https://help.openai.com/en/articles/20001276-moving-to-the-new-chatgpt-desktop-app)
  terminal 用 `codex` cask は別物なので、`codex` と `chatgpt` の併存は妥当である。[codex cask API](https://formulae.brew.sh/api/cask/codex.json)
- **重大な副作用**: 現在の `cleanup="zap"` は旧 Codex の Application Support、cache、preferences などを消し、新 app と共有する state を失う可能性がある。
  移行確認前に単純削除して switch してはいけない。

### `BREW-02` — 重複した `--force-cleanup` を削除する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:110-114`。
- **推奨**: `extraFlags = [ "--force-cleanup" ];` を削除する。
- **根拠**: 固定中 nix-darwin は `cleanup = "zap"` から `--zap --force-cleanup` を自動生成し、その後に `extraFlags` を連結するため、現在は同 flag が二度渡る。[固定 nix-darwin Homebrew module](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/homebrew.nix)
- **副作用**: なし。

### `BREW-03` — activation の更新・cleanup policy を選び直す

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:110-115`。
- **現状**: switch のたびに Homebrew update、全体 upgrade、未宣言 package cleanup、未宣言 cask の関連 file まで zap する。
- **推奨案 A**: 更新操作として意図しているなら現状維持するが、`switch` が network と外部最新版に依存し、同じ flake でも結果が変わることを受け入れる。
- **推奨案 B**: switch 中の非決定的な更新を減らし、`autoUpdate=false; upgrade=false; cleanup="uninstall";` として update を別 command/定期作業に分ける。
- **推奨案 C**: 安全確認を優先し `autoUpdate=false; upgrade=false; cleanup="check";` として、差分を人が確認してから宣言へ反映する。
- **回答値**: `BREW-03:A`、`BREW-03:B`、または `BREW-03:C`。
- **根拠**: nix-darwin は反復 switch の冪等性を保つため `autoUpdate` と `upgrade` の既定を false とする。
  `zap` は cask の関連 file も消し、`check` は削除せず activation を中断する。[nix-darwin Homebrew options](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.onActivation) [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- **限界**: B でも Homebrew metadata、unversioned formula/cask、fresh install の解決先は mutable なので、Nix のような完全な再現性は得られない。
- **副作用**: B/C では switch 時の自動更新が止まり、別の更新習慣が必要になる。
  C は手動 package が一つでもあると system activation 全体を止める。
- **関連判断**: `homebrew.global.autoUpdate` の既定は true なので、manual `brew install/upgrade` 時の自動 update を残すかも同時に決める。[nix-darwin `global.autoUpdate`](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.global.autoUpdate)

### `BREW-04` — tap 全体ではなく必要 item だけを信頼する

- **カテゴリ**: security / 構造改善候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:50-62,116-119`。
- **推奨**: brew/cask を `owner/tap/item` の完全修飾名にし、item の `trusted=true` を使う。
  明示 tap entries と、現在・将来の profile tap をすべて自動 trust する map は削除する。
- **現在の mapping**: `nikitabobko/tap/aerospace`、`daipeihust/tap/im-select`、`k1LoW/tap/mo`、`k1LoW/tap/roots`、`Jean-Tinland/a-bar/a-bar`、`Warashi/tap/cage`、`productdevbook/tap/portkiller`、`simoarpe/ziggity/ziggity` を候補とする。
  `roots` を削除する場合はその item を除く。
- **根拠**: Homebrew 6 は non-official tap の trust を要求し、tap 全体の trust は将来追加される formula/cask/external command の Ruby まで実行可能にするため、必要 item だけの trust を推奨する。[Homebrew Tap Trust](https://docs.brew.sh/Tap-Trust)
  nix-darwin は完全修飾 item に trust を設定できる。[nix-darwin Homebrew options](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.brews)
- **副作用**: 初回 switch で trust/tap state が再構成される。
  適用前に完全修飾名の大文字小文字と生成 Brewfile を検証する。

### `BREW-05` — `im-select` の mutable・無 hash 配布を止める

- **カテゴリ**: security 要確認。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:32,52`、利用箇所 `menubar-script/ime/read-state.sh:30-34`。
- **推奨**: immutable commit/release と hash を使う小さな Nix package を定義するか、同機能の固定可能な代替 CLI へ移る。
  移行まで item 単位 trust に限定する。
- **根拠**: 現 tap formula は `sha256 ""` のまま `raw.githubusercontent.com/.../master/.../im-select` を直接取得し、version 1.0.1 と書いてあっても内容を固定・検証しない。[im-select tap formula](https://github.com/daipeihust/homebrew-tap/blob/main/im-select.rb) [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- **副作用**: 単純削除すると IME menu bar 表示が止まり、自前 package は upstream 更新時の hash 更新が必要になる。
  item 単位 trust は実行を許す Ruby/tap の範囲を狭めるだけで、mutable・checksum-free な payload の integrity 問題は解決しない。

### `BREW-06` — `roots` を削除する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:38,53`。
- **推奨**: repo 外で手動利用していなければ formula 宣言を削除する。
- **根拠**: commit `8a48724` が Fish の `ghq_cd_fzf` から roots 依存を削除し、現在の repo 内実行参照は Homebrew 宣言だけである。
  upstream の用途は monorepo root 探索である。[roots repository](https://github.com/k1LoW/roots)
- **副作用**: ad-hoc に `roots` CLI を使っていれば消える。
  k1LoW tap は `mo` が残る限り必要である。

### `BREW-07` — Homebrew 版 ripgrep を削除する

- **カテゴリ**: 削除候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:36`、Nix 側 `nix/nix-darwin/home-manager/packages/common.nix:33`。
- **推奨**: Homebrew 宣言と「codex formula dependency」という stale comment を削除し、Nix 版を正にする。
- **根拠**: 現行 `codex` cask 0.146.0 の dependency は空であり、ripgrep を要求しない。[codex cask API](https://formulae.brew.sh/api/cask/codex.json)
  現在は `/opt/homebrew/bin/rg` が Nix 版を shadow し、flake による version 固定を無効化している。
- **副作用**: `rg` の供給元/version が Nix 版へ切り替わるが、command 自体は維持される。

### `BREW-08` — Homebrew formula `mas` を削除し、必要なら `programs.mas` へ移る

- **カテゴリ**: 削除 / 移行候補。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:31,100-104,119`、`nix/nix-darwin/homebrew/private.nix:16-18`。
- **CLI の選択**: `mas` を対話利用しないなら Homebrew formula だけを削除できる。
  対話利用するなら、`pkgs.mas` を Home Manager/system package へ追加して formula を削除するか、Homebrew formula を維持する。
- **app 管理の選択**: `homebrew.masApps` を維持するか、`programs.mas.packages` へ移す。
- **回答例**: `BREW-08:no-cli+homebrew-masApps`、`BREW-08:nix-cli+programs-mas`、または `BREW-08:brew-cli+homebrew-masApps`。
- **根拠**: 固定 nix-darwin の Homebrew activation は実行時だけ `pkgs.mas` を activation script の PATH に入れるため、宣言した App Store app の管理には Homebrew formula が不要である。
  ただし `pkgs.mas` を user profile へ常設するわけではないため、formula 削除は interactive `/opt/homebrew/bin/mas` を消す。
  新しい `programs.mas` は install/update に加えて宣言外 MAS app cleanup も管理できる。[nix-darwin MAS options](https://nix-darwin.github.io/nix-darwin/manual/#opt-programs.mas.enable) [fixed source](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/programs/mas.nix)
- **副作用**: `programs.mas.cleanup=true` は宣言外の全 App Store app を削除するため、最初は false で棚卸しする。
  `programs.mas.update` の既定 true にも留意する。
  現在宣言した 4 app ID は調査時点で Apple lookup が有効だった。[Apple lookup example](https://itunes.apple.com/lookup?id=6446206067&country=jp)

### `BREW-09` — 2 font を `fonts.packages` へ移す

- **カテゴリ**: 移行候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:95-97`。
- **推奨**: `font-hackgen-nerd` と `font-monaspace` cask を `pkgs.hackgen-nf-font` と `pkgs.monaspace` へ置き換える。
- **根拠**: 固定 nixpkgs は Homebrew cask と同じ HackGen NF 2.10.0、Monaspace 1.400 を持ち、nix-darwin は `fonts.packages` を `/Library/Fonts/Nix Fonts` へ同期する。[HackGen package](https://github.com/NixOS/nixpkgs/blob/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/ha/hackgen-nf-font/package.nix) [Monaspace package](https://github.com/NixOS/nixpkgs/blob/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/mo/monaspace/package.nix) [nix-darwin fonts](https://nix-darwin.github.io/nix-darwin/manual/#opt-fonts.packages)
- **副作用**: font 配置が system-wide location へ変わり、移行中は同じ PostScript name が一時重複し得る。
  Font Book と利用 app の再起動確認が必要である。

### `BREW-10` — `mo`/`mole` 衝突回避を利用実態で整理する

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 中 / 中。
- **場所**: `nix/nix-darwin/homebrew/common.nix:3-25,39-47,122-140`。
- **判断**: browser Markdown viewer `mo` を Crit 移行後も手動利用するなら現行の `link=false` と managed symlink を維持する。
  不要なら `mo` formula と専用 symlink を外し、Mole を通常 link に戻して activation を簡素化する。
- **回答値**: `BREW-10:mo維持` または `BREW-10:mo削除`。
- **根拠**: active code から viewer `mo` の呼出しはなく、設計書は Crit 置換時に mo uninstall を意図的に対象外としていた。
  Mole は `mo` と `mole` の両 binary を持つため、両 formula を残す限り衝突回避が必要である。[mo](https://github.com/k1LoW/mo) [Mole](https://github.com/tw93/Mole)
- **副作用**: viewer を削除すると `mo` command は Mole 側になるか、link 方針によって消える。

### `BREW-11` — Worktrunk は最新版か Nix 固定かを選ぶ

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 低〜中 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:34`。
- **判断**: active 利用中なので削除しない。
  更新速度なら Homebrew 0.71.0 を維持し、Nix 一元管理なら固定 nixpkgs 0.68.0 へ移す。[Homebrew Worktrunk API](https://formulae.brew.sh/api/formula/worktrunk.json) [固定 nixpkgs package](https://github.com/NixOS/nixpkgs/blob/0954f7ee2f6bb3dc7d4e3d0d8bcb8fd4bde4cfc5/pkgs/by-name/wo/worktrunk/package.nix)
- **回答値**: `BREW-11:brew` または `BREW-11:nix`。
- **副作用**: Nix 移行は現時点で 3 minor 古くなる。

### `BREW-12` — hard-coded prefix を module option へ寄せる

- **カテゴリ**: 簡素化候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `nix/nix-darwin/homebrew/common.nix:1-6,136-137`。
- **推奨**: module 引数に `config` を加え、`config.homebrew.prefix` を使う。
- **根拠**: nix-darwin は Apple Silicon の既定を `/opt/homebrew` とする正式 option を提供し、現在の独自定数は同じ真実を重複させる。[nix-darwin `homebrew.prefix`](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.prefix)
- **副作用**: 現 host ではない。

### `BREW-13` — `greedyCasks` は自己更新方針に合わせる

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 低〜中 / 高。
- **場所**: 現在 `homebrew.greedyCasks` は未設定。
- **判断**: `auto_updates=true` の app を各 app の updater に任せるなら現状維持する。
  Homebrew へ更新を統一する場合だけ全体または item ごとの `greedy=true` を使う。[nix-darwin `greedyCasks`](https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.greedyCasks)
- **副作用**: greedy は大容量再 download、license prompt、app 自己更新との競合を増やす。

### `BREW-14` — active dependency は維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/homebrew/common.nix:28-98`。
- **判断**: `curl`、Fisher、media-control、ziggity、Worktrunk、Cage、a-bar、Nani は active な script/config 参照があるため削除しない。
- **根拠**: Cage cask は Homebrew curl を明示利用し、Fisher は Fish plugin flow、media-control は menu bar script から呼ばれる。[Cage cask source](https://github.com/Warashi/homebrew-tap/blob/main/Casks/cage.rb)

### `BREW-15` — GUI と hardware package は本人確認でだけ削る

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 低 / 中。
- **場所**: `nix/nix-darwin/homebrew/common.nix:72-80,103`。
- **候補**: Stats と RunCat Neo は menu bar monitoring の用途が重なる。
  Logitech G Hub、Logi Options+、HHKB、AnkerWork は対応 hardware をもう使っていないものだけ外す。
- **副作用**: device remap、firmware、camera、monitor 表示を失う。
  G Hub と Options+ は対象 device 群が異なるため単純重複とは扱わない。

### `BREW-16` — profile schema placeholder は維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/homebrew/private.nix`、`work.nix`。
- **判断**: 空の `brews`、`taps`、`masApps` は common module が全 field を無条件参照する schema/extension point なので、現構造のままなら削除しない。
- **棚卸し結果**: 公式 Homebrew API で common/private/work の公式 cask を照合し、deprecated/disabled は `codex-app` だけだった。

## macOS system defaults と security

### `SYS-01` — Dock の意図を left/right/bottom から選ぶ

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `nix/nix-darwin/system.nix:47-48`。
- **現状**: comment は「左側」、値は `right` で矛盾する。
- **選択肢**: right が意図なら comment だけ直す。
  AeroSpace 推奨に合わせるなら `bottom` と現在の `autohide=true` を使う。
- **回答値**: `SYS-01:left`、`SYS-01:right`、または `SYS-01:bottom`。
- **根拠**: AeroSpace は隠した window の 1px edge を目立たなくするため bottom + autohide を推奨する。[AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide#emulation-of-virtual-workspaces)
- **副作用**: position 変更は作業領域と操作感へ直接影響するため、自動判断しない。

### `SYS-02` — digital clock を意図するなら `IsAnalog=false` を宣言する

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/system.nix:90-100`。
- **推奨**: `system.defaults.menuExtraClock.IsAnalog = false;` を追加する。
- **根拠**: 24 時間、日、曜日などの宣言は digital display を意図するが、調査時点の実機 plist は analog で、Apple は analog 時に他の clock option が無効になると説明する。[Apple clock settings](https://support.apple.com/en-ie/guide/mac-help/mchlb3236e90/mac) [nix-darwin options](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.defaults.menuExtraClock.IsAnalog)
- **副作用**: menu bar 時計が analog から digital へ変わる。

### `SYS-03` — Application Firewall を宣言する

- **カテゴリ**: security 追加候補。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/system.nix` に現在宣言がなく、調査時点の実機 firewall は無効である。
- **推奨初期値**: `networking.applicationFirewall.enable = true;`、`blockAllIncoming = false;` とする。
  signed software の自動許可を現状どおり明示するか、stealth mode も有効にするかは別々に選ぶ。
- **根拠**: Apple は不要な外部/network からの着信を防ぐため firewall を案内し、nix-darwin は enable、block all、signed app、stealth を正式 option として持つ。[Apple firewall guide](https://support.apple.com/en-gb/guide/mac-help/mh11783/mac) [nix-darwin firewall source](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/networking/applicationFirewall.nix)
- **副作用**: unsigned dev server、LAN sharing、Screen Sharing、container runtime が prompt/block され得る。
  stealth は ping/closed-port probe への応答を止め、LAN 診断に影響する。[Apple stealth mode](https://support.apple.com/ja-jp/guide/mac-help/use-stealth-mode-to-keep-your-mac-more-secure-mh17133/mac)

### `SYS-04` — screen lock 後の即時 password 要求を宣言する

- **カテゴリ**: security 追加候補。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `system.defaults.screensaver.*` は現在未宣言。
- **推奨**: `askForPassword = true;` と `askForPasswordDelay = 0;` を追加する。
- **根拠**: Apple は sleep/screen saver 後の password 要求を離席時保護として案内し、nix-darwin に typed option がある。[Apple lock screen guide](https://support.apple.com/en-ie/guide/mac-help/mchlp2270/mac) [nix-darwin screensaver options](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.defaults.screensaver.askForPassword)
- **副作用**: display off/screen saver 後すぐ再認証になる。

### `SYS-05` — `ignoreArd` の効力を検証してから残すか決める

- **カテゴリ**: 効力未検証 / security trade-off。
- **優先度 / 確度**: 高 / 中。
- **場所**: `nix/nix-darwin/system.nix:14-17`。
- **事実**: 固定 nix-darwin の `CustomSystemPreferences` は各 entry を `defaults write <domain> <key>` として実行する。[nix-darwin defaults writer](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/system/defaults-write.nix)
  現在の宣言 `com.apple.security.authorization` / `ignoreArd` は NIST mSCP の configuration profile と同じ表記だが、NIST が direct `defaults write` 用に示す値は `com.apple.Authorization` / `ignoreARD` である。[Tahoe Rev. 3 supplemental guidance](https://github.com/usnistgov/macos_security/blob/tahoe_rev3/rules/supplemental/supplemental_smartcard.yaml) [Tahoe Rev. 3 profile](https://github.com/usnistgov/macos_security/blob/tahoe_rev3/includes/com.apple.security.authorization.mobileconfig)
  したがって、profile payload として妥当な表記を `defaults write` へ渡した現在の宣言が同じ効果を持つとは、文面だけでは確定できない。
  調査時点の実機では `/Library/Preferences/com.apple.security.authorization` の domain 全体、`ignoreARD`、`ignoreArd` のいずれも値が存在せず、少なくとも標準的な system-wide preference として反映された形跡はなかった。
  ただし、読み取り domain・scope・preference cache の差があるため、これだけで機能上も無効とは断定しない。
- **判断**: 画面共有または録画中に Touch ID sudo が拒否される状態を用意し、現在の宣言を適用した前後で機能試験する。
  期待どおり効くなら確認記録を残して維持し、bypass が不要なら削除する。
  必要なのに効かない場合だけ、NIST が示す direct defaults の pair または configuration profile で実装する。
- **回答値**: `SYS-05:確認後維持`、`SYS-05:削除`、または `SYS-05:確認後修正`。
- **security trade-off**: macOS は画面が監視/録画中に Touch ID、Watch、smartcard を無効にし、正しく有効化した `ignoreARD` はその保護を回避する。
  Apple も Tahoe 26 の FaceTime remote-control session 中は Touch ID を無効にすると明記している。[Apple FaceTime remote control](https://support.apple.com/en-ie/guide/facetime/fctmebd8481a/mac)
  DisplayLink、Screen Sharing、画面録画中の Touch ID sudo が必要かを確認する。
- **副作用**: 削除または無効のままなら該当状態の生体 sudo が使えない可能性があり、正しく有効化すれば監視中も認証を許して保護を弱める。

### `SYS-06` — PAM Touch ID は維持し、Watch 専用 module は必要時だけ足す

- **カテゴリ**: 現状維持 / 任意追加。
- **優先度 / 確度**: 中 / 高。
- **場所**: `nix/nix-darwin/system.nix:109-112`。
- **判断**: `touchIdAuth=true` と `reattach=true` を維持する。
  lid closed 運用で Touch ID が使えず Watch sudo が必要な場合だけ `watchIdAuth` を検討する。
- **根拠**: nix-darwin は reattach が tmux/screen 内の Touch ID を直すと明記する。[nix-darwin PAM options](https://nix-darwin.github.io/nix-darwin/manual/#opt-security.pam.services.sudo_local.reattach)
- **副作用**: `watchIdAuth` は第三者 `pam-watchid` module を PAM stack へ加えるため、不要なら攻撃面を増やさない。[固定 nix-darwin PAM source](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/security/pam.nix) [pam-watchid](https://github.com/biscuitehh/pam-watchid)
  近くの unlock 済み Watch から承認できる機能自体は Apple の認証機能に基づく。[Apple Watch authorization](https://support.apple.com/en-us/102442)

### `SYS-07` — host identity を local metadata として宣言する

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 低〜中 / 高。
- **場所**: `networking.hostName`、`computerName`、`localHostName` は現在未宣言。
- **推奨**: machine identity も再現したい場合、追跡外 local config に host-specific 値を持たせ、まず CLI/SSH 用 `hostName` を宣言する。
  Sharing UI に別の表示名が欲しければ `computerName`、Bonjour 名を hostName と分けたい場合だけ `localHostName` を加える。
- **根拠**: nix-darwin は 3 名を別々に管理し、`localHostName` は `hostName` を既定値にするため、常に 3 つを明示する必要はない。[nix-darwin networking options](https://nix-darwin.github.io/nix-darwin/manual/#opt-networking.hostName)
- **副作用**: Bonjour、SSH、known_hosts、sharing 名へ影響する。

### `SYS-08` — AeroSpace と macOS native tiling の併用方針を選ぶ

- **カテゴリ**: 追加候補。
- **優先度 / 確度**: 低〜中 / 中。
- **場所**: AeroSpace は導入済みだが、WindowManager の native tiling gesture は未宣言。
- **判断**: AeroSpace へ統一するなら edge drag、top tiling、Option accelerator を false にする。
  native tiling も使うなら現状維持する。
- **根拠**: macOS 26 と nix-darwin はこれらを正式設定として持つ。[Apple window tiling](https://support.apple.com/en-ca/guide/mac-help/mchlef287e5d/mac) [nix-darwin WindowManager options](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.defaults.WindowManager.EnableTilingByEdgeDrag)
- **副作用**: 無効化すると native edge/Option tiling を失うが、AeroSpace 自体には影響しない。

### `SYS-09` — desktop/Dock の重複設定は手動確認後にだけ削る

- **カテゴリ**: 要確認。
- **優先度 / 確度**: 低 / 中〜高。
- **場所**: `nix/nix-darwin/system.nix:24-26,50-52,68,74`。
- **候補**: `WindowManager.StandardHideDesktopIcons=true` と Finder `CreateDesktop=false` は目的が重なるが完全同義とは断定しない。
  `show-recents=false` は `static-only=true` の間、見た目上重複する。
  `ShowRemovableMediaOnDesktop=false` も desktop 全体を隠す現在は見た目に出ないが、将来 desktop item を戻した時の明示的意図として残す価値がある。
- **推奨**: desktop click で一時表示する behavior を手動確認し、最小宣言を望む場合だけ片方を外す。
- **根拠**: Apple の現 UI は desktop item 非表示と desktop click 表示を別に説明する。[Apple Desktop & Dock](https://support.apple.com/en-ie/guide/mac-help/-mchlp1119/mac)
- **副作用**: nix-darwin は option を外しても過去に書いた plist 値を自動 reset しないため、削除直後は差が見えず、将来上位 option を変えた時にだけ差が出る可能性がある。

### `SYS-10` — OS update と Guest login の policy を選ぶ

- **カテゴリ**: security / operations 要確認。
- **優先度 / 確度**: 中 / 高。
- **場所**: `SoftwareUpdate.AutomaticallyInstallMacOSUpdates` と `loginwindow.GuestEnabled` は未宣言。
- **判断**: security update と夜間 restart のどちらを重視するかで OS 自動更新を選ぶ。
  Guest は無 password login 面を閉じるなら false、Find My の利便性を残すなら既定を維持する。
- **回答値**: OS 更新は `update=on` または `update=off`、Guest login は `guest=off` または `guest=default` を組み合わせる。
  たとえば `SYS-10:update=on,guest=off` と指定する。
- **根拠**: Apple は自動 update option と macOS 26 の Background Security Improvements を別設定として説明するため、前者だけで全 security response を管理できるとはみなさない。[Apple Software Update](https://support.apple.com/guide/mac-help/software-update-settings-on-mac-mchla7037245/mac) [Background Security Improvements](https://support.apple.com/guide/mac-help/install-background-security-improvements-mchl44c4c70c/mac)
  Apple は FileVault 下の Guest Safari が Find My に役立つ場合も説明する。[Apple guest users](https://support.apple.com/en-ie/guide/mac-help/mh15600/mac)
- **副作用**: 自動 update は意図しない restart、Guest 無効化は端末発見の一経路を失う可能性がある。

### `SYS-11` — developer 向け defaults は個別選択する

- **カテゴリ**: 便利な追加候補。
- **優先度 / 確度**: 低 / 中。
- **keyboard 候補**: `NSGlobalDomain.ApplePressAndHoldEnabled=false`、`InitialKeyRepeat`、`KeyRepeat`、`AppleKeyboardUIMode=3`。
- **文章入力候補**: `NSAutomaticCapitalizationEnabled=false`、`NSAutomaticDashSubstitutionEnabled=false`、`NSAutomaticQuoteSubstitutionEnabled=false`、`NSAutomaticPeriodSubstitutionEnabled=false`、`NSAutomaticSpellingCorrectionEnabled=false`、`NSAutomaticInlinePredictionEnabled=false`。
- **Finder 候補**: `finder.ShowPathbar=true`、`finder._FXSortFoldersFirst=true`、`finder.FXDefaultSearchScope="SCcf"`、`finder.FXRemoveOldTrashItems=true`。
- **animation 候補**: `universalaccess.reduceMotion=true`。
- **推奨**: 日本語入力を含む全 app へ広く効くため bundle で一括採用せず、欲しいものだけ選ぶ。
- **回答例**: `SYS-11:ShowPathbar,FXRemoveOldTrashItems,reduceMotion`。
- **根拠**: nix-darwin は各 option を typed defaults として提供し、Apple は keyboard behavior を user preference として説明する。[Apple keyboard settings](https://support.apple.com/en-gb/guide/mac-help/kbdm162/mac) [nix-darwin defaults](https://nix-darwin.github.io/nix-darwin/manual/)
- **副作用**: 文章入力、accent 長押し、animation、Finder search、Trash retention が広範に変わる。

### `SYS-12` — `system.stateVersion = 6` は維持する

- **カテゴリ**: 現状維持。
- **優先度 / 確度**: 高 / 高。
- **場所**: `nix/nix-darwin/system.nix:4`。
- **判断**: current maximum 7 へ機械的に上げない。
- **根拠**: nix-darwin も既存 install の stateVersion は通常維持する値としている。
  v7 の互換差は `programs.tmux.enableSensible` の split binding だが、この repo はその module を使わない。[nix-darwin stateVersion](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.stateVersion) [固定中 revision の nix-darwin changelog](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/CHANGELOG)

### `SYS-13` — `system.primaryUser` を維持する

- **カテゴリ**: 現状維持。
- **場所**: `nix/nix-darwin/system.nix:5`。
- **判断**: 将来廃止予定の migration option でも、Homebrew/defaults/PAM など primary-user requiring option を使う現在は外さない。
- **根拠**: 現行 nix-darwin source は必要な option がある場合の assertion を持つ。[primary-user source](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/system/primary-user.nix)

### `SYS-14` — `users.nix` は標準 home なら簡素化できる

- **カテゴリ**: 条件付き削除候補。
- **優先度 / 確度**: 低 / 高。
- **場所**: `nix/nix-darwin/users.nix:1-6`、import `nix/nix-darwin/default.nix:5`。
- **推奨**: attr name と同じ `name` は無条件に冗長である。
  `home` が `/Users/<primaryUser>` の標準形なら module 全体を外せるが、非標準 path を許す local schema を維持したいなら残す。
- **根拠**: user `name` の既定は attr name で、primary user home に標準 fallback がある。[nix-darwin user source](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/users/user.nix) [primary user source](https://github.com/nix-darwin/nix-darwin/blob/15abb8c98f336cd8bd840d71059adebabe60bf04/modules/system/primary-user.nix)
- **副作用**: 将来 non-standard home を使う場合は再導入する。

### `SYS-15` — AeroSpace 用に `spans-displays` を変えるか選ぶ

- **カテゴリ**: 一部維持 / 要確認。
- **優先度 / 確度**: 中〜高 / 高。
- **場所**: `nix/nix-darwin/system.nix:40,42,102-105`。
- **維持**: `autohide=true` と `expose-group-apps=true` は AeroSpace の推奨に合うため維持する。
- **要判断**: 現在の `spans-displays=false` は「Displays have separate Spaces」を有効にする値であり、AeroSpace が安定性のために案内するのは `true` で separate Spaces を無効にする設定である。[AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide#emulation-of-virtual-workspaces) [nix-darwin spaces option](https://nix-darwin.github.io/nix-darwin/manual/#opt-system.defaults.spaces.spans-displays)
- **回答値**: AeroSpace の window spanning/安定性を優先するなら `SYS-15:aerospace` として `true` に変える。
  display ごとの独立 Space と native fullscreen を優先するなら `SYS-15:separate` として現在の `false` を維持する。
- **副作用**: `true` への変更は logout が必要で、複数 display が一つの Space を共有する macOS behavior へ変わる。

## 検証結果

| 検証 | 結果 | 判断への反映 |
| --- | --- | --- |
| `nix --version` | 2.34.8 | 実効 behavior は主に 2.34 manual で判断 |
| sanitized `nix config show --json` | sandbox off、max-jobs 8、keep outputs/derivations on、free-space GC off、署名検証 on | `CORE-01`〜`CORE-10` |
| `nix flake check path:./nix --no-build` | `darwinConfigurations` を含め評価成功 | 現構成は評価可能、`checks` は追加品質 gate |
| `deadnix nix` | 未使用 `self`/`pkgs`/`final`/`lib`/private `inputs` | `FLAKE-06` |
| `statix check nix` | `or`/`inherit`/反復属性などの警告 | behavior change と分けた低優先 cleanup |
| 固定 nixpkgs `direnv` | 通常 derivation を公式 cache から取得成功 | override 解除可能 |
| 固定 nixpkgs `statix` | 通常 derivation を公式 cache から取得成功 | override 解除可能 |
| 固定 nixpkgs `rtk` | 通常 derivation の build/取得成功 | override 解除可能 |
| 固定 nixpkgs `mise` | cache hit せず長時間 local build、監査用単体 test は中断 | 今回は override 解除を断定しない |
| documentation + uninstaller 診断 | `darwin-manual-html` と `darwin-uninstaller` の output が valid store path | 現行 lock で両方復帰可能 |
| Pique upstream | 0.1.0b5 が latest | 現状維持 |
| site2skill PyPI | stable 0.1.1、pre-release 0.2.0b2 | stable へ最小更新 |
| Tree-sitter | 固定 nixpkgs 0.26.9、upstream latest 0.26.11 | custom 0.26.8 は削除 |
| Homebrew official cask API | common/private/work の deprecated/disabled は `codex-app` だけ | 手順付き撤去 |
| 実 home の SOUL.md | `.codex`、`.claude` の両方で欠落 | `FILE-07` で相対参照の実 load を検証 |
| 実機 firewall/clock | firewall off、menu clock analog | `SYS-02`、`SYS-03` |

`nix flake check --no-build` は derivation を実 build しない。
変更を採用する段階では `just check` だけでなく、`just build` で system closure を build してから switch する必要がある。
今回の調査では、system state を変える `switch`、Homebrew cleanup、application uninstall、plist 書換えは行っていない。

## 推奨する判断と実施順

### 0. 先に方針とデータ保護を決める

1. `HM-01` で Home Manager stateVersion の来歴を確定する。
2. `BREW-03` で switch と Homebrew update/cleanup の責務を決める。
3. `BREW-01` で Codex app の移行状態を確認し、関連データを退避する。
4. `SYS-05` で現在の設定の効力を検証し、DisplayLink/画面共有中の Touch ID が必要かを決める。
5. `BREW-06` の roots と `BREW-08` の interactive mas CLI を実際に使うか確認する。

### 1. 小さく、戻しやすい整理を行う

1. `CORE-06`、`CORE-11`、`FLAKE-06` の重複・lint cleanup を行う。
2. `TEMP-01`、`TEMP-02`、`TEMP-03` で解消済み workaround を外す。
3. `PKG-01`、`PKG-02`、`PKG-03`、`PKG-04` で custom package を整理する。
4. `FILE-04`、`FILE-05`、`BREW-02`、`BREW-07` の明確な残骸・重複を外す。

### 2. security と store 運用を強くする

1. `CORE-01` の relaxed sandbox を導入し、cache miss の source build を試す。
2. `CORE-02` の trusted user 縮小と `CORE-03` の unfree allowlist を行う。
3. `CORE-04` の channel 無効化、`CORE-05` の GC/free-space policy を行う。
4. `BREW-04` の item trust と `BREW-05` の im-select hash 固定を行う。
5. `SYS-03` の firewall と `SYS-04` の即時 screen lock を行う。

### 3. state を伴う migration を一件ずつ行う

1. `HM-02` の app copy migration と旧 link cleanup を行う。
2. Herdr を停止して `FILE-02`、Hunk を停止して `FILE-03` を行う。
3. `SHELL-01` の Fish login shell、`SHELL-02` の direnv ownership を切り替える。
4. `BREW-09` の font と、選んだ場合だけ `BREW-08` の MAS module migration を行う。

### 4. architecture と好みの変更を分離する

1. `FLAKE-01`〜`FLAKE-05` は一つの flake modernization change として扱う。
2. `HM-04`、`SHELL-03`〜`SHELL-05` は tool ごとの所有権を丸ごと変える別 task にする。
3. `PKG-08`、`PKG-09`、`BREW-10`、`BREW-11`、`BREW-13`、`BREW-15` は利用実態を本人確認してから一件ずつ削る。
4. `SYS-01`、`SYS-02`、`SYS-07`〜`SYS-11`、`SYS-15` は workflow と好みを確認して個別採用する。

## 適用時の確認項目

変更 batch ごとに次を確認する。

1. `git diff --check` と formatter/lint を通す。
2. `just check` を通す。
3. `just build` を通し、switch 前に closure 差分と build 元を確認する。
4. package source を変えた場合は `command -v` と version を確認する。
5. `just switch` 後に Fish login、direnv、tmux、Yazi、Neovim/LSP、Herdr、Hunk、Crit、Claude、menu bar script を smoke test する。
6. Homebrew cleanup を変えた場合は生成 Brewfile と `brew bundle check` の差分を先に読む。
7. firewall を有効にした場合は LAN service、Screen Sharing、container、local dev server を確認する。
8. app/font migration 後は Spotlight、LaunchServices、Font Book、利用 app を確認する。
9. 一つの batch に state migration と大量 input update を混ぜない。

<!-- nix-audit-answers:start -->
## 判断回答

> [回答UI](./nix-configuration-audit-2026-07-31.html)から更新する。回答済み 84 / 84 件。

| ID | 回答 | 詳細 |
| --- | --- | --- |
| CORE-01 | yes |  |
| CORE-02 | yes |  |
| CORE-03 | yes |  |
| CORE-04 | yes |  |
| CORE-05 | yes |  |
| CORE-06 | yes |  |
| CORE-07 | yes |  |
| CORE-08 | yes |  |
| CORE-09 | yes |  |
| CORE-10 | yes |  |
| CORE-11 | yes |  |
| CORE-12 | yes |  |
| FLAKE-01 | yes |  |
| FLAKE-02 | yes |  |
| FLAKE-03 | yes |  |
| FLAKE-04 | yes |  |
| FLAKE-05 | yes |  |
| FLAKE-06 | yes |  |
| FLAKE-07 | other | 異なるマシンで同じ設定を使っており、その判別を local.nix でやっている。もっといい方法があれば知りたい |
| FLAKE-08 | yes |  |
| FLAKE-09 | yes |  |
| TEMP-01 | yes |  |
| TEMP-02 | yes |  |
| TEMP-03 | yes |  |
| TEMP-04 | yes |  |
| PKG-01 | yes |  |
| PKG-02 | yes |  |
| PKG-03 | other | 使っていないから削除してよい |
| PKG-04 | no |  |
| PKG-05 | other | これも使っていないので削除してよい |
| PKG-06 | no |  |
| PKG-07 | other | A: flake package を維持 |
| PKG-08 | yes |  |
| PKG-09 | no |  |
| PKG-10 | yes |  |
| HM-01 | yes |  |
| HM-02 | yes |  |
| HM-03 | other | HM-01 の結果によって変動する |
| HM-04 | other | ちょっとよくわからない |
| HM-05 | yes |  |
| FILE-01 | yes |  |
| FILE-02 | yes |  |
| FILE-03 | yes |  |
| FILE-04 | yes |  |
| FILE-05 | yes |  |
| FILE-06 | yes |  |
| FILE-07 | no |  |
| SHELL-01 | yes |  |
| SHELL-02 | yes |  |
| SHELL-03 | no |  |
| SHELL-04 | yes |  |
| SHELL-05 | yes |  |
| SHELL-06 | yes |  |
| BREW-01 | yes |  |
| BREW-02 | yes |  |
| BREW-03 | other | A: 現状維持 |
| BREW-04 | yes |  |
| BREW-05 | yes |  |
| BREW-06 | yes |  |
| BREW-07 | yes |  |
| BREW-08 | yes |  |
| BREW-09 | yes |  |
| BREW-10 | no |  |
| BREW-11 | other | brew 版 |
| BREW-12 | yes |  |
| BREW-13 | yes |  |
| BREW-14 | yes |  |
| BREW-15 | other | 現状維持 |
| BREW-16 | yes |  |
| SYS-01 | other | right |
| SYS-02 | no |  |
| SYS-03 | yes |  |
| SYS-04 | yes |  |
| SYS-05 | other | 確認後に維持 |
| SYS-06 | yes |  |
| SYS-07 | no |  |
| SYS-08 | other | 現状維持 |
| SYS-09 | other | 現状維持 |
| SYS-10 | other | 現状維持 |
| SYS-11 | other | 現状維持 |
| SYS-12 | yes |  |
| SYS-13 | yes |  |
| SYS-14 | yes |  |
| SYS-15 | yes |  |

<details>
<summary>回答データ</summary>

```json
{
  "schemaVersion": 1,
  "answers": {
    "CORE-01": "yes",
    "CORE-02": "yes",
    "CORE-03": "yes",
    "CORE-04": "yes",
    "CORE-05": "yes",
    "CORE-06": "yes",
    "CORE-07": "yes",
    "CORE-08": "yes",
    "CORE-09": "yes",
    "CORE-10": "yes",
    "CORE-11": "yes",
    "CORE-12": "yes",
    "FLAKE-01": "yes",
    "FLAKE-02": "yes",
    "FLAKE-03": "yes",
    "FLAKE-04": "yes",
    "FLAKE-05": "yes",
    "FLAKE-06": "yes",
    "FLAKE-07": "other",
    "FLAKE-08": "yes",
    "FLAKE-09": "yes",
    "TEMP-01": "yes",
    "TEMP-02": "yes",
    "TEMP-03": "yes",
    "TEMP-04": "yes",
    "PKG-01": "yes",
    "PKG-02": "yes",
    "PKG-03": "other",
    "PKG-04": "no",
    "PKG-05": "other",
    "PKG-06": "no",
    "PKG-07": "other",
    "PKG-08": "yes",
    "PKG-09": "no",
    "PKG-10": "yes",
    "HM-01": "yes",
    "HM-02": "yes",
    "HM-03": "other",
    "HM-04": "other",
    "HM-05": "yes",
    "FILE-01": "yes",
    "FILE-02": "yes",
    "FILE-03": "yes",
    "FILE-04": "yes",
    "FILE-05": "yes",
    "FILE-06": "yes",
    "FILE-07": "no",
    "SHELL-01": "yes",
    "SHELL-02": "yes",
    "SHELL-03": "no",
    "SHELL-04": "yes",
    "SHELL-05": "yes",
    "SHELL-06": "yes",
    "BREW-01": "yes",
    "BREW-02": "yes",
    "BREW-03": "other",
    "BREW-04": "yes",
    "BREW-05": "yes",
    "BREW-06": "yes",
    "BREW-07": "yes",
    "BREW-08": "yes",
    "BREW-09": "yes",
    "BREW-10": "no",
    "BREW-11": "other",
    "BREW-12": "yes",
    "BREW-13": "yes",
    "BREW-14": "yes",
    "BREW-15": "other",
    "BREW-16": "yes",
    "SYS-01": "other",
    "SYS-02": "no",
    "SYS-03": "yes",
    "SYS-04": "yes",
    "SYS-05": "other",
    "SYS-06": "yes",
    "SYS-07": "no",
    "SYS-08": "other",
    "SYS-09": "other",
    "SYS-10": "other",
    "SYS-11": "other",
    "SYS-12": "yes",
    "SYS-13": "yes",
    "SYS-14": "yes",
    "SYS-15": "yes"
  },
  "details": {
    "FLAKE-07": "異なるマシンで同じ設定を使っており、その判別を local.nix でやっている。もっといい方法があれば知りたい",
    "PKG-03": "使っていないから削除してよい",
    "PKG-05": "これも使っていないので削除してよい",
    "PKG-07": "A: flake package を維持",
    "HM-03": "HM-01 の結果によって変動する",
    "HM-04": "ちょっとよくわからない",
    "BREW-03": "A: 現状維持",
    "BREW-11": "brew 版",
    "BREW-15": "現状維持",
    "SYS-01": "right",
    "SYS-05": "確認後に維持",
    "SYS-08": "現状維持",
    "SYS-09": "現状維持",
    "SYS-10": "現状維持",
    "SYS-11": "現状維持"
  }
}
```

</details>
<!-- nix-audit-answers:end -->

## 全判断 ID の既定提案

### 変更として採用を勧める

- `CORE-01`, `CORE-02`, `CORE-03`, `CORE-04`, `CORE-05`, `CORE-06`, `CORE-11`
- `FLAKE-02`, `FLAKE-03`, `FLAKE-04`, `FLAKE-05`, `FLAKE-06`, `FLAKE-07`
- `TEMP-01`, `TEMP-02`, `TEMP-03`
- `PKG-01`, `PKG-02`, `PKG-03`, `PKG-04`
- `HM-02`, `HM-03`
- `FILE-02`, `FILE-03`, `FILE-04`, `FILE-05`
- `SHELL-01`, `SHELL-02`
- `BREW-02`, `BREW-04`, `BREW-05`, `BREW-07`, `BREW-09`, `BREW-12`
- `SYS-03`, `SYS-04`

`CORE-01`〜`CORE-05`、`BREW-04`〜`BREW-05`、`SYS-03`〜`SYS-04` は推奨だが、security/operations behavior を変えるため別 batch にする。
`HM-03` は `HM-01` の結果として stateVersion 24.11 を維持する場合だけ採用する。

### 先に本人判断が必要

- `CORE-07`, `CORE-08`
- `FLAKE-01`
- `TEMP-04`
- `PKG-06`, `PKG-07`, `PKG-08`, `PKG-09`
- `HM-01`, `HM-04`
- `FILE-01`, `FILE-06`, `FILE-07`
- `SHELL-03`, `SHELL-04`
- `BREW-01`, `BREW-03`, `BREW-06`, `BREW-08`, `BREW-10`, `BREW-11`, `BREW-13`, `BREW-15`
- `SYS-01`, `SYS-02`, `SYS-05`, `SYS-07`, `SYS-08`, `SYS-09`, `SYS-10`, `SYS-11`, `SYS-14`, `SYS-15`

### 実装制約であり選択不要

- `SHELL-06`: tool module へ移行する場合、parent directory link と managed child を部分混在させない。

### 現状維持を勧める

- `CORE-09`, `CORE-10`, `CORE-12`
- `FLAKE-08`, `FLAKE-09` の Crit URL と Hunk pin の目的
- `PKG-05`, `PKG-10`
- `HM-05`
- `SHELL-05`
- `BREW-14`, `BREW-16`
- `SYS-06`, `SYS-12`, `SYS-13`

## 調査上の限界

- repo 内参照がない CLI/GUI でも、対話的に使っている可能性は除外できない。
- `nix/local.nix` の host-specific 値は本書へ掲載していない。
- Homebrew third-party tap は upstream repository の現在内容を確認したが、将来の変更までは保証できない。
- Web で確認した version、cask status、option は 2026-07-31 時点の情報である。
- macOS defaults は option を宣言から外しても過去の plist 値が戻らないことがあるため、削除と reset は分けて考える。
- mise の通常 derivation は監査時間内に build 完了しなかったため、test workaround の解除可否だけ確度を下げた。
- 実効 Nix 設定、firewall/clock/home file 欠落などの実機観測値を public repository へ commit する場合は、公開してよい情報かを先に確認する。

## 主要な一次資料

- [Nix reference manuals](https://nix.dev/manual/nix)
- [Nix Flakes](https://nix.dev/concepts/flakes.html)
- [Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/unstable/)
- [nix-darwin README](https://github.com/nix-darwin/nix-darwin/blob/master/README.md)
- [nix-darwin option reference](https://nix-darwin.github.io/nix-darwin/manual/)
- [Home Manager option reference](https://nix-community.github.io/home-manager/options.html)
- [Home Manager upgrade guide](https://nix-community.github.io/home-manager/usage/upgrading.html)
- [Homebrew Bundle documentation](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [Homebrew Tap Trust](https://docs.brew.sh/Tap-Trust)
- [Apple macOS User Guide](https://support.apple.com/guide/mac-help/welcome/mac)
- [AeroSpace Guide](https://nikitabobko.github.io/AeroSpace/guide)
- [Pique releases](https://github.com/macadmins/pique/releases)
- [site2skill on PyPI](https://pypi.org/project/site2skill/)
- [Tree-sitter releases](https://github.com/tree-sitter/tree-sitter/releases)
