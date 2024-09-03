#!/bin/bash

default_variables() {
port_number=3579
time_zone="America/New_York"
appdata_path="/pg/appdata/ombi"
version_tag="latest"
expose=""
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/ombi:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:3579"
    volumes:
      - ${appdata_path}:/config
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}
