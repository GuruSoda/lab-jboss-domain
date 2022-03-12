# Laboratorio para probar JBoss Domain Mode

*Laboratorio para probar JBoss en modo dominio creado en docker-compose y docker puro, contiene 1 haproxy, 2 apache, 1 domain controller, 1 backup domain controller, 3 slave/workers y un navegador web opcional dentro de la red interna*

## Laboratorio con Docker Compose:

### Construccion de las imagenes:
```
docker-compose build
```

### Construir las imagenes con repositorio alternativo de ubuntu/debian:
```
docker-compose build --build-arg CACHE_APT=IP:PORT
```

### Construir las imagenes con un repositorio de ubuntu/debian alternativo para un solo servicio:
```
docker-compose build --build-arg CACHE_APT=IP:PORT apache01
```

### Iniciar el laboratorio (de nombre igual a su directorio):
```
docker-compose up -d
```

### Incorporar un navegador Firefox en el laboratorio:
```
docker-compose up -d --scale firefox=1
```

### Inicializar el dominio con server-groups y aplicaciones:
```
docker-compose exec master /entrypoint.sh init
```

### Detener el laboratorio:
```
docker-compose stop
```

### Borrar el laboratorio:
```
docker-compose down
```

### Iniciar el laboratorio con un nombre especifico:
```
docker-compose -p laboratorio up -d
```

### Iniciar un segundo laboratorio llamado "testing" ( los puertos expuestos son agregados un "1" adelante ejem: 180,11975,13300):
```
docker-compose -p testing -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.testing.yml up -d
```

### Ejecutar un contenedor de inicializacion del ambiente de testing:
```
docker-compose -p testing -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.testing.yml up -d --scale init=1
```

### Iniciar en el laboratorio "testing" solo los servicios apache01, apache02 y haproxy
```
docker-compose -p testing -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.testing.yml up -d apache01 apache02 haproxy
```

## Laboratorio con Docker:

### Construir las imagenes:
```
./laboratorio.sh construir
```

### Construir los contenedores:
```
./laboratorio.sh crear 
```

### Iniciar el laboratorio:
```
./laboratorio.sh iniciar
```

### Detener el laboratorio:
```
./laboratorio.sh detener
```

### Borrar el laboratorio:
```
./laboratorio.sh borrar
```

### Inicializar el laboratorio:
*Configura servers groups y agrega ejemplos al repositorio*
```
./laboratorio.sh init
```

### Estado del laboratorio:
```
./laboratorio.sh status
```

### Navegador Firefox dentro de la red del laboratorio:
```
./laboratorio.sh firefox
```

