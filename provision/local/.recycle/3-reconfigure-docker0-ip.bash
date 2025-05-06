#!/bin/bash

##

set -e

set -x

##

reset

clear

##

printf '{\n     "bip": "10.42.1.1/16",\n     "ipv6": false,\n     "fixed-cidr": "10.42.1.1/24"\n}\n' > /etc/docker/daemon.json

##

systemctl restart docker

##

ifconfig docker0

