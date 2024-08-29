#!/bin/bash

deploy_container() {
    
    docker run -d \
      --name="${app_name}" \
      --security-opt seccomp=unconfined \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -e CHROME_CLI="${chromecli_url}" \
      -p "${expose}""${port_number}":3000 \
      -p "${expose}""${port_two}":3001 \
      -v "${appdata_path}":/config \
      --shm-size="${shm_size}" \
      --restart unless-stopped \
      lscr.io/linuxserver/ungoogled-chromium:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
