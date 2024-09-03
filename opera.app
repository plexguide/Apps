#!/bin/bash

default_variables() {
port_number=5055
time_zone=America/New_York
appdata_path=/pg/appdata/overseerr
version_tag=latest
expose=
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/opera:${version_tag}
    container_name: ${app_name}
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - OPERA_CLI=${operacli_url}
    ports:
      - "${expose}${port_number}:3000"
      - "${expose}${port_two}:3001"
    volumes:
      - ${appdata_path}:/config
    shm_size: ${shm_size}
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}