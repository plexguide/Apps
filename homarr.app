#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=7575
time_zone=America/New_York
appdata_path=/pg/appdata/homarr/configs
data_path=/pg/appdata/homarr/data
icons_path=/pg/appdata/homarr/icons
version_tag=latest
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: ghcr.io/ajnart/homarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:7575"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${data_path}:/data
      - ${icons_path}:/app/public/icons
      - ${appdata_path}:/app/data/configs
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