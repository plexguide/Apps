#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/traefik
##### Port Number: 8075
##### Version Tag: v3.0
##### Expose:

deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: traefik:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
    volumes:
      - ${appdata_path}/traefik.toml:/etc/traefik/traefik.toml
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ${appdata_path}/acme.json:/acme.json
    ports:
      - "${expose}${port_number}:8080"
      - "80:80"
      - "443:443"
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}