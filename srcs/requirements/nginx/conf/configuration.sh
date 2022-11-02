#!/bin/sh

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
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



# delete TLSv1.1
# entrypoint_log "$ME: set nginx.conf file - /etc/nginx/nginx.conf 🔍 "
# sed -i "s/ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3/ssl_protocols TLSv1.2 TLSv1.3/g" /etc/nginx/nginx.conf
# check_error "$ME: set nginx.conf file - /etc/nginx/nginx.conf"
# echo ""


# openssl key gen
# SSL_DIR="/etc/ssl/certs"
# entrypoint_log "$ME: set openssl key gen - /ssl/certs/ 🔍 "
# openssl genrsa -out $SSL_DIR/private-key.pem 3072
# check_error "openssl: rsa key gen - openssl genrsa -out $SSL_DIR/private-key.pem 3072"
# openssl rsa -in $SSL_DIR/private-key.pem -pubout -out $SSL_DIR/public-key.pem
# check_error "openssl: public key gen - openssl rsa -in $SSL_DIR/private-key.pem -pubout -out $SSL_DIR/public-key.pem"
# openssl req -new -x509 -key $SSL_DIR/private-key.pem -out $SSL_DIR/cert.pem -days 360 -subj $CERTS_
# check_error "openssl: self-signed cert gen - openssl req -new -x509 -key $SSL_DIR/private-key.pem -out $SSL_DIR/cert.pem -days 360 -subj $CERTS_"
# entrypoint_log "$ME: set openssl key gen : complete ✅ "
# echo ""



entrypoint_log "$ME: set dns setting - /etc/hosts 🔍 "
echo "127.0.0.1	$DOMAIN_NAME" >> /etc/hosts
check_error "$ME: set dns setting - /etc/hosts"




# set nginx.conf file
entrypoint_log "$ME: set nginx default.conf file - /etc/nginx/http.d/deafault.conf 🔍 "
cat > /etc/nginx/http.d/default.conf << EOF

# server {
# 	listen 80;
# 	server_name $DOMAIN_NAME;

# 	location / {
# 		return 301 https://$DOMAIN_NAME\$request_uri;
# 	}
# }

server {

	listen				443 default_server ssl;
	listen				[::]:443 default_server ssl;

	# for security
	server_tokens		off

	ssl_certificate		/etc/ssl/certs/cert.pem;
	ssl_certificate_key	/etc/ssl/certs/private-key.pem;
	ssl_protocols		TLSv1.2 TLSv1.3;

	server_name			$DOMAIN_NAME www.$DOMAIN_NAME;

	error_log 			/var/log/nginx/error.log;
	access_log 			/var/log/nginx/access.log;

	root 				$WORDPRESS_PATH;

	index 				index.html index.php index.htm;

	location ~ \.php$ {
		try_files	\$uri				= 404;
		fastcgi_split_path_info			^(.+?\.php)(/.*)$;
		#^(.+\.php)(/.+)$;
		# fastcgi_pass					wordpress:9000;
		fastcgi_pass					$FRONT_NETWORK:9000;
		fastcgi_index					index.php;

		include							fastcgi_params;
		fastcgi_param SCRIPT_FILENAME	\$document_root\$fastcgi_script_name;
		fastcgi_param SCRIPT_NAME		\$fastcgi_script_name;
		fastcgi_param PATH_INFO			\$fastcgi_path_info;
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
echo ""

entrypoint_log "$ME: configuration step is all done ✨ "
echo ""

exit 0
