#!/bin/bash

##

set -e

set -x

##

reset

clear

##

sudo bash 1-apt-software-installation.bash

sudo bash 2-install-openvpn-client.bash

echo "finished configuring vpn server"
