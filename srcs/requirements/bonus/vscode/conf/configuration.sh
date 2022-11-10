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


# if [ -n "${PASSWORD}" ] || [ -n "${HASHED_PASSWORD}" ]; then
#     AUTH="password"
# else
#     AUTH="none"
#     echo "starting with no password"
# fi
# if [ -z ${PROXY_DOMAIN+x} ]; then
#     PROXY_DOMAIN_ARG=""
# else
#     PROXY_DOMAIN_ARG="--proxy-domain=${PROXY_DOMAIN}"
# fi
# sh \
#     /app/code-server/lib/node \
#         --/app/code-server
#         --bind-addr 0.0.0.0:8443 \
#         --user-data-dir /config/data \
#         --extensions-dir /config/extensions \
#         --disable-telemetry \
#         --auth "${AUTH}" \
#         "${PROXY_DOMAIN_ARG}" \
#         "${DEFAULT_WORKSPACE:-/config/workspace}"

wget -O- 'https://aka.ms/install-vscode-server/setup.sh' | sh
# curl -fsSL https://code-server.dev/install.sh | sh

# check_error "$ME: setup vscode"



