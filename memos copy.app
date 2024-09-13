#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
PORT_NUMBER=5230
TIME_ZONE=America/New_York
APPDATA_PATH=/pg/appdata/memos
VERSION_TAG=stable
EXPOSE=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > "/pg/ymals/${APP_NAME}/docker-compose.yml"
services:
  ${APP_NAME}:
    image: neosmemo/memos:${version_tag}
    container_name: ${APP_NAME}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${TIME_ZONE}
    ports:
      - "${EXPOSE}${PORT_NUMBER}:5230"
    volumes:
      - ${APPDATA_PATH}/.memos/:/var/opt/memos
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

}

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization