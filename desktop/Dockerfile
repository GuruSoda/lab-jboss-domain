from ubuntu:20.04

RUN if [ "$CACHE_APT" != "" ]; then sed -i "s/archive.ubuntu.com\|ar.archive.ubuntu.com\|archive.canonical.com\|security.ubuntu.com/$CACHE_APT/g" /etc/apt/sources.list; else echo "sin variable CACHE_APT"; fi

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
RUN echo 'root:soda' | chpasswd ; useradd -s /bin/bash -m docker ; echo docker:docker | chpasswd ; usermod -a -G docker docker && adduser docker sudo ; echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#desktop mate, instalacion minimaes ubuntu-mate-core
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install ubuntu-mate-desktop x11vnc tightvncserver xvfb xfonts-base xfonts-100dpi xfonts-75dpi websockify novnc && rm -rf /var/lib/apt/lists/*
# para acceso desde un navegador
RUN cd /usr/share/novnc ; ln -s vnc.html index.html

#desktop xfce4
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4 xfce4-goodies && rm -rf /var/lib/apt/lists/*
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install xubuntu-desktop
# de prueba
# RUN tasksel install xubuntu-desktop
# Borrar: xfwm4 xfce4-panel xfce4-settings xfce4-session xfce4-terminal xfdesktop4 xfce4-taskmanager tango-icon-theme
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install gnome-icon-theme tightvncserver xorg xserver-xorg xserver-xorg-video-dummy xfce4 xfce4-goodies dbus-x11 xfwm4 xfce4-panel xfce4-settings xfce4-session xfce4-terminal xfdesktop4 xfce4-taskmanager tango-icon-theme && rm -rf /var/lib/apt/lists/*

# Para instalar google chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && apt update && apt install -y google-chrome-stable

COPY entrypoint.sh /

CMD ["/entrypoint.sh"]

