#!/bin/sh
# vim:sw=4:ts=4:et
# https://github.com/nginxinc/docker-nginx/tree/fef51235521d1cdf8b05d8cb1378a526d2abf421/stable/alpine

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[SITE] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[SITE - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[SITE - Configuration] $@ : complete ✅ "
        echo ""
    fi
}

# set nginx.conf file
entrypoint_log "$ME: set nginx default.conf file - /etc/nginx/http.d/deafault.conf 🔍 "
# cat > /etc/nginx/http.d/default.conf << ''EOF
cat > /etc/nginx/http.d/default.conf << EOF
server {

	listen				4242;
	listen				[::]:4242;

	# for security
	server_tokens		off;

	error_log 			/var/log/nginx/error.log;
	access_log 			/var/log/nginx/access.log;

	root 				/profile;
	index 				profile.html index.html;

	location / {
		try_files	\$uri	/profile.html = 404;
	}
}
EOF
check_error "$ME: set nginx default.conf file - /etc/nginx/http.d/deafault.conf"

