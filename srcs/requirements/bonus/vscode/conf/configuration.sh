#!/bin/sh
# vim:sw=4:ts=4:et

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[VSCODE] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[VSCODE - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[VSCODE - Configuration] $@ : complete ✅ "
        echo ""
    fi
}


entrypoint_log "$ME: setup vscode 🔍 "
## apt update && apt install -y gnome-keyring

# wget -O- 'https://aka.ms/install-vscode-server/setup.sh' | sh
curl -fsSL https://code-server.dev/install.sh | sh

## vi ~/.config/code-server/config.yaml
## dbus-run-session -- sh -c "(echo 'somecredstorepass' | gnome-keyring-daemon --unlock) && code-server serve-local --host 0.0.0.0"
# check_error "$ME: setup vscode"



