#!/bin/bash

FTP_USER=${FTP_USER:-ftpuser}
FTP_PASSWORD=$(cat /run/secrets/FTP_PASSWORD 2>/dev/null || echo "ftppassword")

groupadd -g 33 www-data 2>/dev/null || true

if ! id "$FTP_USER" &>/dev/null; then
    useradd -m -s /bin/bash -g www-data "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
else
    usermod -aG www-data "$FTP_USER"
fi

mkdir -p /var/www/wordpress
chown -R $FTP_USER:www-data /var/www/wordpress
chmod -R 775 /var/www/wordpress

exec vsftpd /etc/vsftpd.conf