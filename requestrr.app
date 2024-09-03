#!/bin/bash

default_variables() {
port_number=4545
time_zone=America/New_York
appdata_path=/pg/appdata/requestrr
version_tag=latest
expose=
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: thomst08/requestrr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/root/config
    ports:
      - ${expose}${port_number}:4545
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}