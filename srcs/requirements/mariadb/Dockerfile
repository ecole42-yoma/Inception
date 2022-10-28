# mariadb
FROM alpine:3.16.2

RUN set -x && \
	apk update && \
	apk add --no-cache\
		mariadb \
		mariadb-client && \
    mkdir -p /docker-entrypoint.d && \
	rm -rf /var/cache/apk/*

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

# ENV MYSQL_ROOT_PASSWORD=password
# ENV MYSQL_DATABASE=mariadb
# ENV MYSQL_USER=yongmkim
# ENV MYSQL_PASSWORD=password

RUN set -x && \
	chmod +x /docker-entrypoint.sh /docker-entrypoint.d/configuration.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306

STOPSIGNAL SIGQUIT

CMD ["mariadbd", "--user=mysql"]

# ./etc/my.cnf.d/mariadb-server.cnf
