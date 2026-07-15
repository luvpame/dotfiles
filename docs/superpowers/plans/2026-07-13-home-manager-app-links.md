# Home Manager アプリリンク Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Home Manager の GUI アプリを `~/Applications` 直下へリンクし、Raycast と Spotlight から検索可能にする。

**Architecture:** Home Manager の既存の `~/Applications/Home Manager Apps` をアプリの正とする。リンク生成後に実行する activation が、その直下の各 `.app` へのリンクを `~/Applications` 直下に作成し、Launch Services へ登録する。

**Tech Stack:** Nix Flakes、nix-darwin、Home Manager、macOS Launch Services

## Global Constraints

- Pique を含む既存および将来の `home.packages` 内の GUI アプリへ共通で適用する。
- 同名の既存アプリは上書きしない。
- Nix が管理する既存リンクだけを更新する。
- 新規依存は追加しない。

---

### Task 1: アプリリンク activation を追加する

**Files:**
- Modify: `nix/nix-darwin/home-manager/default.nix`

**Interfaces:**
- Consumes: `~/Applications/Home Manager Apps/*.app`。
- Produces: `~/Applications/<アプリ名>.app` と Launch Services の登録。

- [ ] **Step 1: 現在の配置が検索対象外であることを確認する**

Run:

```bash
test ! -e "$HOME/Applications/Pique.app"
test -L "$HOME/Applications/Home Manager Apps/Pique.app"
```

Expected: どちらも正常終了する。

- [ ] **Step 2: Home Manager モジュールへ activation を追加する**

引数へ `lib` を加え、ユーザー設定ブロックへ次を追加する。

```nix
        home.activation.linkApplications = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          apps="$HOME/Applications"
          source="$apps/Home Manager Apps"
          lsregister=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

          for app in "$source"/*.app; do
            [ -e "$app" ] || continue

            link="$apps/$(basename "$app")"
            if [ ! -e "$link" ]; then
              ln -s "$app" "$link"
              "$lsregister" -f "$link"
            fi
          done
        '';
```

- [ ] **Step 3: Nix フォーマットを適用する**

Run: `nixfmt nix/nix-darwin/home-manager/default.nix`

Expected: 正常終了する。

- [ ] **Step 4: flake 評価を確認する**

Run: `just check`

Expected: `nix flake check` が正常終了する。

- [ ] **Step 5: switch とリンク生成を確認する**

Run:

```bash
just switch
test -L "$HOME/Applications/Pique.app"
open -Ra Pique
```

Expected: すべて正常終了する。

- [ ] **Step 6: コミットする**

```bash
git add nix/nix-darwin/home-manager/default.nix
git commit -m "feat(home-manager): アプリを検索可能にする"
```

## セルフレビュー

- `home.packages` の全 `.app` を対象にするため、将来追加するアプリもリンクされる。
- 既存の同名アプリは `-e` 判定で保護される。
- Launch Services の登録によって Spotlight のアプリ検索へ反映する。
