#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8989
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/sonarr
##### Movies Path: /pg/media/tv
##### ClientDownload Path: /pg/downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/sonarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
      - ${movies_path}:/movies
      - ${clientdownload_path}:/downloads
    ports:
      - "${expose}${port_number}:8989"
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}