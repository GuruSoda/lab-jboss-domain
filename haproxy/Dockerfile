FROM haproxytech/haproxy-ubuntu:2.2

ENV TZ=America/Argentina/Buenos_Aires

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt upgrade -y && DEBIAN_FRONTEND=noninteractive apt install -y tzdata

