#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
    APP_NAME=memos
    PORT_NUMBER=5230
    TIME_ZONE=America/New_York
    APPDATA_PATH=/pg/appdata/memos
    VERSION_TAG=stable
    EXPOSE=
}

# ================================ CONTAINER DEPLOYMENT ================================ #

deploy_container() {
    default_variables  # Initialize default variables

    # Determine the env file path based on app type
    if [[ "$config_type" == "personal" ]]; then
        env_file="/pg/env/personal/${APP_NAME}.env"
    else
        env_file="/pg/env/${APP_NAME}.env"
    fi

    # Source the .env file to override default variables
    if [[ -f "$env_file" ]]; then
        set -a  # Automatically export all variables
        source "$env_file"
        set +a
    fi

    # Ensure TRAEFIK_DOMAIN is set
    if [[ -z "${TRAEFIK_DOMAIN}" ]]; then
        source "/pg/config/dns_provider.cfg"
        TRAEFIK_DOMAIN="${domain_name:-nodomain}"
    fi

    create_docker_compose  # Generate the Docker Compose file
}

create_docker_compose() {
    compose_file_path="/pg/ymals/${APP_NAME}/docker-compose.yml"
    mkdir -p "/pg/ymals/${APP_NAME}"

    cat << EOF > "$compose_file_path"
services:
  ${APP_NAME}:
    image: neosmemo/memos:${VERSION_TAG}
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

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appearance and place this for naming #### Item Title

# ================================ EXTRA FUNCTIONS ================================ #

# Call the deploy_container function if this script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    deploy_container
fi