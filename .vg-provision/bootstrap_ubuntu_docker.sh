#!/bin/bash

# OS update
sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade

# Docker official provision script
# Instructions found on https://docs.docker.com/engine/install/ubuntu/

DOCKER_GPG_URL='https://download.docker.com/linux/ubuntu/gpg'
DOCKER_GPG_KEY_PATH='/usr/share/keyrings/docker-archive-keyring.gpg'
DOCKER_REPO_URL='https://download.docker.com/linux/ubuntu'
DOCKER_APT_REPO_PATH='/etc/apt/sources.list.d/docker.list'

DOCKER_COMPOSE_VERSION='1.29.0'
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
DOCKER_COMPOSE_PATH='/usr/local/bin/docker-compose'

echo "updating and installing required packages..."
sudo apt-get -qq -y update && sudo apt-get -qq -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

if [[ ! -f "${DOCKER_GPG_KEY_PATH}" ]] ; then
  echo
  echo "downloading and adding Docker's official GPG key on ${DOCKER_GPG_KEY_PATH}..."
  curl -fsSL ${DOCKER_GPG_URL} | sudo gpg --dearmor -o ${DOCKER_GPG_KEY_PATH}
fi

if [[ ! -f "${DOCKER_APT_REPO_PATH}" ]] ; then
  echo
  echo "adding the official Docker repository to the system..."
  echo "deb [arch=amd64 signed-by=${DOCKER_GPG_KEY_PATH}] ${DOCKER_REPO_URL} $(lsb_release -cs) stable" | sudo tee ${DOCKER_APT_REPO_PATH} > /dev/null
fi

echo
echo "installing docker..."
sudo apt-get -qq -y update && sudo apt-get -qq -y install \
        docker-ce \
        docker-ce-cli \
        containerd.io

# Adding docker-compose
# Instructions: https://docs.docker.com/compose/install/
if [[ ! -f "${DOCKER_COMPOSE_PATH}" ]] ; then
  echo
  echo "installing docker-compose..."
  sudo curl -fsSL ${DOCKER_COMPOSE_URL} -o ${DOCKER_COMPOSE_PATH}
fi

sudo chmod +x ${DOCKER_COMPOSE_PATH}