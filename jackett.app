#!/bin/bash

default_variables() {
port_number=9117
time_zone="America/New_York"
appdata_path="/pg/appdata/jackett"
path_to_blackhole="/pg/downloads/"
auto_update=true
version_tag="latest"
expose=""
}

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
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}