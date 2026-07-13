#!/bin/bash

sleep 10

cd /var/www/wordpress

if [ ! -f wp-config.php ]; then

    wp config create --allow-root \
             --dbname=${SQL_DATABASE} \
             --dbuser=${SQL_USER} \
             --dbpass=${SQL_PASSWORD} \
             --dbhost=mariadb:3306

    wp core install --allow-root \
        --url=${WP_URL} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    wp user create ${WP_USER} ${WP_USER_EMAIL} --allow-root \
        --role=author \
        --user_pass=${WP_USER_PASSWORD}

fi

chown -R www-data:www-data /var/www/wordpress

mkdir -p /run/php

exec /usr/sbin/php-fpm8.2 -F