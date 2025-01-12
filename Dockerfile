FROM ubuntu:focal

LABEL maintainer="Rolf Kleef <rolf@drostan.org>" \
  description="IATI Workbench Engine" \
  repository="https://github.com/data4development/iati-workbench"

# create a non-root user iati-workbench that will contain the code in its home folder 
ARG \
  UNAME=iati-workbench \
  GID=1000 \
  UID=1000 \
  DEBIAN_FRONTEND=noninteractive

RUN groupadd -g $GID -o $UNAME && \
  useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

RUN apt-get update && \
  # to remove basex warnings: libjline2-java libjing-java libtagsoup-java libxml-commons-resolver1.1-java
  apt-get -y install --no-install-recommends ant wget less git xmlstarlet libreoffice-calc-nogui libreoffice-java-common source-highlight unzip xz-utils \
    libsaxonhe-java basex libjline2-java libjing-java libtagsoup-java libxml-commons-resolver1.1-java locales  && \
  ln -s /usr/share/java/Saxon-HE.jar /usr/share/ant/lib && \
  # reduce footprint of this layer:
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/dpkg/info/* && \
  rm -rf /usr/lib/libreoffice/share/gallery/* && \
  rm -rf /usr/lib/libreoffice/share/template/* && \
  rm -rf /usr/lib/libreoffice/share/wizards/* && \
  rm -rf /usr/share/libreoffice/share/config/* && \
  rm -rf /usr/share/doc/*

ENV HOME=/home/$UNAME
ENV LC_ALL=en_IE.UTF-8
WORKDIR $HOME
USER $UNAME
COPY --chown=$UID:$GID . $HOME

ENTRYPOINT ["/usr/bin/ant"]
CMD ["-p"]
