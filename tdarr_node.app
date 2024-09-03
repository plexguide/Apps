#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=8261
time_zone=America/New_York
appdata_path=/pg/appdata/tdarr_node
media_path=/pg/media
transcode_cache_path=/pg/transcode/tdarr_node
ffmpeg_version=6
version_tag=latest
expose=
nvidia_driver=all
nvidia_visible=all
nvidia_graphics=all
}

# Note: Required to specify the Intel GPU; example: /dev/dri/renderD128 for Tdarr to use it
##### Intel GPU: /dev/dri/

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

    # Create Docker Compose YAML configuration
    create_docker_compose() {
        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: ghcr.io/haveagitgat/tdarr:${version_tag}
    container_name: ${app_name}
    environment:
      - inContainer=true
      - ffmpegVersion=${ffmpeg_version}
      - TZ=${time_zone}
      - PUID=1000
      - PGID=1000
EOF

    # Check if NVIDIA devices exist
    if command -v nvidia-smi &> /dev/null; then
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
      - NVIDIA_DRIVER_CAPABILITIES=${nvidia_driver}
      - NVIDIA_VISIBLE_DEVICES=${nvidia_visible}
      - NVIDIA_GRAPHICS_CAPABILITIES=${nvidia_graphics}
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    volumes:
      - ${appdata_path}/server:/app/server
      - ${appdata_path}/configs:/app/configs
      - ${appdata_path}/logs:/app/logs
      - ${media_path}:/media
      - ${transcode_cache_path}:/temp
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    devices:
      - ${intel_gpu}:/dev/dri
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    ports:
      - ${expose}${port_number}:8261
    logging:
      options:
        max-size: 10m
        max-file: 5
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}

# ================================ MENU GENERATION ================================ #
# NOTE: Generates Menus for the App. Requires 4 #'s' - See Wiki for Details


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization