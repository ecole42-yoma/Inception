# nginx
# stable version for legacy
FROM alpine:3.14

ENV DOMAIN_NAME=yongmkim.42.fr
ENV CERTS_=/CN=yongmkim.42.fr/

RUN set -x && \
    apk add --no-cache \
        nginx \
        openssl && \
    mkdir -p /docker-entrypoint.d /etc/nginx/www && \
    touch /var/lib/nginx/blocked.log && \
    chmod 777 /var/lib/nginx/blocked.log && \
    # delete TLSv1.1
    sed -i "s/ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3/ssl_protocols TLSv1.2 TLSv1.3/g" /etc/nginx/nginx.conf && \
    # openssl key gen
    openssl genrsa -out /etc/ssl/certs/private-key.pem 3072 && \
    openssl rsa -in /etc/ssl/certs/private-key.pem -pubout -out /etc/ssl/certs/public-key.pem && \
    openssl req -new -x509 -key /etc/ssl/certs/private-key.pem -out /etc/ssl/certs/cert.pem -days 360 -subj ${CERTS_}

COPY tools/docker-entrypoint.sh /
COPY conf/configuration.sh /docker-entrypoint.d

RUN set -x && \
    chmod +x /docker-entrypoint.d/configuration.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
