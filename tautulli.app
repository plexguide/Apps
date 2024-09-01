#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8181
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/tautulli
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/tautulli:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
    ports:
      - "${expose}${port_number}:8181"
    restart: unless-stopped
EOF
}

}