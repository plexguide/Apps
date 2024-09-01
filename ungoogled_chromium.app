#!/bin/bash

## Default Variables - Required ##

##### Port Number: 4500
##### Port Two: 4499
##### AppData Path: /pg/appdata/ungoogled-chromium
##### Version Tag: latest
##### Time Zone: Etc/UTC
##### ChromeCLI URL: https://www.linuxserver.io/
##### Shm Size: 1gb # Optional
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: lscr.io/linuxserver/ungoogled-chromium:${version_tag}
    container_name: ${app_name}
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - CHROME_CLI=${chromecli_url}
    volumes:
      - ${appdata_path}:/config
    ports:
      - "${expose}${port_number}:3000"
      - "${expose}${port_two}:3001"
    shm_size: ${shm_size}
    restart: unless-stopped
EOF
}

}