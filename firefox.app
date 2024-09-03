#!/bin/bash

default_variables() {
port_number=4700
port_two=4699
appdata_path=/pg/appdata/firefox
version_tag=latest
time_zone=America/New_York
firefoxcli_url=https://www.linuxserver.io
shm_size=1gb
expose=
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/firefox:${version_tag}
    container_name: ${app_name}
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - FIREFOX_CLI=${firefoxcli_url}
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

# ================================ MENU GENERATION ================================ #
# NOTE: Generates Menus for the App. Requires 4 #'s' - See Wiki for Details


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization