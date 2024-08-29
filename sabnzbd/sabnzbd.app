#!/bin/bash

deploy_container() {

    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -p "${expose}""${port_number}":8080 \
      -v "${appdata_path}":/config \
      -v "${download_path}":/downloads \
      -v "${incomplete_downloads}":/incomplete-downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/sabnzbd:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
