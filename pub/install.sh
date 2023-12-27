#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if the current user is in the "docker" group
check_docker_group() {
  groups | grep -wq "docker"
#  docker info | grep docker
}

check_docker_network_create() {
  docker network create skynet
}

# Step -1: Check dependencies
# ... git
if  command_exists git ; then
  echo "Git is installed"
else
  echo "Git is not installed."
  echo "Please make sure Git is set up correctly before running the script."
  exit 1
fi

# ... docker
if  command_exists docker  &&  check_docker_group ; then
  echo "Docker is installed, running, and the current user is in the 'docker' group."
else
  echo "Docker is not installed, not running, or the current user is not in the 'docker' group."
  echo "Please make sure Docker is set up correctly before running the script."
  exit 1
fi

# Step 0: harcode username
github_username="digiweb-dev"

# Step 1: Ask for GitHub token
read -p "Enter your GitHub token: " github_token

# GitHub repository name
repo_name="skyproject-docker-compose"

# Step 2: Clone GitHub repo using the token
echo "Cloning GitHub repo..."
git clone --depth=1 https://${github_username}:${github_token}@github.com/skyproject-digiweb/${repo_name}.git digiweb
if [ $? -ne 0 ]; then
  exit 1
fi
cd digiweb
chmod +x digiweb.sh

docker login ghcr.io -u ${github_username} -p ${github_token}
if [ $? -ne 0 ]; then
  exit 1
fi

./digiweb.sh install

