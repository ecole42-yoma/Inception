# nginx
# stable version for legacy
FROM alpine:3.14

STOPSIGNAL SIGINT

EXPOSE 8080

# HEALTHCHECK --interval=1s --timeout=2s --start-period=30s --retries=30 \
#             CMD [ "nc", "-z", "localhost", "9000" ]

RUN apk add --no-cache \
    mariadb-client \
    php8 \
    php8-fpm \
    php8-phar \
    php8-json \
    php8-session \
    php8-mysqli \
    php8-curl && \
    ln -s /usr/bin/php8 /usr/bin/php && \
    mkdir -p /docker-entrypoint.d /var/www/adminer && \
    rm -rf /var/cache/apk/*

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

ADD https://www.adminer.org/latest-mysql.php /var/www/adminer/adminer.php

RUN set -e && \
	chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh && \
    chmod 755 /var/www/adminer/adminer.php && \
    adduser -G www-data -D www-data && \
	chown www-data:www-data /var/www/adminer

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "php-fpm8", "-F" ]


