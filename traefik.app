#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/traefik
##### Port Number: 8080
##### Version Tag: v3.0
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: traefik:${version_tag}
    container_name: ${app_name}
    ports:
      - "80:80"           # HTTP
      - "443:443"         # HTTPS
      - "${expose}${port_number}:8080"  # Traefik dashboard
    volumes:
      - ${appdata_path}/traefik.toml:/etc/traefik/traefik.toml
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}