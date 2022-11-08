#!/bin/sh
# vim:sw=4:ts=4:et
# https://github.com/nginxinc/docker-nginx/tree/fef51235521d1cdf8b05d8cb1378a526d2abf421/stable/alpine

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[FTP] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[FTP - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[FTP - Configuration] $@ : complete ✅ "
        echo ""
    fi
}



