#!/bin/bash

default_variables() {
appdata_path=/pg/appdata/posterizarr
kometa_path=/pg/appdata/kometa
time_zone=America/New_York
version_tag=latest
runtime=10:30,19:30
}

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