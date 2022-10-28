# nginx
FROM alpine:3.16.2

RUN set -x && \
    apk add --no-cache \
        nginx \
        openssl && \
    mkdir -p /docker-entrypoint.d /etc/nginx/www

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -x && \
    chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh
ENV DOMAIN_NAME=yongmkim.42.fr
ENV CERTS_=/CN=yongmkim.42.fr/

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
