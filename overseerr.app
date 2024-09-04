#!/bin/bash

default_variables() {
port_number=5055
time_zone="America/New_York"
appdata_path="/pg/appdata/overseerr"
version_tag="latest"
expose=""
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/overseerr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
    ports:
      - "${expose}${port_number}:5055"
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