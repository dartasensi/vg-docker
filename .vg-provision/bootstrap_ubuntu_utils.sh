#!/bin/bash

# OS update & upgrade
sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade

# Utils installation
echo "updating and installing utils packages..."
sudo apt-get -qq -y update && sudo apt-get -qq -y install \
        tree \
        screen \
		bash-completion

# Configuring screen
if [[ -f "/vagrant/.vg-provision/.screenrc" ]] ; then
  echo "applying custom screenrc to /root"
  sudo cp /vagrant/.vg-provision/.screenrc /root/
  # Ensuring the exec attrib only at user level
  sudo chmod go-x /root/.screenrc
fi
