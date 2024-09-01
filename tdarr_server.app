#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# ================================ DEFAULT VALUES ================================ #
# NOTE: Required for the app to function properly - Requires 5 #'s for each variable

##### Port Number: 8265
##### Port Two: 8266
##### Server IP: 0.0.0.0
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/tdarr_server
##### Media Path: /pg/media
##### Transcode Cache Path: /pg/transcode/tdarr_server
##### Node Name: InternalNode
##### Internal Node: true
##### FFMPEG Version: 6
##### Version Tag: latest
##### NVIDIA Driver: all
##### NVIDIA Visible: all
##### NVIDIA Graphics: all

# Note: Required d to Specify the Intel GPU; example: /dev/dri/renderD128 for Tdarr to Use It
##### Intel GPU: /dev/dri/

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {
    
    # Check for Intel GPU presence
    if [[ -d "/dev/dri" ]]; then
        intel_gpu_option="--device=/dev/dri:/dev/dri"
    else
        intel_gpu_option=""
    fi

    # Create Docker Compose YAML configuration
    create_docker_compose() {
        cat << EOF > docker-compose.yml
services:
  ${app_name}:
    image: ghcr.io/haveagitgat/tdarr:${version_tag}
    container_name: ${app_name}
    network_mode: bridge
    environment:
      - serverIP=${server_ip}
      - serverPort=${port_number}
      - webUIPort=${expose}${port_number}
      - inContainer=true
      - ffmpegVersion=${ffmpeg_version}
      - nodeName=${node_name}
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
      - ${expose}${port_number}:8265
      - ${expose}${port_two}:8266
    logging:
      options:
        max-size: 10m
        max-file: 5
    restart: unless-stopped
EOF
}

}