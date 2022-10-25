#mariadb

FROM alpine:3.16.2

RUN set -ex && \
	apk update && \
	apk add --no-cache\
		mariadb \
		mariadb-client && \
	rm -rf /var/cache/apk/*

#COPY healthcheck.sh /usr/local/bin/healthcheck.sh

COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mariadbd"]
