#!/bin/bash

## Default Variables - Required ##

##### Port Number: 5690
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/wizarr/database
##### Version Tag: latest
##### Expose:

deploy_container() {

# Function to create Docker Compose file
  create_docker_compose() {
      cat << EOF > docker-compose.yml
  version: '3.9'
  services:
    ${app_name}:
      image: ghcr.io/wizarrrr/wizarr:${version_tag}
      container_name: ${app_name}
      environment:
        - PUID=1000
        - PGID=1000
        - TZ=${time_zone}
      ports:
        - "${expose}${port_number}:5690"
      volumes:
        - ${appdata_path}:/data/database
      restart: unless-stopped
  EOF
  }

}
