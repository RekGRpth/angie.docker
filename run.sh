#!/bin/sh -eux

docker pull "ghcr.io/rekgrpth/angie.docker:${INPUTS_BRANCH:-latest}"
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker volume create angie
NGINX="$(docker volume inspect --format "{{ .Mountpoint }}" angie)"
touch "$NGINX/nginx.conf"
docker stop angie || echo $?
docker rm angie || echo $?
docker run \
    --detach \
    --env ASAN_OPTIONS="detect_odr_violation=0,alloc_dealloc_mismatch=false,halt_on_error=false" \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname angie \
    --mount type=bind,source="$NGINX/nginx.conf",destination=/etc/nginx/nginx.conf,readonly \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/angie,destination=/run/nginx \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=bind,source=/var/log/angie,destination=/var/log/nginx \
    --mount type=volume,source=angie,destination=/var/cache/nginx \
    --name angie \
    --publish target=443,published=443,mode=host \
    --restart always \
    --network name=docker,alias=$(hostname -f),alias=libreoffice."$(hostname -d)",alias=api-$(hostname -f),alias=graphql-$(hostname -f),alias=cas-$(hostname -f)$(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo -n ",alias=$VOLUME-$(hostname -f)"
    done) \
    $(docker volume ls --format "{{.Name}}" | while read -r VOLUME; do
        DATA="$(docker volume inspect --format "{{ .Mountpoint }}" "$VOLUME")"
        find "$DATA" -type d -name "nginx" -maxdepth 1 -mindepth 1 2>/dev/null | while read -r DIR; do
            echo "--mount type=bind,source=$DIR,destination=/etc/nginx/$VOLUME,readonly"
        done
    done) \
    "ghcr.io/rekgrpth/angie.docker:${INPUTS_BRANCH:-latest}"
