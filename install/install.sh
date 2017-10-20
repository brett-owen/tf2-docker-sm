#!/bin/bash

SVNAME="ServerName"
RCON="ServerRcon"
MAP="ctf_ballin_skyfall"
MAXPLAYERS="10"
SVPORT="27015"
LOGSAPI=7
DYNDNS=""
DOCKERVOL="/root/tf"
DOCKERIMG="brettowen/tf2-docker-bball"
CNAME="bball"

mkdir /root/tf /root/tf/maps /root/tf/addons /root/tf/cfg

docker stop $CNAME
docker rm $CNAME
docker rmi $DOCKERIMG

docker create \
       --name=$CNAME \
       --network=host \
       --restart=unless-stopped \
       -v $DOCKERVOL:/mnt \
       -e MAP=$MAP \
       -e SV_HOSTNAME="$SVNAME" \
       -e SV_MAXPLAYERS=$MAXPLAYERS \
       -e RCON_PASSWORD="$RCON" \
       -e SV_PORT=$SVPORT \
       -e LOGS_APIKEY=$LOGSAPI \
       $DOCKERIMG

curl -s $DYNDNS
docker start $CNAME
systemctl enable docker
