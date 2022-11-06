# mariadb
# stable version for legacy
FROM alpine:3.14

EXPOSE 3306

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=yongmkim
ENV MYSQL_PASSWORD=password

STOPSIGNAL SIGINT

RUN set -ex && \
	# apk update && \
	apk add --no-cache\
		coreutils \
		mariadb \
		mariadb-client && \
    mkdir -p /docker-entrypoint.d && \
	mkdir -p /var/lib/mysql /var/run/mysqld && \
	rm -rf /var/cache/apk/*

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -ex && \
	chmod +x /docker-entrypoint.sh /docker-entrypoint.d/configuration.sh && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
	chmod 755 /var/run/mysqld

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--basedir=/usr"]

# ./etc/my.cnf.d/mariadb-server.cnf
