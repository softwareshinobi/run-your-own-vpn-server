#!/bin/bash

set +e

set -x

##

reset

clear

#######################################
###
### variables inside the script
###
#######################################

VOLUME_OPENVPN_DATA="/volumes/intranet/openvpn"

EXTERNAL_IP=`curl -s http://whatismyip.akamai.com/`

CLIENT_NAME="ShinobiVPN"

##

echo

echo "vpn config / server IP / "$EXTERNAL_IP

echo "vpn config / local dir "$VOLUME_OPENVPN_DATA

echo "vpn config / client "$CLIENT_NAME

echo

##

docker run -v $VOLUME_OPENVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://$EXTERNAL_IP

docker run -v $VOLUME_OPENVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki

docker stop $CLIENT_NAME

docker rm $CLIENT_NAME -f

docker run -v $VOLUME_OPENVPN_DATA:/etc/openvpn --name $CLIENT_NAME -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

docker run -v $VOLUME_OPENVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENT_NAME nopass

docker run -v $VOLUME_OPENVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient $CLIENT_NAME > $VOLUME_OPENVPN_DATA/$CLIENT_NAME.ovpn

ls -lha $VOLUME_OPENVPN_DATA

## stop the vpn server. the compose script will call it for when we actually need it.

docker stop $CLIENT_NAME

echo "done installing and configuring Open VPN server."

