#!/bin/bash

deploy_container() {

    DOCKER_COMPOSE_CONTENT=$(cat <<EOF
    version: '3.9'
    services:
      ${app_name}:
        image: lscr.io/linuxserver/heimdall:${version_tag}
        container_name: ${app_name}
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=${time_zone}
        ports:
          - "${expose}${port_number}:80"
        volumes:
          - "${appdata_path}:/config"
        restart: unless-stopped
    EOF
    )

    TEMP_COMPOSE_FILE=$(mktemp)
    echo "$DOCKER_COMPOSE_CONTENT" > "$TEMP_COMPOSE_FILE"
    docker-compose -f "$TEMP_COMPOSE_FILE" up -d
    
    # display app deployment information
    appverify "$app_name"
}
