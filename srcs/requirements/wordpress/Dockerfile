# nginx
# stable version for legacy
FROM alpine:3.14

RUN set -e && \
	#build wordperss container
	apk add --no-cache \
		php8-common \
		php8-pdo_sqlite \
		php8-pear \
		php8-ftp \
		php8-imap \
		php8-mysqli \
		php8-json \
		php8-mbstring \
		php8-soap \
		php8-litespeed \
		php8-sockets \
		php8-bcmath \
		php8-opcache \
		php8-dom \
		php8-zlib \
		php8-gettext \
		php8-fpm \
		php8-intl \
		php8-openssl \
		php8-session \
		php8-pdo_mysql \
		php8-embed \
		php8-xmlrpc \
		php8-wddx \
		php8-dba \
		php8-ldap \
		php8-xsl \
		php8-exif \
		php8-pdo_dblib \
		php8-bz2 \
		php8-pdo \
		php8-pspell \
		php8-sysvmsg \
		php8-gmp \
		php8-apache2 \
		php8-pdo_odbc \
		php8-shmop \
		php8-ctype \
		php8-phpdbg \
		php8-enchant \
		php8-sysvsem \
		php8-sqlite3 \
		php8-odbc \
		php8-pcntl \
		php8-calendar \
		php8-xmlreader \
		php8-snmp \
		php8-zip \
		php8-posix \
		php8-iconv \
		php8-curl \
		php8-doc \
		php8-gd \
		php8-xml \
		php8-dev \
		php8-cgi \
		php8-sysvshm \
		php8-pgsql \
		php8-tidy \
		php8-pdo_pgsql \
		php8-phar \
		php8-mysqlnd \
		mariadb-client

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -e && \
	chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000
EXPOSE 3306

CMD [ "php-fpm8", "-F" ]


