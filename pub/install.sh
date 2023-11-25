#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if the current user is in the "docker" group
check_docker_group() {
#  groups | grep -wq "docker"
  docker info | grep docker
}

check_docker_network_create() {
  docker network create skynet
}

# Step 0: harcode username
github_username="s-boldrin"

# Step 1: Ask for GitHub token
read -p "Enter your GitHub token: " github_token

# GitHub repository name
repo_name="skyproject-docker-compose"

# Step 2: Clone GitHub repo using the token
echo "Cloning GitHub repo..."
git clone https://${github_username}:${github_token}@github.com/skyproject-digiweb/${repo_name}.git
cd ${repo_name}
chmod +x digiweb.sh

# Step 3: Check Docker daemon and group membership
if  command_exists docker  &&  check_docker_group ; then
  echo "Docker is installed, running, and the current user is in the 'docker' group."

  if  command_exists keytool  &&  command_exists htpasswd ; then
    docker login ghcr.io -u ${github_username} -p ${github_token}
  
    # Step 4: Launch script inside the cloned repo
    echo "Launching script inside the cloned repo..."
    ./digiweb.sh install
  else
    echo "'keytool' and 'htpasswd' commands are not installed. Terminating.."
  fi
else
  echo "Docker is not installed, not running, or the current user is not in the 'docker' group."
  echo "Please make sure Docker is set up correctly before running the script."
fi
