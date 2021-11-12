#!/bin/bash

function configure_bashcompletion_on () {
  BASHCOMPLETION_SCRIPT_PATH=/etc/profile.d/bash_completion.sh
  DST_PATH="$1/.bashrc"

  if [[ -f ${BASHCOMPLETION_SCRIPT_PATH} ]] ; then
    #echo "source ${BASHCOMPLETION_SCRIPT_PATH}" >> ${DST_PATH}
    echo "source ${BASHCOMPLETION_SCRIPT_PATH}" | sudo tee -a ${DST_PATH} > /dev/null

    sudo grep -wq '^source $BASHCOMPLETION_SCRIPT_PATH' ${DST_PATH} || echo 'source /etc/profile.d/bash_completion.sh'>>~/.bashrc
  fi
}

function apply_screenrc_on () {
  SRC_SCREENRC_PATH="/vagrant/.vg-provision/.screenrc"
  DST_PATH="$1/.screenrc"

  if [[ -f ${SRC_SCREENRC_PATH} ]] ; then
    echo ">>> applying custom screenrc to ${DST_PATH}"
    sudo cp ${SRC_SCREENRC_PATH} ${DST_PATH}
    if [[ -f ${DST_PATH} ]] ; then
      # Copy succeed. Ensuring the exec attrib only at user level
      sudo chmod go-x $DST_PATH
    else
      echo ">>> some errors occurred during the copy from [${SRC_SCREENRC_PATH}] to [${DST_PATH}]"
    fi
  else
    echo ">>> unable to locate the source file at [${SRC_SCREENRC_PATH}]"
  fi
}

# OS update & upgrade
export DEBIAN_FRONTEND=noninteractive
echo
echo ">>> updating OS packages..."
sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade

# Utils installation
echo
echo ">>> updating and installing utils packages..."
sudo apt-get -qq -y update && sudo apt-get -qq -y install \
        tree \
        screen \
        bash-completion

## Install and configure bash-completion
#echo
#echo ">>> installing bash-completion"
##sudo apt-get -qq -y update && sudo apt-get -qq -y install bash-completion
#configure_bashcompletion_on /root
#configure_bashcompletion_on /home/vagrant

# Install and configure screen
echo
echo ">>> installing screen"
#sudo apt-get -qq -y update && sudo apt-get -qq -y install screen
apply_screenrc_on /root
apply_screenrc_on /home/vagrant
