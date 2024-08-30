#!/bin/bash

deploy_container() {

docker run -d \
    --name="${app_name}" \
    --restart=always \
    --network=host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${appdata_path}"/acme.json:/acme.json \
    -e CF_API_EMAIL="${cf_api_email}" \
    -e CF_DNS_API_TOKEN="${cf_dns_api_token}" \
    -l api.insecure=true \
    -l providers.docker=true \
    -l entrypoints.web.address=:80 \
    -l entrypoints.websecure.address=:443 \
    -l certificatesresolvers.myresolver.acme.dnschallenge=true \
    -l certificatesresolvers.myresolver.acme.dnschallenge.provider=cloudflare \
    -l certificatesresolvers.myresolver.acme.email="${your_email}" \
    -l certificatesresolvers.myresolver.acme.storage=/acme.json \
    traefik:v2.10 \
        
    # display app deployment information
    appverify "$app_name"
}
