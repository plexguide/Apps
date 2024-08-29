#!/bin/bash

deploy_container() {

    # Deploy Netdata with the updated paths
    docker run -d --name="${app_name}" \
      -p "${expose}""${port_number}":19999 \
      -v "${appdata_path}"/netdataconfig:/etc/netdata \
      -v "${appdata_path}"/netdatalib:/var/lib/netdata \
      -v "${appdata_path}"/netdatacache:/var/cache/netdata \
      -v /etc/passwd:/host/etc/passwd:ro \
      -v /etc/group:/host/etc/group:ro \
      -v /proc:/host/proc:ro \
      -v /sys:/host/sys:ro \
      -v /etc/os-release:/host/etc/os-release:ro \
      --cap-add SYS_PTRACE \
      --security-opt apparmor=unconfined \
      --restart unless-stopped \
      netdata/netdata:"${version_tag}"
    
    # display app deployment information
    appverify "$app_name"
}
