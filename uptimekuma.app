#!/bin/bash

## Default Variables - Required ##

##### Port Number: 3001
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/uptimekuma
##### Version Tag: 1
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: louislam/uptime-kuma:${version_tag}
    container_name: ${app_name}
    ports:
      - "${expose}${port_number}:3001"
    volumes:
      - ${appdata_path}:/app/data
    restart: unless-stopped

networks:
  plexguide:
    external: true
EOF
}

# Verify the deployment
docker ps --filter name=${app_name}
echo "Logs for ${app_name}:"
docker logs ${app_name}
}