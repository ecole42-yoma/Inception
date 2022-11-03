#!/bin/sh
# vim:sw=4:ts=4:et
# https://github.com/nginxinc/docker-nginx/tree/fef51235521d1cdf8b05d8cb1378a526d2abf421/stable/alpine

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[ADMINER] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[ADMINER - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[ADMINER - Configuration] $@ : complete ✅ "
        echo ""
    fi
}


entrypoint_log "$ME: setting default conf : /etc/php8/php-fpm.d/www.conf 🔍 "
sed -i "/listen = /c\listen = 0.0.0.0:8080" /etc/php8/php-fpm.d/www.conf
check_error "$ME: setting default conf : /etc/php8/php-fpm.d/www.conf"



