FROM alpine:3.16.2


ENV NGINX_VERSION 1.22.1
ENV NJS_VERSION   0.7.7
ENV PKG_RELEASE   1

RUN set -x && \
    apk add --no-cache \
        nginx \
        openssl && \
# create a docker-entrypoint.d directory
    mkdir -p /docker-entrypoint.d

COPY docker-entrypoint.sh /
COPY 20-envsubst-on-templates.sh /docker-entrypoint.d
#COPY configuration.sh /docker-entrypoint.d

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
