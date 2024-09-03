#!/bin/bash

default_variables() {
port_number=8089
time_zone="America/New_York"
file_browser="/pg/appdata/filebrowser/filebrowser.db"
settings_json="/pg/appdata/filebrowser/settings.json"
root_path="/"
version_tag="latest"
expose=""
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: filebrowser/filebrowser:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:80"
    volumes:
      - ${file_browser}:/filebrowser.db
      - ${settings_json}:/config/settings.json
      - ${root_path}:/srv
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}