#!/bin/bash

##

set -e

set -x

##

reset

clear

##

sudo bash 1-apt-software-installation.bash

sudo bash 2-install-docker-compose.bash

sudo bash 3-reconfigure-docker0-ip.bash

sudo bash 4-install-configure-openvpn.bash

echo "finished configuring vpn server"
