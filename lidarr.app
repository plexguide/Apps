#!/bin/bash

## Default Variables - Required ##

##### Port Number: 8686
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/lidarr
##### Music Path: /pg/media/music
##### ClientDownload Path: /pg/downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/lidarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:8686"
    volumes:
      - ${appdata_path}:/config
      - ${music_path}:/music
      - ${clientdownload_path}:/downloads
    restart: unless-stopped
EOF
}

}