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
mkdir -p /app/code-server
if [ ! -f .check_linux ]
then
    entrypoint_log "$ME: code-server not found, downloading it 📥 "
    wget    https://github.com/coder/code-server/releases/download/v4.8.3/code-server-4.8.3-linux-amd64.tar.gz
    tar xf code-server-4.8.3-linux-amd64.tar.gz -C /app/code-server --strip-components=1

    # wget    https://github.com/coder/code-server/releases/download/v4.8.3/code-server-4.8.3-linux-arm64.tar.gz
    # tar xf code-server-4.8.3-linux-arm64.tar.gz -C /app/code-server --strip-components=1

    # wget    https://github.com/coder/code-server/releases/download/v4.8.3/code-server-4.8.3-linux-armv7l.tar.gz
    # tar xf code-server-4.8.3-linux-armv7l.tar.gz -C /app/code-server --strip-components=1

    ln -s /app/code-server/bin/code-server /usr/bin/code-server
    touch .check_linux
else
    entrypoint_log "$ME: code-server already installed"
fi



# mkdir /var/lib/code-server



# wget -O- 'https://aka.ms/install-vscode-server/setup.sh' | sh
# curl -fsSL https://code-server.dev/install.sh | sh


# check_error "$ME: setup vscode"



