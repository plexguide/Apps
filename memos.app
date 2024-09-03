#!/bin/bash

default_variables() {
port_number=5230
time_zone=America/New_York
appdata_path=/pg/appdata/memos
version_tag=stable
expose=
}

deploy_container() {

    create_docker_compose() {
        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: neosmemo/memos:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:5230"
    volumes:
      - ${appdata_path}/.memos/:/var/opt/memos
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}