#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# ================================ DEFAULT VALUES ================================ #
# NOTE: Required for the app to function properly - Requires 5 #'s for each variable

##### Port Number: 8261
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/tdarr_node1
##### Media Path: /pg/media
##### Transcode Cache Path: /pg/transcode/tdarr_node1
##### FFMPEG Version: 6
##### Version Tag: latest
##### Expose:

# For NVIDIA Graphics Cards
##### NVIDIA Driver: all
##### NVIDIA Visible: all
##### NVIDIA Graphics: all

# Note: Required to specify the Intel GPU; example: /dev/dri/renderD128 for Tdarr to use it
##### Intel GPU: /dev/dri/

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

    # Create Docker Compose YAML configuration
    create_docker_compose() {
        cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: ghcr.io/haveagitgat/tdarr:${version_tag}
    container_name: ${app_name}
    network_mode: bridge
    environment:
      - inContainer=true
      - ffmpegVersion=${ffmpeg_version}
      - TZ=${time_zone}
      - PUID=1000
      - PGID=1000
EOF

    # Check if NVIDIA devices exist
    if command -v nvidia-smi &> /dev/null; then
        cat << EOF >> docker-compose.yml
      - NVIDIA_DRIVER_CAPABILITIES=${nvidia_driver}
      - NVIDIA_VISIBLE_DEVICES=${nvidia_visible}
      - NVIDIA_GRAPHICS_CAPABILITIES=${nvidia_graphics}
EOF
        fi

        cat << EOF >> docker-compose.yml
    volumes:
      - ${appdata_path}/server:/app/server
      - ${appdata_path}/configs:/app/configs
      - ${appdata_path}/logs:/app/logs
      - ${media_path}:/media
      - ${transcode_cache_path}:/temp
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> docker-compose.yml
    devices:
      - ${intel_gpu}:/dev/dri
EOF
        fi

        cat << EOF >> docker-compose.yml
    ports:
      - ${expose}${port_number}:8261
    logging:
      options:
        max-size: 10m
        max-file: 5
    restart: unless-stopped
EOF
    }

    # Generate the Docker Compose file
    create_docker_compose

    echo -e "${GREEN}${app_name} has been deployed successfully.${NC}"
}
