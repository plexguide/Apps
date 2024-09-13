#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
    app_name=memos
    port_number=5230
    time_zone=America/New_York
    appdata_path=/pg/appdata/memos
    version_tag=stable
    expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #

deploy_container() {
    default_variables  # Initialize default variables

    # Determine the config path based on app type
    if [[ "$config_type" == "personal" ]]; then
        config_file="/pg/personal_configs/${app_name}.cfg"
    else
        config_file="/pg/config/${app_name}.cfg"
    fi

    # Source the config file to override default variables
    if [[ -f "$config_file" ]]; then
        source "$config_file"
    fi

    # Ensure traefik_domain is set
    if [[ -z "${traefik_domain}" ]]; then
        source "/pg/config/dns_provider.cfg"
        traefik_domain="${domain_name:-nodomain}"
    fi

    create_docker_compose  # Generate the Docker Compose file
}

create_docker_compose() {
    compose_file_path="/pg/ymals/${app_name}/docker-compose.yml"
    mkdir -p "/pg/ymals/${app_name}"

    cat << EOF > "$compose_file_path"
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

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appearance and place this for naming #### Item Title

# ================================ EXTRA FUNCTIONS ================================ #

# Call the deploy_container function if this script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    deploy_container
fi