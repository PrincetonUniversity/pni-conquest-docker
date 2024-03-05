FROM ubuntu:latest
LABEL MAINTAINER "Garrett McGrath <gmcgrath@princeton.edu>"

ENV DEBIAN_FRONTEND noninteractive

## install dependencies
RUN apt-get update && apt-get upgrade -y && \
apt-get install -y unzip make gettext-base git apache2 php libapache2-mod-php  \
 gcc g++ lua5.1 liblua5.1-0 lua-socket p7zip-full luarocks git wget expect gettext sed
#  ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so.0 /usr/lib/x86_64-linux-gnu/liblua5.1.so

RUN groupadd -r --gid 10000 conquest && adduser --gid 10000 --uid 10000 conquest

COPY ./maklinux-automate.exp /opt/maklinux_automate.exp

USER root

## alternatively we could do a pull from source here but the lack of tags means you always pull the latest version
RUN cd /opt  && \
    git clone https://github.com/marcelvanherk/Conquest-DICOM-Server.git && \
    cd /opt/Conquest-DICOM-Server && \
    chmod +x ./maklinux && \
    sed 's/sudo//g' ./maklinux > ./maklinux_trimmed && \
    chmod +x ./maklinux_trimmed && \
    /opt/maklinux_automate.exp

COPY ./conf/dicom.ini.pni /opt/Conquest-DICOM-Server/dicom.ini

RUN mkdir -p /opt/scripts

## script for automatically archiving dicom files
COPY ./scripts/ConquestArchive.sh /opt/scripts/ConquestArchive.sh

RUN chmod +x /opt/scripts/ConquestArchive.sh && chmod -R +r /opt/scripts

USER conquest

CMD ["/opt/Conquest-DICOM-Server/dgate"]

COPY ./conquest.Dockerfile /DOCKERFILE
