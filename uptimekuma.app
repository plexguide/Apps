#!/bin/bash

## Default Variables - Required ##

##### Port Number: 3001
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/uptimekuma
##### Version Tag: 1
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: louislam/uptime-kuma:${version_tag}
    container_name: uptimekuma
    ports:
      - "${expose}${port_number}:3001"
    volumes:
      - ${appdata_path}:/app/data
    restart: unless-stopped
EOF
}

# Verify the deployment
docker ps --filter name=${app_name}
echo "Logs for ${app_name}:"
docker logs ${app_name}
}