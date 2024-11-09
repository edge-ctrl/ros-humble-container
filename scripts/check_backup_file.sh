#!/bin/bash

# Load variables
source "${PROJECT_DIR}/config.sh"
# Variables:
# BACKUP_FILE_CONTAINER

# Check if the file exists.
if [ ! -f "${BACKUP_FILE_CONTAINER}" ]; then
    echo "The backup '${BACKUP_FILE_CONTAINER}' file does not exist."
    exit 1
fi
