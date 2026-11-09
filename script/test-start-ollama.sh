#!/bin/bash
set -euo pipefail

test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT
export test_dir

launchctl() { printf '%s\n' "$*" >>"$test_dir/calls"; }
pgrep() { test -e "$test_dir/running"; }
pkill() {
    if [[ ! -e "$test_dir/stuck" ]]; then
        rm "$test_dir/running"
    fi
}
sleep() { :; }
open() { printf '%s\n' "$*" >>"$test_dir/calls"; }
export -f launchctl pgrep pkill sleep open

launcher="$(cd "$(dirname "$0")" && pwd)/start-ollama.sh"
expected=$'setenv OLLAMA_ORIGINS chrome-extension://bpoadfkcbjbfhfodiogcnhhhpibjhbnh\n-g -a Ollama'

bash "$launcher"
[[ "$(cat "$test_dir/calls")" == "$expected" ]]

rm "$test_dir/calls"
touch "$test_dir/running"
bash "$launcher"
[[ ! -e "$test_dir/running" ]]
[[ "$(cat "$test_dir/calls")" == "$expected" ]]

rm "$test_dir/calls"
touch "$test_dir/running" "$test_dir/stuck"
if bash "$launcher" 2>"$test_dir/error"; then
    printf '%s\n' 'Expected failure when Ollama cannot exit.' >&2
    exit 1
fi
[[ "$(cat "$test_dir/calls")" == 'setenv OLLAMA_ORIGINS chrome-extension://bpoadfkcbjbfhfodiogcnhhhpibjhbnh' ]]
[[ -s "$test_dir/error" ]]
printf '%s\n' 'PASS: stopped, running, and unresponsive Ollama'
