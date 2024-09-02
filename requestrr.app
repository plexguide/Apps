#!/bin/bash

## Default Variables - Required ##
##### Port Number: 4545
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/requestrr
##### Version Tag: latest
##### Expose:

# Function to deploy Requestrr using Docker Compose
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: thomst08/requestrr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/root/config
    ports:
      - ${expose}${port_number}:4545
    restart: unless-stopped

networks:
  plexguide:
    external: true
EOF
}

}