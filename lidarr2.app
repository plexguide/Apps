#!/bin/bash

# ================================ DEFAULT VALUES ================================== #

default_variables() {
port_number=8686
time_zone=America/New_York
appdata_path=/pg/appdata/lidarr
music_path=/pg/media/music
clientdownload_path=/pg/downloads
version_tag=latest
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  lidarr:
    image: lscr.io/linuxserver/lidarr:latest
    container_name: lidarr
    environment:
      - PUID=1000                     # Adjust as needed
      - PGID=1000                     # Adjust as needed
      - TZ=America/New_York           # Set your timezone
    volumes:
      - /pg/appdata/lidarr:/config
      - /pg/media/music:/music
      - /pg/downloads:/downloads
    restart: unless-stopped
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.lidarr.rule=Host("lidarr.the9705.org")'
      - 'traefik.http.routers.lidarr.entrypoints=websecure'
      - 'traefik.http.routers.lidarr.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.lidarr.loadbalancer.server.port=8686'
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