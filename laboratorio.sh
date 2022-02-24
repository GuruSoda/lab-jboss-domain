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
    ;;
  'crear') 
    docker network create jbossnet

    docker create --name host-master  --hostname master  --network jbossnet -p 9990:9990 www.planetaguru.com.ar/jboss-eap-7.2.0-credi master
    docker create --name host-backup  --hostname backup  --network jbossnet www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave 
    docker create --name host-slave01 --hostname slave01 --network jbossnet www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave
    docker create --name host-slave02 --hostname slave02 --network jbossnet www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave
    docker create --name host-slave03 --hostname slave03 --network jbossnet www.planetaguru.com.ar/jboss-eap-7.2.0-credi slave
    docker create --name apache       --hostname apache  --network jbossnet -p 80:80 www.planetaguru.com.ar/apache-credi
    ;;
  'iniciar')
    docker start apache host-master host-backup host-slave01 host-slave02 host-slave03
    ;;
  'detener')
    docker stop apache host-master host-backup host-slave01 host-slave02 host-slave03
    ;;
  'borrar')
    docker rm apache host-master host-backup host-slave01 host-slave02 host-slave03

    docker network remove jbossnet
    ;;
  'cli')
    docker run -it --rm --name jboss-cli --hostname jboss-cli --network jbossnet -v `pwd`/repositorio:/opt/repositorio www.planetaguru.com.ar/jboss-eap-7.2.0-credi bash
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
    echo 'status        -> Lista es estado de los contenerdores del laboratorio.'
    echo 'help | ayuda  -> Esta pantalla.'
    esac

