#!/bin/bash

# Load variables
source "${PROJECT_DIR}/config.sh"
# Variables:
# USER_CONTAINER
# IMAGE_NAME
# CONTAINER_NAME
# CONTAINER_FOLDER_USER
# CONTAINER_FOLDER_BACKUP_USER

# Directory of the current script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create the Docker image using the Dockerfile in the same directory as the script.
#
# Moving the dockerfile into context the location of the backup file
cp "${SCRIPT_DIR}/Dockerfile" "${CONTAINER_FOLDER_BACKUP_USER}"
cd "${CONTAINER_FOLDER_BACKUP_USER}"

docker build -t ${IMAGE_NAME} .
if [ $? -eq 0 ]; then
    echo "The image '${IMAGE_NAME}' successfully created."
else
    echo "Error creating the image."
    exit 1
fi

# Deleting dockerfile file
rm "${CONTAINER_FOLDER_BACKUP_USER}/Dockerfile"

#Container Creation.
#user -> ros2user.
mkdir "${CONTAINER_FOLDER_USER}"

xhost local:"${USER_CONTAINER}"

XAUTH=/tmp/.docker.xauth

docker create -it \
  --name="${CONTAINER_NAME}" \
  --user "${USER_CONTAINER}" \
  -v /home/"${USER}"/ROS2-Container:/home/"${USER_CONTAINER}" \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --env="ROS_DISTRO=humble" \
  --env="XDG_RUNTIME_DIR=/tmp/runtime-ros2user" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --env="XAUTHORITY=$XAUTH" \
  --volume="$XAUTH:$XAUTH" \
  --net=host \
  --privileged \
  "${IMAGE_NAME}" \
  bash

# Check if the container was created successfully.
if [ $? -eq 0 ]; then
    echo "The '${CONTAINER_NAME}' container successfully created."
else
    echo "Error creating container."
    exit 1
fi
