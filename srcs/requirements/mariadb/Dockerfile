# mariadb
# stable version for legacy
FROM alpine:3.14

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=yongmkim
ENV MYSQL_PASSWORD=password

RUN set -x && \
	apk add nginx

RUN set -x && \
	apk update && \
	apk add --no-cache\
		mariadb \
		mariadb-client && \
    mkdir -p /docker-entrypoint.d && \
	rm -rf /var/cache/apk/* && \
	mkdir -p /var/lib/mysql /var/run/mysqld

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -x && \
	chmod +x /docker-entrypoint.sh /docker-entrypoint.d/configuration.sh && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306

STOPSIGNAL SIGQUIT

CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--basedir=/usr"]

# ./etc/my.cnf.d/mariadb-server.cnf
