# mariadb
FROM alpine:3.16.2

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
	# purge and re-create /var/lib/mysql with appropriate ownership and init db
	mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld
	# mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --auth-root-authentication-method=normal


COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -x && \
	chmod +x /docker-entrypoint.sh /docker-entrypoint.d/configuration.sh && \
	/docker-entrypoint.d/configuration.sh

# ENTRYPOINT ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--basedir=/usr"]
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 3306

STOPSIGNAL SIGQUIT

# CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--basedir=/usr"]

# ./etc/my.cnf.d/mariadb-server.cnf
