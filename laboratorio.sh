#!/bin/sh

# para tener un desktop en la red
# docker run -it --rm --name desktop-credi --hostname desktop -p 5901:5901 -p 6901:6901 --network jbossnet www.planetaguru.com.ar/desktop-credi bash
# docker create --name desktop --hostname desktop -p 5901:5901 -p 6901:6901 --network jbossnet www.planetaguru.com.ar/desktop

case "$1" in
  'construir')
    cd jboss
    docker build . -t www.planetaguru.com.ar/jboss-eap-7.2.0-credi
    cd ..
    cd apache
    docker build . -t www.planetaguru.com.ar/apache-credi
    cd ..
    cd haproxy
    docker build . -t www.planetaguru.com.ar/haproxy-credi
    cd ..
    ;;
  'crear') 
    docker network create jbossnet

    docker create --name host-master  --hostname master  --network jbossnet -p 9990:9990 -v `pwd`/jboss:/mnt/share www.planetaguru.com.ar/jboss-eap-7.2.0-credi master
    docker create --name host-backup  --hostname backup  --network jbossnet -v `pwd`/jboss:/mnt/share www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave 
    docker create --name host-slave01 --hostname slave01 --network jbossnet -v `pwd`/jboss:/mnt/share www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave
    docker create --name host-slave02 --hostname slave02 --network jbossnet -v `pwd`/jboss:/mnt/share www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave
    docker create --name host-slave03 --hostname slave03 --network jbossnet -v `pwd`/jboss:/mnt/share www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave
    docker create --name apache01     --hostname apache01  --network jbossnet www.planetaguru.com.ar/apache-credi
    docker create --name apache02     --hostname apache02  --network jbossnet www.planetaguru.com.ar/apache-credi
    docker create --name haproxy      --hostname haproxy  --network jbossnet -v `pwd`/haproxy/haproxy.cfg:/etc/haproxy/haproxy.cfg:ro -v `pwd`/haproxy/custom_404.html:/etc/haproxy/errors/custom_404.html:ro -p 80:80 www.planetaguru.com.ar/haproxy-credi
    ;;
  'iniciar')
    docker start host-master host-backup host-slave01 host-slave02 host-slave03 apache01 apache02 haproxy 
    ;;
  'detener')
    docker stop host-master host-backup host-slave01 host-slave02 host-slave03 apache01 apache02 haproxy
    docker ps -q --filter "name=firefox" | grep -q . && docker stop firefox || true && docker rm firefox || true
    ;;
  'borrar')
    docker rm haproxy apache01 apache02 host-master host-backup host-slave01 host-slave02 host-slave03

    docker ps -q --filter "name=firefox" | grep -q . && docker stop firefox || true && docker rm firefox || true

    docker network remove jbossnet
    ;;
  'cli')
    docker run -it --rm --name jboss-cli --hostname jboss-cli --network jbossnet -v `pwd`/repositorio:/opt/repositorio www.planetaguru.com.ar/jboss-eap-7.2.0-credi bash
    ;;
  'firefox')
    docker run -d --rm --name firefox --hostname firefox --network jbossnet -v `pwd`/repositorio:/opt/repositorio --env PUID=1000 --env PGID=1000 --env TZ=America/Argentina/Buenos_Aires --shm-size 1gb --link haproxy:jbosslab -p 3300:3000 lscr.io/linuxserver/firefox
    ;;
  'init')
    docker run -it --rm --name jboss-init --hostname jboss-init --network jbossnet -v `pwd`/repositorio:/opt/repositorio www.planetaguru.com.ar/jboss-eap-7.2.0-credi init 
    ;;
  'reset')
    ./laboratorio.sh detener ; ./laboratorio.sh borrar ; ./laboratorio.sh construir ; ./laboratorio.sh crear ; ./laboratorio.sh iniciar
    ;;
  'status')
    docker ps -a --filter network=jbossnet
    ;;
  'help' | 'ayuda' | *)
    echo Parametros:
    echo 'construir     -> Construye las imagenes para crear el laboratorio de jboss domain mode.'
    echo 'crear         -> Crea los contenedores del laboratorio de jboss domain mode.'
    echo 'iniciar       -> Inicia el laboratorio de jboss domain mode.'
    echo 'detener       -> Detiene el laboratorio de jboss domain mode.'
    echo 'borrar        -> Borra el laboratorio de jboss domain mode.'
    echo 'init          -> Inicializa con valores por default el laboratorio.'
    echo 'cli           -> Inicia jboss-cli.sh en un contenedor.'
    echo 'firefox       -> Inicia el contenedor con firefox en el puerto 3300.'
    echo 'status        -> Lista es estado de los contenerdores del laboratorio.'
    echo 'help | ayuda  -> Esta pantalla.'
    esac

