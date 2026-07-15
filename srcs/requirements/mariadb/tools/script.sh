#!/bin/bash

mkdir -p /run/mysqld # create the run folder if it doesn't exists
chown -R mysql:mysql /run/mysqld

SQL_PASSWORD=$(cat /run/secrets/DB_USER_PASSWORD)
SQL_ROOT_PASSWORD=$(cat /run/secrets/DB_ROOT_PASSWORD)

mariadbd-safe --datadir='/var/lib/mysql' & # launch mariadb

sleep 5 # allow the service to start and not execute the commands before it starts

if mysql -u root -e "status" &>/dev/null; then
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;" # will create a database if it doesn't exists named after the name stored in the env var SQL_DATABASE
    mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';" # create a new user with a name and a passeword
    mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';" # give the rights to the user
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';" # we set a password to the root
    mysql -e "FLUSH PRIVILEGES;" # the flush is like a refresh (f5) so the DB has the latest version of the modifications we just made
fi

mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

exec mariadbd-safe