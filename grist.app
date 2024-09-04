#!/bin/bash

default_variables() {
app_name=grist
port_number=8484
time_zone=America/New_York
appdata_path=/pg/appdata/grist
version_tag=latest
expose=
}

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

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization