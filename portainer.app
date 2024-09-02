#!/bin/bash

## Default Variables - Required ##

##### AppData Path: /pg/appdata/portainer
##### Port Number: 9000
##### Time Zone: America/New_York
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: portainer/portainer-ce:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}