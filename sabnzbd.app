#!/bin/bash

## Default Variables - Required ##

##### Port Number: 9000
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/sabnzbd
##### Download Path: /pg/downloads/nzbget/downloads/
##### Incomplete Downloads: /pg/downloads/nzbget/incomplete_downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: lscr.io/linuxserver/sabnzbd:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
      - ${download_path}:/downloads
      - ${incomplete_downloads}:/incomplete-downloads
    ports:
      - ${expose}${port_number}:8080
    restart: unless-stopped
EOF
}

}