#!/bin/bash

function install_docker() {
  # Docker official provision script
  # Instructions found on https://docs.docker.com/engine/install/ubuntu/

  DOCKER_GPG_URL='https://download.docker.com/linux/ubuntu/gpg'
  DOCKER_GPG_KEY_PATH='/usr/share/keyrings/docker-archive-keyring.gpg'
  DOCKER_REPO_URL='https://download.docker.com/linux/ubuntu'
  DOCKER_APT_REPO_PATH='/etc/apt/sources.list.d/docker.list'

  echo
  echo ">>> updating and installing packages required by Docker..."
  sudo apt-get -qq -y update && sudo apt-get -qq -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

  if [[ ! -f "${DOCKER_GPG_KEY_PATH}" ]] ; then
    echo
    echo ">>> downloading and adding Docker's official GPG key on ${DOCKER_GPG_KEY_PATH}..."
    curl -fsSL ${DOCKER_GPG_URL} | sudo gpg --dearmor -o ${DOCKER_GPG_KEY_PATH}
  fi

  if [[ ! -f "${DOCKER_APT_REPO_PATH}" ]] ; then
    echo
    echo ">>> adding the official Docker repository to the system..."
    echo "deb [arch=amd64 signed-by=${DOCKER_GPG_KEY_PATH}] ${DOCKER_REPO_URL} $(lsb_release -cs) stable" | sudo tee ${DOCKER_APT_REPO_PATH} > /dev/null
  fi

  echo
  echo ">>> installing Docker..."
  sudo apt-get -qq -y update && sudo apt-get -qq -y install \
        docker-ce \
        docker-ce-cli \
        containerd.io
}

function install_docker_compose_v1x() {
  # Docker Compose official provision instructions
  # Instructions: https://docs.docker.com/compose/install/

  DOCKER_COMPOSE_VERSION='1.29.2'
  DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
  DOCKER_COMPOSE_PATH='/usr/local/bin/docker-compose'

  DOCKER_COMPOSE_COMPLETION_URL="https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose"
  DOCKER_COMPOSE_COMPLETION_PATH='/etc/bash_completion.d/docker-compose'

  if [[ ! -f "${DOCKER_COMPOSE_PATH}" ]] ; then
    echo
    echo ">>> installing docker-compose..."
    sudo curl -fsSL ${DOCKER_COMPOSE_URL} -o ${DOCKER_COMPOSE_PATH}
    echo
    echo ">>> applying permissions to docker-compose"
    sudo chmod +x ${DOCKER_COMPOSE_PATH}
  fi

  if [[ ! -f "${DOCKER_COMPOSE_COMPLETION_PATH}" ]] ; then
    echo
    echo ">>> installing docker-compose command completion..."
    sudo curl \
      -fsSL ${DOCKER_COMPOSE_COMPLETION_URL} \
      -o ${DOCKER_COMPOSE_COMPLETION_PATH}
  fi
}

function install_docker_compose_latest() {
  # Docker Compose (latest)
  # Instructions found on https://docs.docker.com/compose/cli-command/#install-on-linux

  DOCKER_COMPOSE_VERSION='latest'
  DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/${DOCKER_COMPOSE_VERSION}/download/docker-compose-$(uname -s)-$(uname -m)"

  # change DOCKER_COMPOSE_DSTPATH according to your preferences (install for current active user or all users)
  DOCKER_COMPOSE_USER_PATH="~/.docker/cli-plugins"
  DOCKER_COMPOSE_ALLUSER_PATH="/usr/local/lib/docker/cli-plugins"
  DOCKER_COMPOSE_DSTPATH="${DOCKER_COMPOSE_ALLUSER_PATH}"
  DOCKER_COMPOSE_CMD_DSTPATH="${DOCKER_COMPOSE_DSTPATH}/docker-compose"

  echo
  echo ">>> installing Docker Compose"
  if [[ ! -f ${DOCKER_COMPOSE_CMD_DSTPATH} ]] ; then
    sudo mkdir -p ${DOCKER_COMPOSE_DSTPATH}
    sudo curl \
      -fsSL ${DOCKER_COMPOSE_URL} \
      -o ${DOCKER_COMPOSE_CMD_DSTPATH}
    sudo chmod +x ${DOCKER_COMPOSE_CMD_DSTPATH}
  fi
}

function install_docker_compose_switch_latest() {
  echo
  echo ">>> installing Docker Compose Switch"
  # NOTE: THIS automated installation DOESN'T WORK
  #sudo curl -fsSL https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh

  # manual installation
  DOCKER_COMPOSE_SWITCH_VERSION='latest'
  DOCKER_COMPOSE_SWITCH_URL="https://github.com/docker/compose-switch/releases/${DOCKER_COMPOSE_VERSION}/download/docker-compose-linux-amd64"
  DOCKER_COMPOSE_SWITCH_DSTPATH="/usr/local/bin/compose-switch"
  DOCKER_COMPOSE_V1_PATH="/usr/local/bin/docker-compose"
  DOCKER_COMPOSE_V1_ALTPATH="${DOCKER_COMPOSE_V1_PATH}-v1"

  if [[ ! -f ${DOCKER_COMPOSE_SWITCH_DSTPATH} ]] ; then
    sudo curl \
      -fsSL ${DOCKER_COMPOSE_SWITCH_URL} \
      -o ${DOCKER_COMPOSE_SWITCH_DSTPATH}
    sudo chmod +x ${DOCKER_COMPOSE_SWITCH_DSTPATH}
  fi

  ## ensure that the older version is not installed
  #if [[ -f ${DOCKER_COMPOSE_V1_PATH} ]] ; then
  #  sudo mv ${DOCKER_COMPOSE_V1_PATH} ${DOCKER_COMPOSE_V1_ALTPATH}
  #fi

  #sudo update-alternatives --install ${DOCKER_COMPOSE_V1_PATH} docker-compose ${DOCKER_COMPOSE_V1_ALTPATH} 1
  sudo update-alternatives --install ${DOCKER_COMPOSE_V1_PATH} docker-compose ${DOCKER_COMPOSE_SWITCH_DSTPATH} 99
}

# OS update
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade

# Docker
install_docker

# Docker Compose
# install latest release (currently v2.1.1)
#install_docker_compose_v1x
install_docker_compose_latest

# Docker Compose Switch
install_docker_compose_switch_latest