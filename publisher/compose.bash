#!/bin/bash

##

reset

clear

##

set -e

set -x

##

docker compose down --remove-orphans

docker compose up --build -d 
