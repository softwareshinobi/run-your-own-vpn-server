#!/bin/bash

##

reset

clear

##

set -e

set -x

killall -9 ssh

ssh -4 -L 1180:127.0.0.1:1180 softwareshinobi@aventador.embaNET.softwareshinobi.digital
