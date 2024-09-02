#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/traefik
##### Port Number: 8080
##### Time Zone: America/New_York
##### Version Tag: v3.0
##### Expose:

# Function to deploy Traefik using Docker Compose
deploy_traefik() {

    # Create Docker Compose YAML configuration for Traefik
    cat << EOF > /pg/ymals/traefik/docker-compose.yml
services:
  traefik:
    image: traefik:${version_tag}
    container_name: traefik
    restart: unless-stopped
    ports:
      - "80:80"           # HTTP
      - "443:443"         # HTTPS
      - "${expose}${port_number}:8080"  # Traefik dashboard
    volumes:
      - ${appdata_path}/traefik.toml:/etc/traefik/traefik.toml
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - web

networks:
  web:
    external: true
EOF

    echo "Traefik Docker Compose YAML configuration created."
}

deploy_traefik