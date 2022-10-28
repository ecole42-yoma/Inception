#!/bin/sh

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${MARIADB_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[MARIADB - Configuration] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[MARIADB - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[MARIADB - Configuration] $@ : complete ✅ "
        echo ""
    fi
}




entrypoint_log "$ME: re-create /var/lib/mysql && ensure /var/run/mysqld 🔍 "
# purge and re-create /var/lib/mysql with appropriate ownership
# rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld
check_error "mkdir -p /var/lib/mysql /var/run/mysqld"

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
check_error "chown -R mysql:mysql /var/lib/mysql /var/run/mysqld"

# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
chmod 777 /var/run/mysqld
check_error "chmod 777 /var/run/mysqld"

entrypoint_log "$ME: re-create /var/lib/mysql && ensure /var/run/mysqld : complete ✅ "
echo ""



entrypoint_log "$ME: edit /etc/my.cnf.d/mariadb-server.cnf 🔍 "
sed -i "8d" /etc/my.cnf.d/mariadb-server.cnf
sed -i "8d" /etc/my.cnf.d/mariadb-server.cnf
sed -i "8d" /etc/my.cnf.d/mariadb-server.cnf
cat >> /etc/my.cnf.d/mariadb-server.cnf << EOF
# this is only for the mysqld standalone daemon
[mysqld]
bind-address=0.0.0.0
port=3306
datadir='/var/lib/mysql'
basedir='/usr'
user=mysql
EOF
check_error "$ME: edit /etc/my.cnf.d/mariadb-server.cnf"


# check alraedy database exist other wise create new database and setting up user
entrypoint_log "$ME: mysql_install_db 🔍 "
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
check_error "$ME: mysql_install_db"


# entrypoint_log "$ME: database default setting 🔍 "
# mysql -u root << EOF

# ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
# FLUSH PRIVILEGES;
# DELETE FROM mysql.user WHERE User='';
# DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# DROP DATABASE IF EXISTS test;
# CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
# GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# FLUSH PRIVILEGES;
# EOF
# check_error "$ME: database default setting"



entrypoint_log "$ME: configuration step is all done ✨ "
echo ""

exit 0
