FROM rockylinux:9
LABEL MAINTAINER "Garrett McGrath <gmcgrath@princeton.edu>"

## enable epel
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

## install dependencies
RUN yum install -y unzip gcc gcc-c++ httpd httpd-devel p7zip p7zip-plugins p7zip-gui p7zip-doc lua lua-socket luarocks git wget expect gettext sed make procps-ng

RUN groupadd -r -g 10000 conquest && adduser -g 10000 -r -u 10000 conquest

COPY maklinux-automate.exp /opt/maklinux_automate.exp

USER root

## alternatively we could do a pull from source here but the lack of tags means you always pull the latest version
RUN cd /opt  && \
    git clone https://github.com/marcelvanherk/Conquest-DICOM-Server.git && \
    cd /opt/Conquest-DICOM-Server && \
    git checkout a5d312ded0fc7ec03cc19e5ccfe99dcd96408734 && \
    chmod +x ./maklinux && \
    sed 's/sudo//g' ./maklinux > ./maklinux1 && \
    sed 's/lua5.1/lua/g' ./maklinux1 > ./maklinux_trimmed && \
    chmod +x ./maklinux_trimmed && \
    /opt/maklinux_automate.exp

COPY ./conf/dicom.ini.pni /opt/Conquest-DICOM-Server/dicom.ini

RUN mkdir -p /opt/scripts

## script for automatically archiving dicom files
COPY ./scripts/ConquestArchive.sh /opt/scripts/ConquestArchive.sh

RUN chmod +x /opt/scripts/ConquestArchive.sh && chmod -R +r /opt/scripts

USER conquest

CMD ["/opt/Conquest-DICOM-Server/dgate"]

COPY conquest.Dockerfile /DOCKERFILE
