#!/bin/bash

default_variables() {
port_number=6789
time_zone="America/New_York"
appdata_path="/pg/appdata/nzbget"
download_path="/pg/downloads/nzbget"
user_name="nzbget"
user_password="tegbzn6789"
version_tag="latest"
expose=""
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: nzbgetcom/nzbget:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - NZBGET_USER=${user_name}
      - NZBGET_PASS=${user_password}
    ports:
      - "${expose}${port_number}:6789"
    volumes:
      - ${appdata_path}:/config
      - ${download_path}:/downloads
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}