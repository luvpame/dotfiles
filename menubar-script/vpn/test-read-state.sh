#!/bin/bash

set -euo pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly target="$script_dir/read-state.sh"

scutil() {
  if [[ "${SCUTIL_FAIL:-false}" == "true" ]]; then
    return 1
  fi

  [[ "$*" == "--nc list" ]] || return 2

  printf '%s\n' "${SCUTIL_RESPONSE:-}"
}
export -f scutil

assert_output() {
  local description="$1"
  local expected="$2"
  local response="$3"
  local actual

  actual="$(SCUTIL_RESPONSE="$response" "$target")"

  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL: %s\nexpected: <%s>\nactual: <%s>\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_output \
  "接続中のVPNを表示する" \
  "🔒 VPN 接続中" \
  '* (Connected) 001 VPN (com.example.vpn) "Work" [VPN:com.example.vpn]'
assert_output \
  "接続中のVPNがあれば他の状態より優先する" \
  "🔒 VPN 接続中" \
  $'* (Disconnected) 001 VPN (com.example.off) "Off" [VPN:com.example.off]\n* (Connecting) 002 VPN (com.example.connecting) "Connecting" [VPN:com.example.connecting]\n* (Connected) 003 VPN (com.example.on) "On" [VPN:com.example.on]'
assert_output \
  "ConnectingをDisconnectingより優先する" \
  "⏳ VPN 接続処理中" \
  $'* (Disconnected) 001 VPN (com.example.off) "Off" [VPN:com.example.off]\n* (Disconnecting) 002 VPN (com.example.disconnecting) "Disconnecting" [VPN:com.example.disconnecting]\n* (Connecting) 003 VPN (com.example.connecting) "Connecting" [VPN:com.example.connecting]'
assert_output \
  "Disconnectingを未接続より優先する" \
  "⏳ VPN 切断処理中" \
  $'* (Disconnected) 001 VPN (com.example.off) "Off" [VPN:com.example.off]\n* (Disconnecting) 002 VPN (com.example.disconnecting) "Disconnecting" [VPN:com.example.disconnecting]'
assert_output \
  "Connectingを表示する" \
  "⏳ VPN 接続処理中" \
  '* (Connecting) 001 VPN (com.example.connecting) "Connecting" [VPN:com.example.connecting]'
assert_output \
  "未接続のVPNを表示する" \
  "🔓 VPN 未接続" \
  '* (Disconnected) 001 VPN (com.example.vpn) "Work" [VPN:com.example.vpn]'
assert_output \
  "VPN以外の接続サービスを無視する" \
  "" \
  '* (Connected) 001 Ethernet (com.example.ethernet) "Ethernet" [Ethernet:com.example.ethernet]'
assert_output \
  "VPNサービスがなければ空出力にする" \
  "" \
  'Network Connection Services in the current set (*=enabled):'

actual="$(SCUTIL_FAIL=true "$target")"
if [[ -n "$actual" ]]; then
  printf 'FAIL: 取得失敗時は空出力\nactual: <%s>\n' "$actual" >&2
  exit 1
fi

printf 'PASS\n'
