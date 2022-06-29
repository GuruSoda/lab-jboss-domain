FROM ubuntu/apache2:2.4-20.04_beta

ARG CACHE_APT

RUN if [ "$CACHE_APT" != "" ]; then sed -i "s/archive.ubuntu.com\|ar.archive.ubuntu.com\|archive.canonical.com\|security.ubuntu.com/$CACHE_APT/g" /etc/apt/sources.list; else echo "sin variable CACHE_APT"; fi

ENV TZ=America/Argentina/Buenos_Aires \
LANG=en_AR.UTF-8 \
LANGUAGE=es_AR:es \
LC_ALL=es_AR.UTF-8

RUN apt-get update && \
apt-get upgrade -y && \
ln -snf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime && echo America/Argentina/Buenos_Aires > /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
mc dialog vim curl net-tools procps unzip wget apt-utils tzdata locales && rm -rf /var/lib/apt/lists/* && \
sed -i -e 's/# es_AR.UTF-8 UTF-8/es_AR.UTF-8 UTF-8/' /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=es_AR.UTF-8

ADD proxy_cluster.load /etc/apache2/mods-available/
ADD cluster.conf /etc/apache2/conf-available/
RUN a2dissite 000-default.conf

COPY mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz /tmp/
RUN (cat /tmp/mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz | tar xfz -) && mv *.so /usr/lib/apache2/modules/ && a2enmod proxy proxy_ajp proxy_cluster && a2enconf cluster

# Buenisimo para enviar logs al stdout y stderr
# RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
#    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

