#!/bin/sh
# vim:sw=4:ts=4:et
# https://github.com/nginxinc/docker-nginx/tree/fef51235521d1cdf8b05d8cb1378a526d2abf421/stable/alpine

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[WORDPRESS] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[WORDPRESS - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[WORDPRESS - Configuration] $@ : complete ✅ "
        echo ""
    fi
}


entrypoint_log "$ME: setting default conf : /etc/php8/php-fpm.d/www.conf 🔍 "
sed -i "/listen = /c\listen = 0.0.0.0:9000" /etc/php8/php-fpm.d/www.conf
check_error "$ME: setting default conf : /etc/php8/php-fpm.d/www.conf"





entrypoint_log "$ME: install wordpress, setting 🔍 "
if [ $(find $WORDPRESS_PATH -follow -type f -print | wc -l) -eq 0 ]
then

    entrypoint_log "wp-cli core download 🔍 "
    wp-cli core download --path=$WORDPRESS_PATH

    entrypoint_log "wp-cli config create 🔍 "
    wp-cli config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$BACK_NETWORK --path=$WORDPRESS_PATH

    entrypoint_log "wp-cli core install 🔍 "
    wp-cli core install --url=https://$DOMAIN_NAME --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --path=$WORDPRESS_PATH

    entrypoint_log "wp-cli user create 🔍 "
    wp-cli user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=$WORDPRESS_USER_ROLE --user_pass=$WORDPRESS_USER_PASSWORD --path=$WORDPRESS_PATH
else
# already installed
    entrypoint_log "$ME: already installed wordpress : try update"

    entrypoint_log "wp-cli core update 🔍 "
    wp-cli core update --path=$WORDPRESS_PATH

    entrypoint_log "wp-cli core update-db 🔍 "
    wp-cli core update-db --path=$WORDPRESS_PATH
fi
check_error "$ME: install wordpress, setting"



entrypoint_log "$ME: create directory : /usr/logs/php-fpm 🔍 "
# start php-fpm
mkdir -p /usr/logs/php-fpm
check_error "$ME: create directory : /usr/logs/php-fpm"



echo ""
