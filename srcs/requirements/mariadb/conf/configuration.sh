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
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --auth-root-authentication-method=normal
check_error "$ME: mysql_install_db"




# entrypoint_log "$ME: database default setting 🔍 "
# {
#     echo "FLUSH PRIVILEGES;"
#     echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
#     echo "DELETE FROM mysql.user WHERE User='';"
#     echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
#     echo "DROP DATABASE IF EXISTS test;"
#     echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
#     echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;"
#     echo "FLUSH PRIVILEGES;"
# } | mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap
# # kill mysqld
# # check_error "$ME: database default setting"
# entrypoint_log "$ME: database default setting"



entrypoint_log "$ME: configuration step is all done ✨ "
echo ""

exit 0
