#!/bin/bash

set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

if [[ "$#" -ne 1 ]]; then
  exit 0
fi

target="$1"
if [[ ! "$target" =~ ^[A-Za-z0-9][A-Za-z0-9_.:-]*$ ]]; then
  exit 0
fi

if ! command -v herdr >/dev/null 2>&1 || ! command -v open >/dev/null 2>&1; then
  exit 0
fi

if ! herdr agent focus "$target" >/dev/null 2>&1; then
  exit 0
fi

open -a WezTerm >/dev/null 2>&1 || true
