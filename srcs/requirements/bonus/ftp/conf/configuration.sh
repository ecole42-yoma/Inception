#!/bin/sh
# vim:sw=4:ts=4:et
# https://github.com/nginxinc/docker-nginx/tree/fef51235521d1cdf8b05d8cb1378a526d2abf421/stable/alpine

set -e

ME=$(basename $0)

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "[FTP] $@"
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "[FTP - Configuration] $@ : fail ❌ "
        echo ""
        exit 1
    else
        echo "[FTP - Configuration] $@ : complete ✅ "
        echo ""
    fi
}


if [ ! -f .check_conf ]
then
{
entrypoint_log "$ME: addgroup  adduser chown chpasswd 🔍 "
addgroup $FTP_USER
adduser -G $FTP_USER -D $FTP_USER
chown $FTP_USER:$FTP_USER $PATH_
echo $FTP_USER:$FTP_PASSWORD | chpasswd
chmod -R +x $PATH_
entrypoint_log "$ME: addgroup  adduser chown chpasswd ✅ "





entrypoint_log "$ME: setting default conf : /etc/vsftpd/vsftpd.conf 🔍 "
sed -i "/anonymous_enable=/c\anonymous_enable=NO" /etc/vsftpd/vsftpd.conf
sed -i "/#local_enable=YES/c\local_enable=YES" /etc/vsftpd/vsftpd.conf
# sed -i "/#local_umask=022/c\local_umask=077" /etc/vsftpd/vsftpd.conf
sed -i "/#write_enable=YES/c\write_enable=YES" /etc/vsftpd/vsftpd.conf
# sed -i "/#chroot_local_user=YES/c\chroot_local_user=YES" /etc/vsftpd/vsftpd.conf
sed -i "/#xferlog_file=\/var\/log\/vsftpd.log/c\xferlog_file=\/var\/log\/vsftpd.log" /etc/vsftpd/vsftpd.conf
# sed -i "/#xferlog_file=\/var\/log\/vsftpd.log/c\xferlog_file=\/dev\/stdout" /etc/vsftpd/vsftpd.conf
cat >> /etc/vsftpd/vsftpd.conf << EOF
local_root=$PATH_

seccomp_sandbox=NO

listen_port=21

port_enable=YES
ftp_data_port=20

pasv_enable=YES
pasv_min_port=$FTP_PORT_MIN
pasv_max_port=$FTP_PORT_MAX

# ssl_enable=YES
# rsa_cert_file=/etc/ssl/certs/cert.pem
# rsa_private_key_file=/etc/ssl/certs/private-key.pem

# allow_anon_ssl=NO
# force_local_data_ssl=YES
# force_local_logins_ssl=YES
# force_anon_data_ssl=NO
# force_anon_logins_ssl=NO

# ssl_tlsv1=YES
# ssl_sslv2=NO
# ssl_sslv3=NO

# require_ssl_reuse=NO
# ssl_ciphers=HIGH
EOF
check_error "$ME: setting default conf : /etc/vsftpd/vsftpd.conf"

touch .check_conf

}
else
    entrypoint_log "$ME: /etc/vsftpd/vsftpd.conf already configured ✅ "
    echo "restart" >> .check_conf
fi

