#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# ================================ DEFAULT VALUES ================================ #
# NOTE: Required for the app to function properly - Requires 5 #'s for each variable

##### Media Path: /pg/media
##### Port Number: 32400
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/plex
##### Plex Token: null
##### Version Tag: latest
##### Expose:
##### NVIDIA Driver: all
##### NVIDIA Visible: all
##### NVIDIA Graphics: all

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

if lspci | grep -i 'nvidia' &> /dev/null; then
    nvidia_options="-e NVIDIA_DRIVER_CAPABILITIES=\"${nvidia_driver}\" -e NVIDIA_VISIBLE_DEVICES=\"${nvidia_visible}\" --gpus=\"${nvidia_graphics}\""; else
    nvidia_options=""; fi

    # If no token exists, prompts user to create one for the claim
    check_plex_token_default

create_docker_compose() {
    cat << EOF > docker-compose.yml
version: '3.9'
services:
  ${app_name}:
    image: lscr.io/linuxserver/plex:${version_tag}
    container_name: ${app_name}
    network_mode: host
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - VERSION=docker
      - PLEX_CLAIM=${plex_token}
EOF

    # Check if NVIDIA devices exist
    if command -v nvidia-smi &> /dev/null; then
        cat << EOF >> docker-compose.yml
      - NVIDIA_DRIVER_CAPABILITIES=${nvidia_driver}
      - NVIDIA_VISIBLE_DEVICES=${nvidia_visible}
      - NVIDIA_GRAPHICS_CAPABILITIES=${nvidia_graphics}
EOF
    fi

    cat << EOF >> docker-compose.yml
    volumes:
      - ${appdata_path}:/config
      - ${media_path}:/media
      - realdebrid:/torrents
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> docker-compose.yml
    devices:
      - /dev/dri:/dev/dri
EOF
    fi

    cat << EOF >> docker-compose.yml
    restart: unless-stopped
EOF
}

}

# ================================ MENU GENERATION ================================ #
# NOTE: Generates Menus for the App. Requires 4 #'s'

#### Plex Token
plex_token() {
    clear
    
    # Source the configuration file to get the current plex_token value
    if [[ -f "$config_path" ]]; then
        source "$config_path"
    fi

    echo "Current Token: $plex_token"
    echo -e "Note: Changing the token will stop the Docker containers and require manual redeployment."
    echo -e "\nPlease enter your new Plex Token from https://plex.tv/claim"
    echo -e "Type [${GREEN}Z${NC}] to exit or to skip entering a token, type: ${RED}no-token${NC}"
    echo ""
    
    while true; do
        read -p "Plex Token: " new_token
        
        if [[ "${new_token,,}" == "z" ]]; then
            echo "Operation cancelled."
            return
        elif [[ "$new_token" =~ "no-token" || "$new_token" =~ ^claim ]]; then
            plex_token="$new_token"
            # Update the config file with the new token
            sed -i "s|^plex_token=.*|plex_token=$plex_token|" "$config_path"
            echo "Plex token updated successfully."
            
            # Stop and remove the Docker container
            docker stop "$app_name"
            docker rm "$app_name"
            echo "Docker container killed. You will need to redeploy manually."
            break
        else
            clear
            echo -e "${RED}Invalid input.${NC} Please enter a valid token, type ${RED}no-token${NC}, or type [${GREEN}Z${NC}] to exit."
        fi
    done
}

# ================================ EXTRA FUNCITONS ================================ #
# NOTE: Extra Functions for Script Orgnaization

check_plex_token_default() {
    # Check and update the Plex token if necessary
    if [[ "$plex_token" == "null" || ( ! "$plex_token" =~ ^claim && "$plex_token" != "no-token" ) ]]; then
        clear
        echo -e "${RED}The Plex Token needs to be updated${NC}"
        echo -e "A. Please enter your Plex Token from https://plex.tv/claim"
        echo -e "B. To skip entering a token, type: ${RED}no-token${NC}\n"
        while true; do
            read -p "Plex Token: " new_token
            if [[ "$new_token" == "no-token" || "$new_token" =~ ^claim ]]; then
                plex_token="$new_token"
                # Update the config file with the new token
                sed -i "s|^plex_token=.*|plex_token=$plex_token|" "$config_path"
                docker stop "$app_name" && docker rm "$app_name"  # Kill the Docker container if token changes
                break
            else
                echo "Invalid token format. Please ensure the token starts with 'claim-' or type 'no-token'."
                clear
                echo -e "${RED}The Plex Token needs to be updated${NC}"
                echo -e "A. Please enter your Plex Token from https://plex.tv/claim"
                echo -e "B. To skip entering a token, type: ${RED}no-token${NC}\n"
            fi
        done
    fi
}