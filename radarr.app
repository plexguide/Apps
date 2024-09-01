#!/bin/bash

## Default Variables - Required ##

##### Port Number: 7878
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/radarr
##### Movies Path: /pg/media/movies
##### ClientDownload Path: /pg/downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/radarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:7878"
    volumes:
      - ${appdata_path}:/config
      - ${movies_path}:/movies
      - ${clientdownload_path}:/downloads
    restart: unless-stopped
EOF
}

}
