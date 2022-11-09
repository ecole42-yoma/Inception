#!/bin/sh

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[NGINX - Configuration] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[NGINX - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[NGINX - Configuration] $@ : complete ✅ "
        echo ""
    fi
}



entrypoint_log "$ME: adduser chwon 🔍 "
adduser -G www-data -D www-data
chown -R www-data:www-data /var/www/html
entrypoint_log "$ME: adduser chwon complete ✅ "



# set nginx.conf file
entrypoint_log "$ME: set nginx default.conf file - /etc/nginx/http.d/deafault.conf 🔍 "
# cat > /etc/nginx/http.d/default.conf << ''EOF
cat > /etc/nginx/http.d/default.conf << EOF
server {

	listen				443 default_server ssl;
	listen				[::]:443 default_server ssl;

	# for security
	server_tokens		off;

	ssl_certificate		/etc/ssl/certs/cert.pem;
	ssl_certificate_key	/etc/ssl/certs/private-key.pem;
	ssl_protocols		TLSv1.2 TLSv1.3;
	ssl_prefer_server_ciphers on;

	server_name			$DOMAIN_NAME www.$DOMAIN_NAME;

	error_log 			/var/log/nginx/error.log;
	access_log 			/var/log/nginx/access.log;

	root 				$WORDPRESS_PATH;
	index 				index.html index.php;

	location ~ /cadvisor {
		proxy_pass 						http://$MONITOR_NETWORK:2121;
	}

	location ~ /profile {
		proxy_pass 						http://$STATIC_SITE_NETWORK:4242;
	}

	location ~ /adminer {
		error_log 						/var/log/nginx/adminer_error.log;
		access_log 						/var/log/nginx/adminer_access.log;
		fastcgi_split_path_info			^(.+?\.php)(/.*)$;
		fastcgi_param HTTP_PROXY		"";
		fastcgi_pass 					$ADMINER_NETWORK:8080;
		fastcgi_index					adminer.php;
		include 						fastcgi_params;
		fastcgi_param SCRIPT_FILENAME 	/var/www/adminer/adminer.php;
	}

	location ~ \.php$ {
		try_files	\$uri				= 404;
		fastcgi_split_path_info			^(.+?\.php)(/.*)$;
		# Mitigate https://httpoxy.org/ vulnerabilities
		fastcgi_param HTTP_PROXY		"";
		fastcgi_pass					$FRONT_NETWORK:9000;
		fastcgi_index					index.php;
		include							fastcgi_params;
		fastcgi_param SCRIPT_FILENAME	\$document_root\$fastcgi_script_name;
		fastcgi_param PATH_INFO			\$fastcgi_path_info;
	}

	location ~* .(png|ico|gif|jpg|jpeg|css|js)$	{
		try_files						\$uri = 404;
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
check_error "$ME: set nginx default.conf file - /etc/nginx/http.d/deafault.conf"











entrypoint_log "$ME: configuration step is all done ✨ "
echo ""
