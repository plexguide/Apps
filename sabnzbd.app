#!/bin/bash

default_variables() {
port_number=8099
time_zone=America/New_York
appdata_path=/pg/appdata/sabnzbd
download_path=/pg/downloads/nzbget/downloads/
incomplete_downloads=/pg/downloads/nzbget/incomplete_downloads
version_tag=latest
expose=
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/sabnzbd:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
      - ${download_path}:/downloads
      - ${incomplete_downloads}:/incomplete-downloads
    ports:
      - ${expose}${port_number}:8080
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}