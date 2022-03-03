# lab-jboss-domain
Laboratorio para probar JBoss Domain Mode

Comandos:

Para contruir las imagenes:
docker-compose build

Para construir las imagenes con un repositorio de ubuntu/debian local:
docker-compose build --build-arg CACHE_APT=192.168.1.55:3142

Para construir las imagenes con un repositorio de ubuntu/debian local para un solo servicio:
docker-compose build --build-arg CACHE_APT=192.168.1.55:3142 apache01

Para iniciar el laboratorio ( de nombre igual a su directorio):
docker-compose up -d

Para iniciar el laboratorio con un nombre especifico:
docker-compose -p laboratorio up -d

Para iniciar un segundo laboratorio llamado "testing" ( los puertos expuestos son agregados un "1" adelante ejem: 180,11975,13300):
docker-compose -p testing -f docker-compose.yml -f docker-compose.testing.yml up -d

Para ejecutar una imagen de inicializar en el ambiente de testing:
docker-compose -p testing -f docker-compose.yml -f docker-compose.testing.yml -f docker-compose.init.yml up -d

Para iniciar en el laboratorio "testing" solo los servicios apache01, apache02 y haproxy
docker-compose -p testing -f docker-compose.yml -f docker-compose.testing.yml up -d apache01 apache02 haproxy

Para "detener" el laboratorio:
docker-compose up -d

Para "borrar" el laboratorio:
docker-compose down

