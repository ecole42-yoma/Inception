# mariadb
FROM alpine:3.16.2

RUN set -x && \
	apk update && \
	apk add --no-cache\
		mariadb \
		mariadb-client && \
    mkdir -p /docker-entrypoint.d && \
	rm -rf /var/cache/apk/*

ARG	MARIADB_ROOT_PASSWORD=PASS
ARG	MARIADB_DATABASE=DATA
ARG MARIADB_USER=USER
ARG	MARIADB_PASSWORD=PASS

#COPY healthcheck.sh /usr/local/bin/healthcheck.sh

COPY tools/docker-entrypoint.sh /
COPY conf/healthcheck.sh /docker-entrypoint.d

RUN set -x && \
	chmod +x /docker-entrypoint.sh /docker-entrypoint.d/healthcheck.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]

