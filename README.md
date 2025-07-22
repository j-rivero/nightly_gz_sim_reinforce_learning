# Gazebo Reinforcement Learning Docker

This Docker container provides a complete environment for running reinforcement learning experiments with Gazebo simulation. It includes Gazebo Sim with nightly builds, Stable Baselines3, and a simple cart pole reinforcement learning example.

## Building the Docker Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t rl_gazebo .
```

## Running the Container

To run the container with X11 forwarding and NVIDIA GPU support, use rocker:

```bash
rocker --x11 --nvidia -- rl_gazebo
```

This will:

- Enable X11 forwarding for GUI applications
- Provide access to NVIDIA GPU (if available)
- Start the reinforcement learning training automatically

## Viewing the Simulation

To visualize the Gazebo simulation while the container is running, you can execute the Gazebo GUI in the running container:

1. First, find the running container ID:

   ```bash
   docker ps
   ```

2. Then execute the Gazebo GUI:

   ```bash
   docker exec -it <container_id> gz sim -g
   ```

   Replace `<container_id>` with the actual container ID from step 1.

## What's Included

- **Base OS**: Ubuntu Noble (24.04)
- **Gazebo**: Latest nightly build of Gazebo Sim 10
- **Python Environment**: Virtual environment with Stable Baselines3 and dependencies
- **Example**: Simple cart pole reinforcement learning environment
- **GPU Support**: Configured to work with NVIDIA GPUs through rocker

## Environment Details

The container automatically:

- Sets up a Python virtual environment at `/opt/RL/venv`
- Installs Stable Baselines3 with extra dependencies
- Clones the Gazebo source code with RL examples
- Configures environment variables for proper operation
- Starts the cart pole training example on container startup

## Prerequisites

- Docker installed on your system
- [rocker](https://github.com/osrf/rocker) for X11 and NVIDIA support
- NVIDIA Docker runtime (for GPU acceleration)
