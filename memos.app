#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=5230
time_zone=America/New_York
appdata_path=/pg/appdata/memos
version_tag=stable
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: neosmemo/memos:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:5230"
    volumes:
      - ${appdata_path}/.memos/:/var/opt/memos
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.${app_name}.rule=Host(\`${app_name}.${traefik_domain}\`)"
      - "traefik.http.routers.lidarr.entrypoints=websecure"
      - "traefik.http.routers.lidarr.tls.certresolver=mytlschallenge"
      - "traefik.http.services.${app_name}.loadbalancer.server.port=5230"
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