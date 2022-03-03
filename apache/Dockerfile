from ubuntu:20.04 

ARG CACHE_APT

RUN if [ "$CACHE_APT" != "" ]; then sed -i "s/archive.ubuntu.com\|ar.archive.ubuntu.com\|archive.canonical.com\|security.ubuntu.com/$CACHE_APT/g" /etc/apt/sources.list; else echo "sin variable CACHE_APT"; fi

RUN apt -y update && \
apt -y upgrade && \
DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install vim locales tzdata dialog curl wget git mc apache2 ssh sudo && apt clean && rm -rf /var/lib/apt/lists/*

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

COPY mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz /tmp/

RUN (cat /tmp/mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz | tar xfz -) && \
    mv *.so /usr/lib/apache2/modules/ && \
    ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/ && \
    ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/ && \
    ln -s /etc/apache2/mods-available/proxy_cluster.load /etc/apache2/mods-enabled/ && \
    ln -s /etc/apache2/conf-available/cluster.conf /etc/apache2/conf-enabled/

ADD proxy_cluster.load /etc/apache2/mods-available/
ADD cluster.conf /etc/apache2/conf-available/

# para cambiar la clave del usuario root y agregar un usuario que pueda hacer sudo sin que le pida clave
RUN echo 'root:apache' | chpasswd ; useradd -s /bin/bash -m apache ; echo apache:apache | chpasswd ; usermod -a -G apache apache && adduser apache sudo ; echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY pause.sh /

CMD ["/pause.sh"]

# CMD service xxx start ; while true ; do sleep 100; done;
