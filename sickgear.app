#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8081
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/sickgear
##### TV Path: /pg/media/tv
##### Download Path: /pg/downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/sickgear:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
      - ${tv_path}:/tv
      - ${download_path}:/downloads
    ports:
      - "${expose}${port_number}:8081"
    restart: unless-stopped
EOF
}

}