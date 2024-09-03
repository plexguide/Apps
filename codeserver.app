#!/bin/bash

# https://docs.linuxserver.io/images/docker-code-server/#usage

default_variables() {
port_number=8443
time_zone=America/New_York
appdata_path=/pg/appdata/codeserver
version_tag=latest
expose=
password=                             #optional
hashed_passowrd=                      #optional
sudo_password=                        #optional
sudo_password_hash=                   #optional
default_workspace=/config/workspace   #optional
proxy_domain=code-server.my.domain    #optional
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
      - PASSWORD=${password}
      - HASHED_PASSOWRD=${hashed_passowrd}
      - SUDO_PASSWORD=${sudo_password}
      - SUDO_PASSWORD_HASH=${sudo_password_hash}
      - PROXY_DOMAIN=${proxy_domain}
      - DEFAULT_WORKSPACE=${default_workspace}
    volumes:
      - ${appdata_path}:/config
    ports:
      - ${expose}${port_number}:8443
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