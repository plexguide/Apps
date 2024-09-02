#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/grist
##### Port Number: 8484
##### Time Zone: America/New_York
##### Version Tag: latest
##### Expose:

# Function to deploy the Grist container
deploy_container() {

    create_docker_compose() {
        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: gristlabs/grist:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:8484"
    volumes:
      - ${appdata_path}/persist:/persist
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
    }

    # Function call to create the Docker Compose YAML file
    create_docker_compose
}