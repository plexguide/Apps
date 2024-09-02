#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/traefik
##### Port Number: 8075
##### Version Tag: v3.0
##### Expose:
##### Traefik Domain: null

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
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ${appdata_path}/traefik.yaml:/etc/traefik/traefik.yaml:ro  
      - ${appdata_path}/dynamic.yaml:/etc/traefik/dynamic.yaml:ro  
      - ${appdata_path}/acme.json:/etc/traefik/acme.json
    labels:
      - "traefik.enable=true"
      - "traefik.http.middlewares.traefik-auth.basicauth.removeheader=true"
      - "traefik.http.middlewares.traefik-auth.basicauth.users=foobar:$$2y$$05$$z2KwKI.GmZ43BbwfmPPKw.CSl3rqQ0OhzBbdom.orfsMVKGLW/Xeu" # CHANGE PASSWORD!! (user: foobar / pwd: foobar)
      - "traefik.http.routers.traefik.rule=Host(`${traefik_domain}`)"
      - "traefik.http.routers.traefik.service=api@internal"
      - "traefik.http.routers.traefik.tls.certresolver=tlschallenge"
      - "traefik.http.routers.traefik.entrypoints=web-secure"
      - "traefik.http.routers.traefik.middlewares=traefik-auth, secHeaders@file, autodetectContenttype@file"
      - "traefik.http.services.traefik.loadbalancer.server.port=8080"
    ports:
      - "${expose}${port_number}:8080"
      - "80:80"
      - "443:443"
    restart: unless-stopped
    networks:
      - plexguide

  # whoami example container
  whoami:
    image: traefik/whoami:latest
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.entrypoints=web-secure"
      - "traefik.http.routers.whoami.rule=Host(`${traefik_domain}`)"
      - "traefik.http.routers.whoami.tls=true"
      - "traefik.http.routers.whoami.tls.certresolver=tlschallenge"
      - "traefik.http.routers.whoami.middlewares=secHeaders@file"
      - "traefik.http.services.whoami.loadbalancer.server.port=80"
    networks:
      - plexguide

networks:
  plexguide:
    external: true
    name: plexguide
EOF
}

}

# NOTE $ TESTING

# how to set a real password:
# sudo apt-get install apache2-utils
# htpasswd -Bnb username password | sed -e s/\\$/\\$\\$/g
# Helping Credit: https://github.com/wollomatic/simple-traefik/blob/master/docker-compose.yaml