
# ros-humble-container

A tool for managing Docker containers using the `osrf/ros:humble-desktop-full-jammy` image (linux/amd64)  from Open Robotics. This utility has been tested on Linux and simplifies the creation and management of a ROS 2 Humble container with full graphical and serial port support.

## Features

- **User Configuration**: Automatically creates a user in the container named `ros2user` and sets up the environment for graphical applications and serial port access.
- **User Data Access**: All user files created in the container are accessible at `/home/${USER}/ROS2-Container` on the host system.
- **Backup and Restore**: 
  - **Backup**: Creates a backup in `/home/${USER}/ROS2-Backup-Container` with a `backup-ros-container.tar` file that includes root-level container configurations, installed programs, and a backup of the user's data folder.
  - **Restore**: The `load_backup` command only restores the container configuration from `backup-ros-container.tar`. To restore user files, you must do so manually.

> **Note**: If the container is running and you connect a new serial device, you need to restart the container to ensure the device is properly detected.

## Usage

Run the script `ros-humble-container.sh` with the following commands:

- **create**: Create a Docker image and a container named `ros-humble`.
- **start**: Initializes the container `ros-humble`.
- **restart**: Restart the container `ros-humble`.
- **exec**: Execute a command inside the container `ros-humble`.
- **save_backup**: Create a backup of the container in `/home/${USER}/ROS2-Backup-Container`.
- **load_backup**: Load a saved container from `/home/${USER}/ROS2-Backup-Container`.
- **stop**: Stop the container `ros-humble`.
- **remove**: Removes the created image and container `ros-humble`.

## Setup and Requirements

- **Prerequisites**: This tool has only been tested on Linux. Ensure Docker is installed and running.
- **Running the Script**: Execute `ros-humble-container.sh` in your terminal to manage the container.
- **Simplify Usage**: Use an alias to simplify the usage of the tool. For example, you can add the following line to your `~/.bashrc` or `~/.zshrc`:

`alias ros-humble="~/path/to/ros-humble-container.sh" `

Replace `~/path/to/ros-humble-container.sh` with the actual path to the script on your system. After adding the alias, run: `source ~/.bashrc ` or: `source ~/.zshrc ` to apply the changes. Now, you can use the tool from anywhere in your terminal by typing: `ros-humble [command] `


## Implementation Details

- **Graphical Support**: The tool configures the container to support graphical applications using X11.
- **Serial Port Access**: Sets up the container for read and write access to serial ports.
- **User Folder Mapping**: Maps the container's user data folder to `/home/${USER}/ROS2-Container` on the host for easy access.

## Backup System

1. **Backup Location**: `/home/${USER}/ROS2-Backup-Container`
   - **backup-ros-container.tar**: Contains the root-level configuration and installed programs.
   - **Backup of User Folder**: A backup of the container's user folder is included separately.
2. **Restoring Data**: Use the `load_backup` command to load the `backup-ros-container.tar`. To manually restore user files, copy them from the backup location.

## Notes on Serial Device Connections

If you connect a new serial device while the container is running, restart the container for proper detection.

## Extensibility

The tool is designed to be easily adaptable for use with other Docker containers, making it a flexible solution for various ROS 2 container management needs.

## Credits

This project draws inspiration from Muhammad Luqman's work [here](https://github.com/noshluk2).
