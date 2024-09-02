#!/bin/bash

## Default Variables - Required ##
##### AppData Path: /pg/appdata/tasks_md
##### Port Number: 8271
##### Time Zone: America/New_York
##### Version Tag: latest
##### Expose:
##### Local Images Cleanup Interval: 1440
##### Title: TaskMD

# Function to deploy the tasks.md container
deploy_container() {

    create_docker_compose() {
        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: baldissaramatheus/tasks.md:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TITLE="${title}"
      - BASE_PATH="/tasks"
      - LOCAL_IMAGES_CLEANUP_INTERVAL=${local_images_cleanup_interval}
      - TZ=${time_zone}
    ports:
      - "${expose}${port_number}:8080"
    volumes:
      - ${appdata_path}/tasks/:/tasks/
      - ${appdata_path}/config/:/config/
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}
