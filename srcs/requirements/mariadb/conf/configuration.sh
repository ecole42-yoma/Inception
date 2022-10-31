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


# set config file
entrypoint_log "$ME: edit /etc/my.cnf.d/mariadb-server.cnf 🔍 "
cat > /etc/my.cnf.d/mariadb-server.cnf << EOF
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]
bind-address=0.0.0.0
port=3306
datadir='/var/lib/mysql'
basedir='/usr'
user=mysql

# Galera-related settings
[galera]
# Mandatory settings
#wsrep_on=ON
#wsrep_provider=
#wsrep_cluster_address=
#binlog_format=row
#default_storage_engine=InnoDB
#innodb_autoinc_lock_mode=2
#
# Allow server to accept connections on all interfaces.
#
#bind-address=0.0.0.0
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.5 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.5]
EOF
check_error "$ME: edit /etc/my.cnf.d/mariadb-server.cnf"






# initializes the database directory
entrypoint_log "$ME: initializes the database directory : mariadb-install-db 🔍 "
if [ -e "/var/lib/mysql/mysql/user.frm" ]
then
    entrypoint_log "$ME: initializes the database directory : mariadb-install-db : Already installed"
    exit 0
else
    # check secure installation later
    # mysql_secure_installation

    mariadb-install-db \
        --user=mysql \
        --skip-test-db \
        --default-time-zone=SYSTEM \
        --enforce-storage-engine= \
        --loose-innodb_buffer_pool_load_at_startup=0 \
        --loose-innodb_buffer_pool_dump_at_shutdown=0 \
        --basedir=/usr \
        --datadir=/var/lib/mysql
    # mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    check_error "$ME: initializes the database directory : mariadb-install-db"
fi






# # Do a temporary startup of the MariaDB server, for init purposes
# entrypoint_log "$ME: Do a temporary startup of the MariaDB server, for init purposes 🔍 "
# mysqld --skip-networking \
#     --loose-innodb_buffer_pool_load_at_startup=0 &

# MARIADB_PID=$!
# if [ MARIADB_PID -lt 0 ]; then
#     check_error "$ME: Unable to start temp server."
# else
#     sleep 10;
#     if [ MARIADB_PID -ne 0 ]
#     then
#         kill "$MARIADB_PID"
#     fi
# fi

# check_error "$ME: Do a temporary startup of the MariaDB server, for init purposes"






entrypoint_log "$ME: database default setting 🔍 "
{
    echo "FLUSH PRIVILEGES;"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    echo "DELETE FROM mysql.user WHERE User='';"
    echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    echo "DROP DATABASE IF EXISTS test;"
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    echo "CREATE OR REPLACE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;"
    echo "FLUSH PRIVILEGES;"
} | mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap
# check_error "$ME: database default setting"
check_error "$ME: database default setting"



entrypoint_log "$ME: configuration step is all done ✨ "
echo ""
