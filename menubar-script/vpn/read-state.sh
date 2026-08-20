#!/bin/bash

set -euo pipefail

home_dir="${HOME:-}"
user_name="${USER:-${LOGNAME:-}}"

if [[ -z "$home_dir" || -z "$user_name" ]]; then
  exit 0
fi

PATH="$home_dir/.nix-profile/bin:/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

if ! command -v scutil >/dev/null 2>&1; then
  exit 0
fi

vpn_services="$(scutil --nc list 2>/dev/null)" || exit 0

has_connected=false
has_connecting=false
has_disconnecting=false
has_disconnected=false

while IFS= read -r line; do
  [[ "$line" == *"[VPN:"* ]] || continue

  case "$line" in
    *"(Connected)"*)
      has_connected=true
      ;;
    *"(Connecting)"*)
      has_connecting=true
      ;;
    *"(Disconnecting)"*)
      has_disconnecting=true
      ;;
    *"(Disconnected)"*)
      has_disconnected=true
      ;;
  esac
done <<< "$vpn_services"

if [[ "$has_connected" == true ]]; then
  printf '🔒 VPN 接続中\n'
elif [[ "$has_connecting" == true ]]; then
  printf '⏳ VPN 接続処理中\n'
elif [[ "$has_disconnecting" == true ]]; then
  printf '⏳ VPN 切断処理中\n'
elif [[ "$has_disconnected" == true ]]; then
  printf '🔓 VPN 未接続\n'
fi
