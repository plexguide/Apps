#!/bin/bash

deploy_container() {

    # Run the Docker container with the specified settings
    docker run -d \
      --name="${app_name}" \
      --network=host \
      -v "${config_path}:/config" \
      --restart unless-stopped \
      itstoggle/plex_debrid:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
