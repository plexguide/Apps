#!/bin/bash

## Default Variables - Required ##

##### Port Number: 6789
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/nzbget
##### Download Path: /pg/downloads/nzbget
##### User Name: nzbget 
##### User Password: tegbzn6789
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: nzbgetcom/nzbget:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - NZBGET_USER=${user_name}
      - NZBGET_PASS=${user_password}
    ports:
      - "${expose}${port_number}:6789"
    volumes:
      - ${appdata_path}:/config
      - ${download_path}:/downloads
    restart: unless-stopped
EOF
}

}