#!/bin/bash

## Default Variables - Required ##
app_name="prowlarr"
version_tag="latest"
time_zone="America/New_York"
appdata_path="/pg/appdata/prowlarr"
port_number="9696"
expose=""

# Debugging: Print all variables before using them
echo "App Name: ${app_name}"
echo "Version Tag: ${version_tag}"
echo "Time Zone: ${time_zone}"
echo "AppData Path: ${appdata_path}"
echo "Port Number: ${port_number}"
echo "Expose: ${expose}"

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

    # Call the function to create docker-compose.yml
    create_docker_compose

    # Deploy using docker-compose
    echo "Deploying ${app_name}..."
    docker-compose up -d

    if [ $? -eq 0 ]; then
        echo "${app_name} deployed successfully."
    else
        echo "${app_name} failed to deploy."
    fi
}