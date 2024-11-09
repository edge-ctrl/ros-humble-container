#!/bin/bash
set -e # Stops the script if any command fails

# Project directory (where the scripts are located)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_DIR
# Load variables
source "${PROJECT_DIR}/config.sh"
# Variables:
# CONTAINER_NAME
# CONTAINER_FOLDER_BACKUP_USER

# Function for displaying program usage
show_usage() {
    echo "Uso: ./ros-humble-container [command]"
    echo "Commands:"
    echo "  create    		- Create a docker image and a container of '${CONTAINER_NAME}'"
    echo "  start    		- Initializes the container '${CONTAINER_NAME}'"
    echo "  restart    		- Restart the container '${CONTAINER_NAME}'"
    echo "  exec	 	  	- Execute the container '${CONTAINER_NAME}'"
    echo "  save_backup   	- Create a backup of the container in the user folder '${CONTAINER_FOLDER_BACKUP_USER}'"
    echo "  load_backup   	- Load a saved container from the user folder '${CONTAINER_FOLDER_BACKUP_USER}'"
    echo "  stop   		- Stop the container '${CONTAINER_NAME}'"
    echo "  remove   		- Removes the created image and container '${CONTAINER_NAME}'"
}

# Check if Docker is running
if ! systemctl is-active --quiet docker; then
    echo "Error: Docker is not running. Please start the Docker service and try again."
    exit 1
fi

# Actions
case "$1" in
    create)
	echo "Removing the '${CONTAINER_NAME}' container..."
	bash "${PROJECT_DIR}/scripts/remove_image.sh"
	echo "Creating the '${CONTAINER_NAME}' container..."
        bash "${PROJECT_DIR}/scripts/base-container/create_container.sh"
        ;;
    start)
	bash "${PROJECT_DIR}/scripts/check_container_exists.sh"
	echo "Starting the container '${CONTAINER_NAME}'..."
	docker start "${CONTAINER_NAME}"
	bash "${PROJECT_DIR}/scripts/serial_permissions.sh"
	if [ $? -eq 0 ]; then
	    echo "'${CONTAINER_NAME}' container successfully launched."
	fi
        ;;
    restart)
	bash "${PROJECT_DIR}/scripts/check_container_exists.sh"
	echo "Restarting the '${CONTAINER_NAME}' container..."
	docker restart "${CONTAINER_NAME}"
	bash "${PROJECT_DIR}/scripts/serial_permissions.sh"
	if [ $? -eq 0 ]; then
	    echo "'${CONTAINER_NAME}' container successfully launched."
	fi
        ;;
    exec)
	bash "${PROJECT_DIR}/scripts/check_container_exists.sh"
	echo "Executing the container '${CONTAINER_NAME}'..."
	docker exec -it "${CONTAINER_NAME}" /ros_entrypoint.sh bash
        ;;
    save_backup)
	bash "${PROJECT_DIR}/scripts/check_container_exists.sh"
        echo "Backing up the '${CONTAINER_NAME}' container..."
	bash "${PROJECT_DIR}/scripts/backup-container/save_container.sh"
	if [ $? -eq 0 ]; then
	    echo "Backup of '${CONTAINER_NAME}' container successful."
	fi
        ;;
    load_backup)
	bash "${PROJECT_DIR}/scripts/check_backup_file.sh"
	echo "Removing the '${CONTAINER_NAME}' container..."
	bash "${PROJECT_DIR}/scripts/remove_image.sh"
	echo "Loading backup..."
	bash "${PROJECT_DIR}/scripts/backup-container/load_container.sh"
        ;;
    stop)
	bash "${PROJECT_DIR}/scripts/check_container_exists.sh"
	echo "Stopping the '${CONTAINER_NAME}' container..."
	docker stop "${CONTAINER_NAME}"
	if [ $? -eq 0 ]; then
	    echo "'${CONTAINER_NAME}' container successfully stopped."
	fi
        ;;
    remove)
	echo "Removing the '${CONTAINER_NAME}' container..."
	bash "${PROJECT_DIR}/scripts/remove_image.sh"
        ;;
    *)
        show_usage
        ;;
esac
