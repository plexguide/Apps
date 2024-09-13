#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=8989
time_zone=America/New_York
appdata_path=/pg/appdata/sonarr
movies_path=/pg/media/tv
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
    image: lscr.io/linuxserver/sonarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}:/config
      - ${movies_path}:/movies
      - ${clientdownload_path}:/downloads
    ports:
      - "${expose}${port_number}:8989"
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