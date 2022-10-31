#!/bin/sh
# vim:sw=4:ts=4:et
# https://github.com/nginxinc/docker-nginx/tree/fef51235521d1cdf8b05d8cb1378a526d2abf421/stable/alpine

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${WORDPRESS_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[WORDPRESS] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[MARIADB - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[MARIADB - Configuration] $@ : complete ✅ "
        echo ""
    fi
}





entrypoint_log "$ME: create directory : /usr/html 🔍 "
if [ ! -d /usr/html ] ; then
	echo "[i] Creating directories..."
	mkdir -p /usr/html
	echo "[i] Fixing permissions..."
	# chown -R nginx:nginx /usr/html
	# chown -R www-data:www-data /usr/html
else
	echo "[i] Fixing permissions..."
	# chown -R nginx:nginx /usr/html
	# chown -R www-data:www-data /usr/html
fi
check_error "$ME: create directory : /usr/html"




entrypoint_log "$ME: create directory : /usr/logs/php-fpm 🔍 "
# start php-fpm
mkdir -p /usr/logs/php-fpm
check_error "$ME: create directory : /usr/logs/php-fpm"






entrypoint_log "$ME: configuration step is all done ✨ "
echo ""
