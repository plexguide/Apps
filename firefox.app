#!/bin/bash

## Default Variables - Required ##

##### Port Number: 4700
##### Port Two: 4699
##### AppData Path: /pg/appdata/firefox
##### Version Tag: latest
##### Time Zone: America/New_York
##### FirefoxCLI URL: https://www.linuxserver.io
##### Shm Size: 1gb
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: lscr.io/linuxserver/firefox:${version_tag}
    container_name: ${app_name}
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - FIREFOX_CLI=${firefoxcli_url}
    ports:
      - "${expose}${port_number}:3000"
      - "${expose}${port_two}:3001"
    volumes:
      - ${appdata_path}:/config
    shm_size: ${shm_size}
    restart: unless-stopped
EOF
}

}