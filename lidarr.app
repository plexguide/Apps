#!/bin/bash

# ================================ DEFAULT VALUES ================================== #

default_variables() {
    app_name=lidarr
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
    default_variables  # Initialize default variables

    create_docker_compose  # Generate the Docker Compose file
}

create_docker_compose() {
    compose_file_path="/pg/ymals/${app_name}/docker-compose.yml"
    mkdir -p "/pg/ymals/${app_name}"

    cat << 'EOF' > "$compose_file_path"
services:
  ${APP_NAME}:
    image: lscr.io/linuxserver/lidarr:${VERSION_TAG}
    container_name: ${APP_NAME}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${TIME_ZONE}
    volumes:
      - ${APPDATA_PATH}:/config
      - ${MUSIC_PATH}:/music
      - ${CLIENTDOWNLOAD_PATH}:/downloads
    restart: unless-stopped
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${APP_NAME}.rule=Host("${APP_NAME}.${TRAEFIK_DOMAIN}")'
      - 'traefik.http.routers.${APP_NAME}.entrypoints=websecure'
      - 'traefik.http.routers.${APP_NAME}.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.${APP_NAME}.loadbalancer.server.port=${PORT_NUMBER}'
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization
