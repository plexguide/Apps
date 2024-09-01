#!/bin/bash

## Default Variables - Required ##
app_name="prowlarr"
version_tag="latest"
time_zone="America/New_York"
appdata_path="/pg/appdata/prowlarr"
port_number="9696"
expose=""


deploy_container() {

    create_docker_compose() {
        cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: lscr.io/linuxserver/prowlarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
    ports:
      - ${expose}${port_number}:9696
    restart: unless-stopped
EOF
    }

}