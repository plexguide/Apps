#!/bin/bash

deploy_container() {

    docker run -d \
      --name="${app_name}" \
      -p "${expose}""${port_number}":3001 \
      -v "${appdata_path}":/app/data \
      --restart=unless-stopped \
      louislam/uptime-kuma:1
    
    # display app deployment information
    appverify "$app_name"
}
