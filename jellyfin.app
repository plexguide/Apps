#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=8095
time_zone=America/New_York
appdata_path=/pg/appdata/jellyfin
movies_path=/pg/media/movies
tv_path=/pg/media/tv
jf_serverurl=1.1.1.1
version_tag=latest
expose=
nvidia_driver=all
nvidia_visible=all
nvidia_graphics=all
extra_path1=/pg/media
extra_path2=/pg/media
extra_path3=/pg/media
extra_path4=/pg/media
extra_path5=/pg/media
extra_path6=/pg/media
extra_path7=/pg/media
extra_path8=/pg/media
extra_path9=/pg/media
}


# ================================ CONTAINER DEPLOYMENT ================================ #

deploy_container() {

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
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
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
      - ${extra_path1}:/data1
      - ${extra_path2}:/data2
      - ${extra_path3}:/data3
      - ${extra_path4}:/data4
      - ${extra_path5}:/data5
      - ${extra_path6}:/data6
      - ${extra_path7}:/data7
      - ${extra_path8}:/data8
      - ${extra_path9}:/data9
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    devices:
      - /dev/dri:/dev/dri
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    ports:
      - ${expose}${port_number}:8096
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
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization