# nginx
# stable version for legacy
FROM alpine:3.14

STOPSIGNAL SIGINT

EXPOSE 8080

# HEALTHCHECK --interval=1s --timeout=2s --start-period=30s --retries=30 \
#             CMD [ "nc", "-z", "localhost", "9000" ]


# RUN apk add --no-cache bash curl less vim nginx ca-certificates git tzdata zip \
#     libmcrypt-dev zlib-dev gmp-dev \
#     freetype-dev libjpeg-turbo-dev libpng-dev \
#     php8 php8-fpm php8-json php8-zlib php8-xml php8-xmlwriter php8-simplexml php8-pdo php8-phar php8-openssl \
#     php8-pdo_mysql php8-mysqli php8-session \
#     php8-gd php8-iconv php8-gmp php8-zip \
#     php8-curl php8-opcache php8-ctype \
#     php8-intl php8-bcmath php8-dom php8-mbstring php8-xmlreader mysql-client curl && \
#     apk add -u musl && \

    # ln -s /usr/bin/php8 /usr/bin/php && \
    # mkdir -p /docker-entrypoint.d /profile/profile_source /var/www/adminer && \
    # rm -rf /var/cache/apk/*

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

ADD https://www.adminer.org/latest-mysql.php /var/www/adminer/adminer.php

RUN set -e && \
	chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh && \
    chmod 755 /var/www/adminer/adminer.php && \
    adduser -G www-data -D www-data && \
	chown www-data:www-data /var/www/adminer



ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "php-fpm", "-F" ]


