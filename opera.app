#!/bin/bash

## Default Variables - Required ##

##### Port Number: 4600
##### Port Two: 4599
##### AppData Path: /pg/appdata/opera
##### Version Tag: latest
##### Time Zone: America/New_York
##### OperaCLI URL: https://www.linuxserver.io
##### Shm Size: 1gb
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/opera:${version_tag}
    container_name: ${app_name}
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - OPERA_CLI=${operacli_url}
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