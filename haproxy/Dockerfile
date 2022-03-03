FROM ubuntu:20.04 

ARG CACHE_APT

RUN if [ "$CACHE_APT" != "" ]; then sed -i "s/archive.ubuntu.com\|ar.archive.ubuntu.com\|archive.canonical.com\|security.ubuntu.com/$CACHE_APT/g" /etc/apt/sources.list; else echo "sin variable CACHE_APT"; fi

RUN apt -y update && \
apt -y upgrade && \
DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install haproxy vim locales tzdata dialog curl wget git mc ssh sudo && apt clean && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Buenos_Aires \
LANG=es_AR.utf8 \
LANGUAGE=es_AR:es \
LC_ALL=es_AR.UTF-8

RUN apt-get update && \
apt-get upgrade -y && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
mc dialog vim curl net-tools unzip git wget apt-utils sudo tzdata locales language-pack-es && rm -rf /var/lib/apt/lists/* && \
localedef -i es_AR -c -f UTF-8 -A /usr/share/locale/locale.alias es_AR.UTF-8 && update-locale LANG=$LANG LANGUAGE=$LANGUAGE LC_ALL=$LC_ALL && \
sed -i '/es_AR.UTF-8/s/^# //g' /etc/locale.gen && locale-gen ; \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata

# para cambiar la clave del usuario root y agregar un usuario que pueda hacer sudo sin que le pida clave
# RUN echo 'root:haproxy' | chpasswd ; useradd -s /bin/bash -m haproxy ; echo haproxy:haproxy | chpasswd ; usermod -a -G haproxy haproxy && adduser haproxy sudo ; echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
CMD mkdir /run/haproxy
# USER haproxy

CMD /usr/sbin/haproxy -Ws -f /etc/haproxy/haproxy.cfg

