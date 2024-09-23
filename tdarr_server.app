#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=8265
port_two=8266
server_ip=0.0.0.0
time_zone=America/New_York
appdata_path=/pg/appdata/tdarr_server
media_path=/pg/media
transcode_cache_path=/pg/transcode/tdarr_server
node_name=InternalNode
internal_node=true
ffmpeg_version=6
version_tag=latest
nvidia_driver=all
nvidia_visible=all
nvidia_graphics=all
intel_gpu=/dev/dri/
}

# Note: Required to Specify the Intel GPU; example: /dev/dri/renderD128 for Tdarr to Use It
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
      - serverIP=${server_ip}
      - serverPort=${port_two}
      - webUIPort=${expose}${port_number}
      - inContainer=true
      - ffmpegVersion=${ffmpeg_version}
      - nodeName=${node_name}
      - TZ=${time_zone}
      - PUID=1000
      - PGID=1000
      - internalNode=${internal_node}
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
      - ${expose}${port_number}:8265
      - ${expose}${port_two}:8266
    logging:
      options:
        max-size: "10m"
        max-file: "5"
    restart: unless-stopped
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${app_name}.rule=Host("${app_name}.${traefik_domain}")'
      - 'traefik.http.routers.${app_name}.entrypoints=websecure'
      - 'traefik.http.routers.${app_name}.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.${app_name}.loadbalancer.server.port=${port_number}'
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization