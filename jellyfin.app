#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# ================================ DEFAULT VALUES ================================ #
# NOTE: Required for the app to function properly - Requires 5 #'s for each variable

##### Port Number: 8095
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/jellyfin
##### Movies Path: /pg/media/movies
##### TV Path: /pg/media/tv
##### JF ServerUrl: 1.1.1.1
##### Version Tag: latest
##### Expose:

# For NVIDIA Graphics Cards
##### NVIDIA Driver: all
##### NVIDIA Visible: all
##### NVIDIA Graphics: all
##### Intel GPU: /dev/dri/

# ================================ CONTAINER DEPLOYMENT ================================ #

    # Create Docker Compose YAML configuration
    create_docker_compose() {
        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/jellyfin:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - JELLYFIN_PublishedServerUrl=${jf_serverurl}
EOF

    # Check if NVIDIA devices exist
    if command -v nvidia-smi &> /dev/null; then
        cat << EOF >> docker-compose.yml
      - NVIDIA_DRIVER_CAPABILITIES=${nvidia_driver}
      - NVIDIA_VISIBLE_DEVICES=${nvidia_visible}
      - NVIDIA_GRAPHICS_CAPABILITIES=${nvidia_graphics}
EOF
        fi

        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    volumes:
      - ${appdata_path}:/config
      - ${tv_path}:/data/tvshows
      - ${movies_path}:/data/movies
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> docker-compose.yml
    devices:
      - /dev/dri:/dev/dri
EOF
        fi

        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    ports:
      - ${expose}${port_number}:8096
    networks:
      - plexguide
    restart: unless-stopped

networks:
  plexguide:
    external: true
EOF
    }

    # Generate the Docker Compose file
    create_docker_compose

    echo -e "${GREEN}${app_name} has been deployed successfully.${NC}"
}