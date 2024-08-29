#!/bin/bash

deploy_container() {

    docker run -d \
          --name="${app_name}" \
          -e PUID=1000 \
          -e PGID=1000 \
          -e TZ="${time_zone}" \
          -e NZBGET_USER="${user_name}" `#optional` \
          -e NZBGET_PASS="${user_password}" `#optional` \
          -p "${expose}""${port_number}":6789 \
          -v "${appdata_path}":/config \
          -v "${download_path}":/downloads \
          --restart unless-stopped \
          nzbgetcom/nzbget:"${version_tag}"
        
    # display app deployment information
    appverify "$app_name"
}
