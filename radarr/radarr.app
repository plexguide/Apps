#!/bin/bash

deploy_container() {

    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -p "${expose}""${port_number}":7878 \
      -v "${appdata_path}":/config \
      -v "${movies_path}":/movies \
      -v "${clientdownload_path}":/downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/radarr:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
