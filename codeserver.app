#!/bin/bash

# https://docs.linuxserver.io/images/docker-code-server/#usage

default_variables() {
port_number=8443
time_zone=America/New_York
appdata_path=/pg/appdata/codeserver
version_tag=latest
expose=
PASSWORD=                             #optional
HASHED_PASSWORD=                      #optional
SUDO_PASSWORD=                        #optional
SUDO_PASSWORD_HASH=                   #optional
PROXY_DOMAIN=                         #optional
DEFAULT_WORKSPACE=/config/workspace
}

deploy_container() {

create_docker_compose() {
cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/code-server:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
    ports:
      - ${expose}${port_number}:80
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