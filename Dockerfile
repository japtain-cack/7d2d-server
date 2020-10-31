# Build remco from specific commit
##################################
FROM golang AS remco

ENV REMCO_VERSION v0.12.0

# remco (lightweight configuration management tool) https://github.com/HeavyHorst/remco
RUN go get github.com/HeavyHorst/remco/cmd/remco
RUN cd $GOPATH/src/github.com/HeavyHorst/remco && \
    git checkout ${REMCO_VERSION}
RUN go install github.com/HeavyHorst/remco/cmd/remco


# Build base container
######################
FROM ubuntu:bionic AS ubuntu
LABEL author="Nathan Snow"
LABEL description="7 Days to Die dedicated server"
USER root

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV SEVEND2D_HOME=/home/sevend2d
ENV SEVEND2D_UID=1000
ENV SEVEND2D_GUID=1000

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install \
    sudo \
    unzip \
    curl \
    wget \
    git \
    vim \
    gnupg2 \
    lib32gcc1

RUN groupadd -g $SEVEND2D_GUID sevend2d && \
    useradd -s /bin/bash -d $SEVEND2D_HOME -m -u $SEVEND2D_UID -g sevend2d sevend2d && \
    passwd -d sevend2d && \
    echo "sevend2d ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sevend2d

RUN mkdir steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ./steamcmd && \
    cp -vrf steamcmd/* ${SEVEND2D_HOME}/ && \
    chmod +x ${SEVEND2D_HOME}/steamcmd.sh

COPY --from=remco /go/bin/remco /usr/local/bin/remco
COPY --chown=sevend2d:root remco /etc/remco
RUN chmod -R 0775 /etc/remco

USER sevend2d
WORKDIR $SEVEND2D_HOME
VOLUME "${SEVEND2D_HOME}/server"

EXPOSE 26900/tcp
EXPOSE 26900-26902/udp
EXPOSE 8080-8082/tcp

COPY --chown=sevend2d:sevend2d files/entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

