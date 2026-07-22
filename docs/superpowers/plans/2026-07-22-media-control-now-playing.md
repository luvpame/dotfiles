# macOS Now Playing Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Spotify または Dia が macOS の Now Playing へ公開している再生中メディアをメニューバーへ表示する。

**Architecture:** `media-control` から現在の Now Playing セッションを JSON で一度だけ取得する。`jq` で再生状態と bundle identifier を絞り込み、既存の表示形式へ整形する。

**Tech Stack:** Bash、jq、Homebrew、Nix Darwin

## Global Constraints

- 対象アプリは bundle identifier が `com.spotify.client` または `company.thebrowser.dia` のものに限定する。
- Spotify と Dia の同時再生時は macOS が現在の Now Playing として選んだ側を表示する。
- 停止中、一時停止中、対象外アプリ、コマンド失敗時は何も出力しない。
- `media-control` は固定済み nixpkgs に存在しないため Homebrew formula で管理する。
- 既存の無関係な作業ツリー変更には触れない。

---

### Task 1: Now Playing 情報の統合

**Files:**
- Create: `menubar-script/media/test-read-state.sh`
- Modify: `menubar-script/media/read-state.sh`
- Modify: `nix/nix-darwin/homebrew/common.nix`

**Interfaces:**
- Consumes: `media-control get --no-artwork` の JSON 出力と `jq`。
- Produces: 再生中なら `▶ <title> - <artist>`、それ以外なら空出力。

- [ ] **Step 1: 期待する振る舞いを表す失敗テストを書く**

```bash
#!/bin/bash

set -euo pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly target="$script_dir/read-state.sh"

media-control() {
  if [[ "${MEDIA_CONTROL_FAIL:-false}" == "true" ]]; then
    return 1
  fi

  [[ "$*" == "get --no-artwork" ]] || return 2

  printf '%s\n' "${MEDIA_CONTROL_RESPONSE:-null}"
}
export -f media-control

assert_output() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local actual

  actual="$(MEDIA_CONTROL_RESPONSE="$response" "$target")"

  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL: %s\nexpected: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_output \
  "Spotify の再生を表示する" \
  "▶ Song - Artist" \
  '{"playing":true,"bundleIdentifier":"com.spotify.client","title":"Song","artist":"Artist"}'
assert_output \
  "Dia の再生を表示する" \
  "▶ Mix - DJ" \
  '{"playing":true,"bundleIdentifier":"company.thebrowser.dia","title":"Mix","artist":"DJ"}'
assert_output \
  "一時停止中は表示しない" \
  "" \
  '{"playing":false,"bundleIdentifier":"com.spotify.client","title":"Song","artist":"Artist"}'
assert_output \
  "対象外アプリは表示しない" \
  "" \
  '{"playing":true,"bundleIdentifier":"com.apple.Music","title":"Song","artist":"Artist"}'
assert_output \
  "メタデータがなければフォールバックを表示する" \
  "▶ Playing" \
  '{"playing":true,"bundleIdentifier":"company.thebrowser.dia","title":null,"artist":null}'

actual="$(MEDIA_CONTROL_FAIL=true "$target")"
if [[ -n "$actual" ]]; then
  printf 'FAIL: 取得失敗時は空出力\nactual: <%s>\n' "$actual" >&2
  exit 1
fi

printf 'PASS\n'
```

- [ ] **Step 2: テストが未実装の振る舞いで失敗することを確認する**

Run: `./menubar-script/media/test-read-state.sh`

Expected: `FAIL: Spotify の再生を表示する` と表示して終了コード 1。

- [ ] **Step 3: `media-control` を Homebrew 管理へ追加する**

`nix/nix-darwin/homebrew/common.nix` の `commonBrews` に追加する。

```nix
"media-control" # macOS Now Playing metadata
```

- [ ] **Step 4: Now Playing の取得と表示を最小実装する**

`menubar-script/media/read-state.sh` を次の責務に絞る。

```bash
#!/bin/bash

set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

if ! command -v media-control >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

normalize_text() {
  printf '%s' "$1" \
    | tr '\r\n' '  ' \
    | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

format_playing_line() {
  local title="$1"
  local artist="$2"
  local summary="Playing"

  if [[ -n "$title" && -n "$artist" ]]; then
    summary="$title - $artist"
  elif [[ -n "$title" ]]; then
    summary="$title"
  elif [[ -n "$artist" ]]; then
    summary="$artist"
  fi

  printf '▶ %s\n' "$summary"
}

player_state="$(
  media-control get --no-artwork 2>/dev/null \
    | jq -r '
        select(
          .playing == true
          and (
            .bundleIdentifier == "com.spotify.client"
            or .bundleIdentifier == "company.thebrowser.dia"
          )
        )
        | "playing", (.title // ""), (.artist // "")
      ' 2>/dev/null \
    || true
)"

if [[ -z "$player_state" ]]; then
  exit 0
fi

title="$(printf '%s\n' "$player_state" | sed -n '2p')"
artist="$(printf '%s\n' "$player_state" | sed -n '3p')"

format_playing_line "$(normalize_text "$title")" "$(normalize_text "$artist")"
```

- [ ] **Step 5: テストと静的検証を実行する**

Run: `./menubar-script/media/test-read-state.sh`

Expected: `PASS`、終了コード 0。

Run: `bash -n menubar-script/media/read-state.sh menubar-script/media/test-read-state.sh`

Expected: 出力なし、終了コード 0。

Run: `nixfmt --check nix/nix-darwin/homebrew/common.nix`

Expected: 出力なし、終了コード 0。

Run: `git diff --check`

Expected: 出力なし、終了コード 0。

- [ ] **Step 6: 変更をコミットする**

```bash
git add \
  docs/superpowers/plans/2026-07-22-media-control-now-playing.md \
  menubar-script/media/read-state.sh \
  menubar-script/media/test-read-state.sh \
  nix/nix-darwin/homebrew/common.nix
git commit -m "feat(media): macOS の再生状態を統合する"
```
