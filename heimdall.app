#!/bin/bash

default_variables() {
port_number=8444
time_zone=America/New_York
appdata_path=/pg/appdata/heimdall
version_tag=latest
expose=
}

deploy_container() {

create_docker_compose() {
cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/heimdall:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
    ports:
      - ${expose}${port_number}:80
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}
