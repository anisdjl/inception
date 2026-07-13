FROM debian:bookworm


RUN apt-get update && apt-get upgrade -y && apt-get -y install wget
RUN apt-get install -y php8.2\
    php-fpm\
    php-mysql\
    mariadb-client

RUN wget https://wordpress.org/latest.tar.gz -P /var/www
RUN cd /var/www && tar -xzf latest.tar.gz && rm latest.tar.gz
RUN chown -R www-data:www-data /var/www/wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

ENTRYPOINT [ "/usr/local/bin/script.sh" ]