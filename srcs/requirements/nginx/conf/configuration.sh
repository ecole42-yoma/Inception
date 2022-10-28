#!/bin/sh

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[NGINX - CONFIGURATION] $@"
    fi
}




# delete TLSv1.1
entrypoint_log "$ME: set nginx.conf file : /etc/nginx/nginx.conf"
sed -i "s/ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3/ssl_protocols TLSv1.2 TLSv1.3/g" /etc/nginx/nginx.conf
entrypoint_log "$ME: set nginx.conf file : Done"



# openssl key gen
SSL_DIR="/etc/ssl/certs"
entrypoint_log "$ME: set openssl key gen : /ssl/certs/"
openssl genrsa -out $SSL_DIR/private-key.pem 3072
echo "openssl: rsa key gen : done"
openssl rsa -in $SSL_DIR/private-key.pem -pubout -out $SSL_DIR/public-key.pem
echo "openssl: public key gen : done"
openssl req -new -x509 -key $SSL_DIR/private-key.pem -out $SSL_DIR/cert.pem -days 360 -subj $CERTS_
echo "openssl: self-signed cert gen : done"
entrypoint_log "$ME: set openssl key gen : Done"




# set nginx.conf file
entrypoint_log "$ME: set nginx default.conf file : /etc/nginx/http.d/deafault.conf"
cat > /etc/nginx/http.d/default.conf << EOF
server {

	listen				443 default_server ssl;
	listen				[::]:443 default_server ssl;
	ssl_certificate		/etc/ssl/certs/cert.pem;
	ssl_certificate_key	/etc/ssl/certs/private-key.pem;
	server_name			$DOMAIN_NAME www.$DOMAIN_NAME;
	error_log 			/var/log/nginx/error_log;

	location / {
		root /var/lib/nginx/html;
		index index.html index.php index.htm;
	}

	# location ~ \.php$ {
	#   try_files $uri =404;
	# 	include							fastcgi_params;
	# 	fastcgi_split_path_info			^(.+\.php)(/.+)$;
	# 	fastcgi_pass					wordpress:9000;
	# 	fastcgi_index					index.php;
	# 	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	# 	fastcgi_param SCRIPT_NAME $fastcgi_script_name;
	# 	fastcgi_param PATH_INFO $fastcgi_path_info;
	# }

	# location /404/ {
	# 	return 404;
	# }

	# # You may need this to prevent return 404 recursion.
	# location = /404.html {
	# 	internal;
	# }

}
EOF
entrypoint_log "$ME: set nginx default.conf file : Done"

exit 0
