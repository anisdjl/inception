FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    wget \
    ca-certificates \
    tar

RUN wget https://github.com/portainer/portainer/releases/download/2.19.5/portainer-2.19.5-linux-amd64.tar.gz && \
    tar -xvf portainer-2.19.5-linux-amd64.tar.gz -C /opt/ && \
    rm portainer-2.19.5-linux-amd64.tar.gz

EXPOSE 9000

CMD ["/opt/portainer/portainer"]