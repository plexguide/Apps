#!/bin/bash

## Default Variables - Required ##
##### Port Number: 9117
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/jackett
##### PathTo Blackhole: /pg/downloads/
##### Auto Update: true
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/jackett:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - AUTO_UPDATE=${auto_update}
      - RUN_OPTS=\`#optional\`
    volumes:
      - ${appdata_path}:/config
      - ${pathto_blackhole}:/downloads
    ports:
      - ${expose}${port_number}:9117
    restart: unless-stopped
EOF
}

}