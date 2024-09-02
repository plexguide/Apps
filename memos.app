#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/memos
##### Port Number: 5230
##### Time Zone: America/New_York
##### Version Tag: stable
##### Expose:

# Function to deploy the Memos container
deploy_container() {

    create_docker_compose() {
        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: neosmemo/memos:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:5230"
    volumes:
      - ${appdata_path}/.memos/:/var/opt/memos
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}