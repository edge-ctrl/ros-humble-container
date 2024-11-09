#!/bin/bash

# Load variables
source "${PROJECT_DIR}/config.sh"
# Variables:
# CONTAINER_NAME

# Executes the permissions setting on the container
docker exec -it --user root "${CONTAINER_NAME}" bash -c '
  for device in /dev/ttyUSB* /dev/ttyACM*; do
    if [ -e "$device" ]; then
      echo "Setting permissions for $device in the container"
      chown root:dialout "$device"
    fi
  done
'
