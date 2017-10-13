#!/bin/bash

echo $1
scp ./tf2.service root@$1:/etc/systemd/system/tf2.service
scp -r ./tf root@$1:/root/tf
ssh root@$1 "bash -s" < ./install.sh
