#!/bin/bash
set -euo pipefail

version=0.17.0
runtime="${VOICEVOX_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/voicevox/$version}"
accept_terms=false
dry_run=false

for arg in "$@"; do
  case "$arg" in
    --accept-terms) accept_terms=true ;;
    --dry-run) dry_run=true ;;
    *) printf '不明な引数: %s\n使い方: bash setup.sh [--accept-terms] [--dry-run]\n' "$arg" >&2; exit 2 ;;
  esac
done

if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  printf 'macOSのApple Siliconで実行してください。\n' >&2
  exit 1
fi
command -v uv > /dev/null
command -v curl > /dev/null

printf 'VOICEVOX Core %s / 基本モデル 0.vvm\n保存先: %s\n' "$version" "$runtime"
if "$dry_run"; then
  exit 0
fi
if [[ -f "$runtime/models/vvms/0.vvm" &&
      -f "$runtime/dict/open_jtalk_dic_utf_8-1.11/sys.dic" &&
      -f "$runtime/onnxruntime/lib/libvoicevox_onnxruntime.1.23.2.dylib" ]]; then
  printf '導入済みです。\n'
  exit 0
fi
if [[ -e "$runtime" || -L "$runtime" ]]; then
  printf '保存先に不完全な環境があります。VOICEVOX_HOMEで別の保存先を指定してください。\n' >&2
  exit 1
fi

mkdir -p "$(dirname "$runtime")"
staging="$(mktemp -d "${runtime}.tmp.XXXXXX")"
trap 'rm -rf "$staging"' EXIT
curl -fsSL --retry 2 \
  "https://github.com/VOICEVOX/voicevox_core/releases/download/$version/download-osx-arm64" \
  -o "$staging/download"
chmod +x "$staging/download"
download_args=(--exclude c-api --onnxruntime-version 1.23.2 --models-version "$version" --models-pattern 0.vvm --output "$staging")
if "$accept_terms"; then
  printf 'y\n' | "$staging/download" "${download_args[@]}"
else
  "$staging/download" "${download_args[@]}"
fi

# mvは既存ディレクトリの内側へ移動するため、renameで競合時の混入を防ぐ。
uv run --no-project --python 3.13 python -c 'import os,sys; os.rename(sys.argv[1], sys.argv[2])' "$staging" "$runtime"
printf '導入完了: %s\n' "$runtime"
