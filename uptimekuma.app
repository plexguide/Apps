#!/bin/bash

default_variables() {
port_number=3001
time_zone=America/New_York
appdata_path=/pg/appdata/uptimekuma
version_tag=1
expose=
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: louislam/uptime-kuma:${version_tag}
    container_name: ${app_name}
    ports:
      - "${expose}${port_number}:3001"
    volumes:
      - ${appdata_path}:/app/data
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