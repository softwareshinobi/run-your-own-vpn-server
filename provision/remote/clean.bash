#!/bin/bash

##

set -e

set -x

##

reset

clear

##

echo "deleting the contents of: /volumes/intranet/openvpn"

sudo rm -rf /volumes/intranet/openvpn

echo "deletion finished"

