# Base image of ROS Humble.
FROM osrf/ros:humble-desktop-full-jammy

# Create the user 'ros2user'.
ARG USERNAME=ros2user
ARG USER_UID=1000
ARG USER_GID=1000

# Installation of necessary packages (sudo).
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create the group and user with sudo permissions.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add the user to the serial device permission group.
RUN usermod -aG dialout $USERNAME

# Changes the default working directory to '/home/ros2user'.
WORKDIR /home/ros2user

# Change the entrypoint to use the original ROS script.
ENTRYPOINT ["/ros_entrypoint.sh"]

# Sets the default user to the new user created.
USER $USERNAME

# Sets the default command to be interactive.
CMD ["bash"]
