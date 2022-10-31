# nginx
# stable version for legacy
FROM alpine:3.14

ENV	WORDPRESS_DB_HOST=mariadb \
	WORDPRESS_DB_NAME=$MYSQL_DATABASE \
	WORDPRESS_DB_USER=$MYSQL_USER \
	WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD

RUN set -e && \
	#build wordperss container
	apk add --no-cache \
		mysql-client

RUN set -e && \
    mkdir -p /docker-entrypoint.d /etc/nginx/www

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -e && \
	chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000
EXPOSE 3306

STOPSIGNAL SIGQUIT

CMD [ "php-fpm8", "-F" ]


