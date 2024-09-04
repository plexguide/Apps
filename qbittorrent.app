#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=8080
torrenting_port=6881
time_zone=America/New_York
appdata_path=/pg/appdata/qbittorrent
download_path=/pg/downloads/qbittorrent
version_tag=latest
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/qbittorrent:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - WEBUI_PORT=${port_number}
      - TORRENTING_PORT=${torrenting_port}
    volumes:
      - ${appdata_path}:/config
      - ${download_path}:/downloads
    ports:
      - "${expose}${port_number}:8080"
      - "${torrenting_port}:6881"
      - "${torrenting_port}:6881/udp"
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