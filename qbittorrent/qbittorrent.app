#!/bin/bash

deploy_container() {

    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -e WEBUI_PORT="${port_number}" \
      -e TORRENTING_PORT="${torrenting_port}" \
      -p "${expose}""${port_number}":8080 \
      -p "${torrenting_port}":6881 \
      -p "${torrenting_port}":6881/udp \
      -v "${appdata_path}":/config \
      -v "${download_path}":/downloads `#optional` \
      --restart unless-stopped \
      lscr.io/linuxserver/qbittorrent:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
