#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=4500
port_two=4499
appdata_path=/pg/appdata/ungoogled-chromium
version_tag=latest
time_zone=Etc/UTC
chromecli_url=https://www.linuxserver.io/
shm_size=1gb  # Optional
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/ungoogled-chromium:${version_tag}
    container_name: ${app_name}
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - CHROME_CLI=${chromecli_url}
    volumes:
      - ${appdata_path}:/config
    ports:
      - "${expose}${port_number}:3000"
      - "${expose}${port_two}:3001"
    shm_size: ${shm_size}
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