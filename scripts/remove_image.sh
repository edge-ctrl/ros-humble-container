#!/bin/bash

# Load variables
source "${PROJECT_DIR}/config.sh"
# Variables:
# IMAGE_NAME
# CONTAINER_NAME

# Check if the container exists.
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    docker container rm -f "${CONTAINER_NAME}"
    if [ $? -eq 0 ]; then
        echo "The '${CONTAINER_NAME}' container was successfully removed."
    else
        echo "Error deleting container '${CONTAINER_NAME}'."
        exit 1
    fi
else
    echo "The '${CONTAINER_NAME}' container does not exist."
fi

# Check if the image exists.
if docker images --format '{{.Repository}}:{{.Tag}}' | grep -Eq "^${IMAGE_NAME}\$"; then
    docker image rm "${IMAGE_NAME}"
    if [ $? -eq 0 ]; then
        echo "The image '${IMAGE_NAME}' was successfully removed."
    else
        echo "Error deleting image '${IMAGE_NAME}'."
        exit 1
    fi
else
    echo "The image '${IMAGE_NAME}' does not exist."
fi
