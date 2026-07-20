FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install vsftpd -y

RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 20 21 40000-40005
ENTRYPOINT [ "/usr/local/bin/script.sh" ]