# mariadb
FROM alpine:3.16.2

RUN set -x && \
	apk update && \
	apk add --no-cache\
		mariadb \
		mariadb-client && \
	rm -rf /var/cache/apk/*

#COPY healthcheck.sh /usr/local/bin/healthcheck.sh

COPY tools/docker-entrypoint.sh /
COPY conf/healthcheck.sh /

RUN set -x && \
	chmod +x /docker-entrypoint.sh /healthcheck.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mariadbd"]
