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
	listen 443 default_server;
	listen [::]:443 default_server;

	server_name yongmkim.42.fr;

	location / {
		root /var/www/localhost;
		index welcome_page.html welcome_page.php welcome_page.htm;
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



# configure welcome_page
entrypoint_log "$ME: set nginx welcome_page file"
touch /var/www/localhost/welcome_page.html

cat > /var/www/localhost/welcome_page.html << EOF
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href=\"http://nginx.org/\">nginx.org</a>.<br/>
Commercial support is available at
<a href=\"http://nginx.com/\">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
EOF
entrypoint_log "$ME: set nginx welcome_page file - done"

exit 0
