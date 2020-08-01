FROM centos:7
MAINTAINER Garrett McGrath <gmcgrath@princeton.edu>

## enable epel
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

## install dependencies
RUN yum install -y unzip gcc gcc-c++ httpd httpd-devel p7zip p7zip-plugins p7zip-gui p7zip-doc lua lua-dev lua-socket git wget expect envsubst

COPY maklinux-automate.exp /opt/maklinux_automate.exp

## alternatively we could do a pull from source here but the lack of tags means you always pull the latest version
RUN cd /opt  && \
    git clone https://github.com/marcelvanherk/Conquest-DICOM-Server.git && \
    cd /opt/Conquest-DICOM-Server && \
    chmod +x ./maklinux && \
    /opt/maklinux_automate.exp
