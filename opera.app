#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=4600
port_two=4599
appdata_path=/pg/appdata/opera
version_tag=latest
time_zone=America/New_York
operacli_url=https://www.linuxserver.io
shm_size=1gb
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
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

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization