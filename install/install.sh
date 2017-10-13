#!/bin/bash

server_hostname="changeme"
server_map=cp_badlands
server_maxplayers=16
server_rcon="changeme"
server_port=27015

docker pull brettowen/tf2-docker-sm
docker create --name=bball --network=host --restart=unless-stopped -v /root/tf:/mnt -e MAP=$server_map -e SV_HOSTNAME=$server_hostname -e SV_MAXPLAYERS=$server_maxplayers -e RCON_PASSWORD=$server_rcon -e SV_PORT=$server_port brettowen/tf2-docker-sm

cp /root/tf2.service /etc/systemd/system/tf2.service
systemctl enable tf2.service

docker start bball
echo "SERVER PROVISIONED"
