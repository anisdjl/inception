FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install nginx -y

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY html/ /var/www/html


EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]