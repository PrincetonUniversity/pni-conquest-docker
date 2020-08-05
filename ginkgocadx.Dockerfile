FROM ubuntu:18.04
MAINTAINER Garrett McGrath <gmcgrath@princeton.edu>
## based on work from:
#MAINTAINER Carles Amigó, fr3nd@fr3nd.net

RUN apt-get update && apt-get install -y \
      x11-apps ginkgocadx \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*


RUN useradd -ms /bin/bash user
USER user
CMD ginkgocadx
