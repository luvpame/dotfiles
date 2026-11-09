#!/bin/bash
set -euo pipefail

launchctl setenv OLLAMA_ORIGINS 'chrome-extension://bpoadfkcbjbfhfodiogcnhhhpibjhbnh'

# ログイン項目が先に起動した Ollama にも、新しい許可設定を読み込ませる。
if pgrep -x Ollama >/dev/null; then
    pkill -TERM -x Ollama
    for _ in {1..50}; do
        if ! pgrep -x Ollama >/dev/null; then
            break
        fi
        sleep 0.1
    done
    if pgrep -x Ollama >/dev/null; then
        printf '%s\n' 'Ollama did not exit; refusing to launch with stale settings.' >&2
        exit 1
    fi
fi

open -g -a Ollama
