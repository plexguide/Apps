#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8080
##### Torrenting Port: 6881
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/qbittorrent
##### Download Path: /pg/downloads/qbittorrent
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/qbittorrent:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - WEBUI_PORT=${port_number}
      - TORRENTING_PORT=${torrenting_port}
    volumes:
      - ${appdata_path}:/config
      - ${download_path}:/downloads
    ports:
      - "${expose}${port_number}:8080"
      - "${torrenting_port}:6881"
      - "${torrenting_port}:6881/udp"
    restart: unless-stopped

networks:
  plexguide:
    external: true
EOF
}

}