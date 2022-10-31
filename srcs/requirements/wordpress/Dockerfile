# nginx
# stable version for legacy
FROM alpine:3.14

ENV	WORDPRESS_DB_HOST=mariadb
ENV WORDPRESS_DB_NAME=wordpress
ENV WORDPRESS_DB_USER=yongmkim
ENV WORDPRESS_DB_PASSWORD=password

# RUN set -e && \
# 	#build wordperss container
# 	apk add --no-cache \
# 		mysql-client



RUN apk add --no-cache bash curl less vim nginx ca-certificates git tzdata zip \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    php8 php8-fpm php8-json php8-zlib php8-xml php8-xmlwriter php8-simplexml php8-pdo php8-phar php8-openssl \
    php8-pdo_mysql php8-mysqli php8-session \
    php8-gd php8-iconv php8-gmp php8-zip \
    php8-curl php8-opcache php8-ctype \
    php8-intl php8-bcmath php8-dom php8-mbstring php8-xmlreader mysql-client curl && apk add -u musl && \
    rm -rf /var/cache/apk/*

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php8/php.ini && \
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php8/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm




RUN set -e && \
    mkdir -p /docker-entrypoint.d

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -e && \
	chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp-cli && \
	chown nobody:nobody /usr/bin/wp-cli && \
	chown root:root /usr/bin/wp-cli


ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000
EXPOSE 3306

STOPSIGNAL SIGQUIT

CMD [ "php-fpm8", "-F" ]


