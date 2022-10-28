#!/bin/sh

set - e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

entrypoint_log "$ME: set nginx.conf file"
cat > /etc/nginx/http.d/default.conf << EOF
server {
	listen 443 default_server ssl;
	listen [::]:443 default_server ssl;

	server_name yongmkim.42.fr www.yongmkim.42.fr;

	location / {
		root /var/lib/nginx/html;
		index index.html index.php index.htm;
	}

	# location /404/ {
	# 	return 404;
	# }

	# # You may need this to prevent return 404 recursion.
	# location = /404.html {
	# 	internal;
	# }

}
EOF
entrypoint_log "$ME: set nginx.conf file - done"

exit 0
