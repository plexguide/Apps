#!/bin/bash

# ================================ DEFAULT VALUES ================================== #

default_variables() {
port_number=8688
time_zone=America/New_York
appdata_path=/pg/appdata/${app_name}
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
  ${app_name}:
    image: lscr.io/linuxserver/${app_name}:latest
    container_name: ${app_name}
    environment:
      - PUID=1000                     # Adjust as needed
      - PGID=1000                     # Adjust as needed
      - TZ=America/New_York           # Set your timezone
    volumes:
      - /pg/appdata/${app_name}:/config
      - /pg/media/music:/music
      - /pg/downloads:/downloads
    restart: unless-stopped
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${app_name}.rule=Host("${app_name}.${traefik_domain}.org")'
      - 'traefik.http.routers.${app_name}.entrypoints=websecure'
      - 'traefik.http.routers.${app_name}.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.${app_name}.loadbalancer.server.port=8686'
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