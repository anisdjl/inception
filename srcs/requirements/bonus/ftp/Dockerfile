FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install vsftpd -y

COPY conf/vsftpd.conf /etc/vsftpd.conf