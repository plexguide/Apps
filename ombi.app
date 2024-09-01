#!/bin/bash

## Default Variables - Required ##

##### Port Number: 3579
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/ombi
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: lscr.io/linuxserver/ombi:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:3579"
    volumes:
      - ${appdata_path}:/config
    restart: unless-stopped
EOF
}

}