#!/bin/bash

deploy_container() {

    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -e LOG_LEVEL="${log}" \
      -p "${expose}""${port_number}":8191 \
      -v "${appdata_path}":/config \
      --restart unless-stopped \
      ghcr.io/flaresolverr/flaresolverr:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
