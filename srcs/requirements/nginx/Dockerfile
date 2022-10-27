# nginx
FROM alpine:3.16.2

RUN set -x && \
    apk add --no-cache \
        nginx \
        openssl && \
# create a docker-entrypoint.d directory
    mkdir -p /docker-entrypoint.d

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -x && \
    chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
