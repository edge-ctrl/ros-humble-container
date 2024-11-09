#!/bin/bash

# Load variables
source "${PROJECT_DIR}/config.sh"
# Variables:
# CONTAINER_NAME

# Check if the container exists
if ! docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "The '${CONTAINER_NAME}' container does not exist."
    exit 1
fi
