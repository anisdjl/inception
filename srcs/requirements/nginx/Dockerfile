FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    nginx \
    vim \
    curl && \
    mkdir -p /etc/nginx/ssl \
    && apt-get install openssl -y \
    && openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=adjelili.42.fr/UID=adjelili"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf