#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8444
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/heimdall
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/heimdall:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
    ports:
      - ${expose}${port_number}:80
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}
