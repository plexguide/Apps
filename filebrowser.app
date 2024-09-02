#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8089
##### Time Zone: America/New_York
##### File Browser: /pg/appdata/filebrowser/filebrowser.db
##### Settings JSON: /pg/appdata/filebrowser/settings.json
##### Root Path: /
##### Version Tag: latest
##### Expose:

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