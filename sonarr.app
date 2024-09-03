#!/bin/bash

default_variables() {
port_number=8989
time_zone=America/New_York
appdata_path=/pg/appdata/sonarr
movies_path=/pg/media/tv
clientdownload_path=/pg/downloads
version_tag=latest
expose=
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/sonarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
      - ${movies_path}:/movies
      - ${clientdownload_path}:/downloads
    ports:
      - "${expose}${port_number}:8989"
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}