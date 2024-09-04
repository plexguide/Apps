#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Path to the configuration file
config_path="/pg/config/${app_name}.cfg"

# ================================ DEFAULT VALUES ================================ #

default_variables() {
media_path=/pg/media
port_number=32400
time_zone=America/New_York
appdata_path=/pg/appdata/plex
plex_token=null
version_tag=latest
expose=
nvidia_driver=all
nvidia_visible=all
nvidia_graphics=all
extra_path1=/pg/media
extra_path2=/pg/media
extra_path3=/pg/media
extra_path4=/pg/media
extra_path5=/pg/media
extra_path6=/pg/media
extra_path7=/pg/media
extra_path8=/pg/media
extra_path9=/pg/media
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

    # If no token exists, prompts user to create one for the claim
    check_plex_token_default

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
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
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
      - NVIDIA_DRIVER_CAPABILITIES=${nvidia_driver}
      - NVIDIA_VISIBLE_DEVICES=${nvidia_visible}
      - NVIDIA_GRAPHICS_CAPABILITIES=${nvidia_graphics}
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    volumes:
      - ${appdata_path}:/config
      - ${media_path}:/media
      - ${extra_path1}:/media1
      - ${extra_path2}:/media2
      - ${extra_path3}:/media3
      - ${extra_path4}:/media4
      - ${extra_path5}:/media5
      - ${extra_path6}:/media6
      - ${extra_path7}:/media7
      - ${extra_path8}:/media8
      - ${extra_path9}:/media9
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    devices:
      - /dev/dri:/dev/dri
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    restart: unless-stopped
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}

# ================================ MENU GENERATION ================================ #
# NOTE: Generates Menus for the App. Requires 4 #'s'

menu1() {
#### Plex Token    
    clear
    
    # Source the configuration file to get the current plex_token value
    if [[ -f "$config_path" ]]; then
        source "$config_path"
    else
        echo -e "${RED}Configuration file not found at $config_path.${NC}"
        return
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
            # Check if the config file exists before using sed
            if [[ -f "$config_path" ]]; then
                sed -i "s|^plex_token=.*|plex_token=$plex_token|" "$config_path"
                echo "Plex token updated successfully."
            else
                echo -e "${RED}Error: Configuration file $config_path not found. Cannot update token.${NC}"
            fi
            
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

menu2() {
#### Plex Token2   
    clear
    
    # Source the configuration file to get the current plex_token value
    if [[ -f "$config_path" ]]; then
        source "$config_path"
    else
        echo -e "${RED}Configuration file not found at $config_path.${NC}"
        return
    fi

    echo "Current Token2: $plex_token"
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
            # Check if the config file exists before using sed
            if [[ -f "$config_path" ]]; then
                sed -i "s|^plex_token=.*|plex_token=$plex_token|" "$config_path"
                echo "Plex token updated successfully."
            else
                echo -e "${RED}Error: Configuration file $config_path not found. Cannot update token.${NC}"
            fi
            
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

menu3 () {
#### Bad Guy
    echo "Hello!"
    read -p "Press [Enter] to acknowledge..."
}

# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization

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
                # Check if the config file exists before using sed
                if [[ -f "$config_path" ]]; then
                    sed -i "s|^plex_token=.*|plex_token=$plex_token|" "$config_path"
                    docker stop "$app_name" && docker rm "$app_name"  # Kill the Docker container if token changes
                else
                    echo -e "${RED}Error: Configuration file $config_path not found. Cannot update token.${NC}"
                fi
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
