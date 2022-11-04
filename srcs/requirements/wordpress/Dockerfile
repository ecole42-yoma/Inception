# nginx
# stable version for legacy
FROM alpine:3.14

STOPSIGNAL SIGINT

EXPOSE 9000

HEALTHCHECK --interval=1s --timeout=2s --start-period=30s --retries=30 \
            CMD [ "nc", "-z", "localhost", "9000" ]


RUN apk add --no-cache \
    curl \
    mariadb-client \
    php8 \
    php8-fpm \
    php8-phar \
    php8-session \
    php8-json \
    php8-mysqli \
    php8-iconv \
    php8-mbstring \
    php8-tokenizer \
    php8-curl && \
    ln -s /usr/bin/php8 /usr/bin/php && \
    mkdir -p /docker-entrypoint.d /var/www/adminer && \
    rm -rf /var/cache/apk/*

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d


RUN set -e && \
	chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp-cli && \
    ln -s /usr/bin/wp-cli /usr/bin/wp && \
    adduser -G www-data -D www-data && \
	chown www-data:www-data /usr/bin/wp-cli



ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "php-fpm8", "-F" ]


