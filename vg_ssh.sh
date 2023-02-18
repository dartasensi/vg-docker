#!/bin/bash

VG_SSH_USER=vagrant
VG_SSH_HOST=127.0.0.1
VG_SSH_PORT=2222

VG_SSH_KEY_PATH=./.vagrant/machines/main/virtualbox/private_key

ssh -i $VG_SSH_KEY_PATH -l $VG_SSH_USER -p $VG_SSH_PORT $VG_SSH_HOST
