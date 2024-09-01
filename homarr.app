#!/bin/bash

## Default Variables - Required ##

##### Port Number: 7575
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/homarr/configs
##### Data Path: /pg/appdata/homarr/data
##### Icons Path: /pg/appdata/homarr/icons
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: ghcr.io/ajnart/homarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:7575"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${data_path}:/data
      - ${icons_path}:/app/public/icons
      - ${appdata_path}:/app/data/configs
    restart: unless-stopped
EOF
}

}