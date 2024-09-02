#!/bin/bash

## Default Variables - Required ##

##### AppData Path: /pg/appdata/posterizarr
##### Kometa Path: /pg/appdata/kometa
##### Time Zone: America/New_York
##### Version Tag: latest
##### RunTime: 10:30,19:30

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: ghcr.io/fscorrupt/docker-posterizarr:${version_tag}
    container_name: ${app_name}
    hostname: ${app_name}
    environment:
      - PGID=1000
      - PUID=1000
      - TZ=${time_zone}
      - UMASK=022
      - TERM=xterm
      - RUN_TIME=${runtime}
    volumes:
      - ${appdata_path}:/config:rw
      - ${kometa_path}/assets:/assets:rw
    restart: unless-stopped

networks:
  plexguide:
    external: true
EOF
}

}