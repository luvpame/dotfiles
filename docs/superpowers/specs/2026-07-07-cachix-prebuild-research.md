# Cachix 事前ビルド調査

調査日：2026-07-07

## 結論

`just us` の前に Cachix のキャッシュを効かせたいなら、ローカルで `nix flake update` して即 `switch` する運用をやめる必要がある。

推奨形は、CI が定期的に `nix flake update` し、build 成功後だけ `flake.lock` を更新して Cachix に push する運用である。

ローカルでは更新済みの `flake.lock` を取り込み、`just switch` 相当を実行する。

無料運用を優先するなら、毎時実行ではなく 6 時間に 1 回と手動実行の併用から始める。

## 現状

このリポジトリの `just us` は `update-and-switch` の alias である。

`update-and-switch` は `update` の後に `switch` を実行する。

```sh
nix flake update
nh darwin switch path:. -H $(nix eval --file local.nix darwinConfigName --raw)
```

Cachix のキャッシュは derivation と input が一致しているときに効く。

そのため、CI が古い `flake.lock` を build していても、ローカルの `just us` がその場で `flake.lock` を更新するとキャッシュヒットしない。

## 調査した運用パターン

**CI で build して Cachix に push する。**

`cachix/cachix-action` と `cachix/install-nix-action` を使い、`nix build .#darwinConfigurations.<host>.system` を GitHub Actions 上で実行する。

build 成果物は Cachix に push される。

ローカルは同じ `flake.lock` で `switch` すれば、build 済みの path を取得できる。

**定期実行で `flake.lock` も更新する。**

GitHub Actions の `schedule` で `nix flake update` を実行する。

`flake.lock` に差分がなければ終了する。

差分がある場合だけ build し、成功後に Cachix へ push して `flake.lock` を commit する。

main へ直接 push する場合でも、build 成功前に lock を push しない。

**ローカルで build して Cachix に push する。**

`nix build --no-link --print-out-paths ... | cachix push <cache>` でも同じことはできる。

ただし、今回の目的は switch 前のローカル待ち時間を減らすことなので、この方法の効果は小さい。

## 推奨運用

初期値は次の形にする。

```yaml
on:
  schedule:
    - cron: "17 */6 * * *"
  workflow_dispatch:
```

毎時 0 分は GitHub Actions の混雑で遅延や drop が起きやすいため、17 分にずらす。

毎時実行したい場合は、cron を `"17 * * * *"` に変えればよい。

ただし、無料運用では 6 時間に 1 回で始める。

CI の処理順は次のとおりにする。

1. `nix flake update` を実行する。
2. `flake.lock` に差分がなければ終了する。
3. `nix build --no-link .#darwinConfigurations.<host>.system` を実行する。
4. build 成功後に Cachix へ push する。
5. build 成功後だけ `flake.lock` を main に commit して push する。

ローカルでは `just us` ではなく、更新済みの `flake.lock` を取り込んで `just switch` を使う。

## 無料枠での注意

公開リポジトリなら、GitHub Actions の標準 hosted runner は料金面で有利である。

非公開リポジトリでは macOS runner の実行時間が無料枠を消費する。

Cachix は open source projects 向けに無料枠があるが、容量上限が実質的な制約になる。

調査時点では free cache は 5 GB で、容量が 85% に達したときと上限到達時に通知される。

`nixos-unstable`、`home-manager`、`yazi`、`claude-code-overlay` は頻繁に変わるため、毎時 build は容量を押しやすい。

無料運用では、差分なしなら即終了し、容量が増え始めたら頻度を毎日へ落とす。

## 参考リンク

公式情報：

- Cachix Action: <https://github.com/cachix/cachix-action>
- Cachix pushing docs: <https://docs.cachix.org/pushing>
- Cachix FAQ: <https://docs.cachix.org/faq>
- nix.dev GitHub Actions CI guide: <https://nix.dev/guides/recipes/continuous-integration-github-actions.html>
- GitHub Actions schedule docs: <https://docs.github.com/actions/using-workflows/events-that-trigger-workflows#schedule>

事例：

- ryota2357 dotfiles 事例: <https://ryota2357.com/blog/2025/dotfiles-nix-gh-action-build-and-update/>
- malob/nix-config CI 事例: <https://github.com/malob/nix-config/blob/master/.github/workflows/ci.yml>
