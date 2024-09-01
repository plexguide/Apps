#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8191
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/flaresolverr
##### Version Tag: latest
##### Expose:
##### Log: info

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
services:
  ${app_name}:
    image: ghcr.io/flaresolverr/flaresolverr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - LOG_LEVEL=${log}
    volumes:
      - ${appdata_path}:/config
    ports:
      - "${expose}${port_number}:8191"
    restart: unless-stopped
EOF
}

}