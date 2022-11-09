# nginx
# stable version for legacy
FROM alpine:3.14

ENV CERTS_=/CN=yongmkim.42.fr/

STOPSIGNAL SIGINT

HEALTHCHECK --interval=1s --timeout=2s --start-period=1s --retries=30 \
            CMD [ "nc", "-z", "localhost", "443" ]

RUN set -ex && \
    apk add --no-cache \
        nginx \
        openssl && \
    mkdir -p /docker-entrypoint.d && \
    sed -i "s/ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3/ssl_protocols TLSv1.2 TLSv1.3/g" /etc/nginx/nginx.conf && \
    openssl genrsa -out /etc/ssl/certs/private-key.pem 2048 && \
    # openssl rsa -in /etc/ssl/certs/private-key.pem -pubout -out /etc/ssl/certs/public-key.pem && \
    openssl req -new -x509 -key /etc/ssl/certs/private-key.pem -out /etc/ssl/certs/cert.pem -days 360 -subj ${CERTS_} && \
    rm -rf /var/cache/apk/*

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -ex && \
    chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
