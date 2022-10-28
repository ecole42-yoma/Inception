#!/bin/sh

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${MARIADB_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[MARIADB - CONFIGURATION] $@"
    fi
}

entrypoint_log "$ME: re-create /var/lib/mysql && ensure /var/run/mysqld"
# purge and re-create /var/lib/mysql with appropriate ownership
# rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
chmod 777 /var/run/mysqld
if [ $? -ne 0 ]; then
    entrypoint_log "$ME: re-create /var/lib/mysql && ensure /var/run/mysqld : fail"
    exit 1
fi
entrypoint_log "$ME: re-create /var/lib/mysql && ensure /var/run/mysqld : done"




entrypoint_log "$ME: edit /etc/my.cnf.d/mariadb-server.cnf"
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
entrypoint_log "$ME: edit /etc/my.cnf.d/mariadb-server.cnf : done"




entrypoint_log "$ME: mysql_install_db"
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
entrypoint_log "$ME: mysql_install_db : done"





entrypoint_log "$ME: all done"

exit 0
