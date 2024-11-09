# Empty image without base files.
FROM scratch
# Add the backup to the root of the container.
ADD backup-ros-container.tar /

# Change to user 'ros2user'.
USER ros2user
# Changes the default working directory to '/home/ros2user'.
WORKDIR /home/ros2user

# Remembers the entry point of the container.
ENTRYPOINT ["/ros_entrypoint.sh"]
# Shell session.
CMD ["bash"]
