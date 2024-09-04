#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Path to the configuration file
config_path="/pg/config/${app_name}.cfg"

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=4748
appdata_path=/pg/appdata/vaultwarden
signups_enabled=false
websocket_enabled=false
admin_token=null
version_tag=latest
expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

    # Check and update the Vaultwarden admin token if necessary
    check_and_update_vaultwarden_token

    create_docker_compose() {
        # Ensure the directory for the YAML file exists
        mkdir -p /pg/ymals/${app_name}

        cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: vaultwarden/server:${version_tag}
    container_name: ${app_name}
    environment:
      - SIGNUPS_ALLOWED=${signups_allowed}
      - WEBSOCKET_ENABLED=${websocket_enabled}
      - ADMIN_TOKEN=${admin_token}
    volumes:
      - ${appdata_path}:/data
    ports:
      - ${expose}${port_number}:80
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
#### Admin Token
    clear

    # Source the configuration file to get the current admin token value
    if [[ -f "$config_path" ]]; then
        source "$config_path"
    else
        echo -e "${RED}Configuration file not found at $config_path.${NC}"
        return
    fi

    # Display current token, handle if it's null
    if [[ "$admin_token" == "null" || -z "$admin_token" ]]; then
        echo "Current Admin Token: Not set"
    else
        echo "Current Admin Token: $admin_token"
    fi

    echo -e "Note: Changing the admin token will stop the Docker container and require manual redeployment."
    echo -e "\nPlease enter your new Vaultwarden Admin Token (minimum 12 characters)"
    echo -e "Type [${GREEN}Z${NC}] to exit.\n"

    while true; do
        read -p "Admin Token: " new_token

        if [[ "${new_token,,}" == "z" ]]; then
            echo "Operation cancelled."
            return
        elif [[ ${#new_token} -ge 12 ]]; then
            admin_token="$new_token"
            # Check if the config file exists before using sed
            if [[ -f "$config_path" ]]; then
                sed -i "s|^admin_token=.*|admin_token=$admin_token|" "$config_path"
                echo "Admin token updated successfully."
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
            echo -e "${RED}Invalid input.${NC} The token must be at least 12 characters long."
        fi
    done
}

# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization

check_and_update_vaultwarden_token() {
    # Check and update the Vaultwarden admin token if necessary
    if [[ "$admin_token" == "null" || ${#admin_token} -lt 12 ]]; then
        clear
        echo -e "${RED}The Vaultwarden Admin Token needs to be updated${NC}"
        echo -e "Please enter your Vaultwarden Admin Token (minimum 12 characters)"
        
        while true; do
            read -p "Admin Token: " new_token
            if [[ ${#new_token} -ge 12 ]]; then
                admin_token="$new_token"
                # Update the config file with the new token
                if [[ -f "$config_path" ]]; then
                    sed -i "s|^admin_token=.*|admin_token=$admin_token|" "$config_path"
                    docker stop "$app_name" && docker rm "$app_name"  # Kill the Docker container if token changes
                else
                    echo -e "${RED}Error: Configuration file $config_path not found. Cannot update token.${NC}"
                fi
                break
            else
                clear
                echo -e "${RED}Invalid input.${NC} The token must be at least 12 characters long."
                echo -e "Please enter a valid token."
            fi
        done
    fi
}