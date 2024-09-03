#!/bin/bash

default_variables() {
port_number=19999
time_zone="America/New_York"
appdata_path="/pg/appdata/netdata"
version_tag="latest"
expose=""
}

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: netdata/netdata:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}/netdataconfig:/etc/netdata
      - ${appdata_path}/netdatalib:/var/lib/netdata
      - ${appdata_path}/netdatacache:/var/cache/netdata
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro
    ports:
      - ${expose}${port_number}:19999
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor=unconfined
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}