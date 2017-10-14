#!/bin/bash

OPTS=`getopt -l name::,map::,maxplayers::,port::,logsapi::,dyndns::,rcon::,ip::,volume:: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

USESSH=false
REMOTEIP="0.0.0.0"
SVNAME="bball"
RCON="password"
MAP="ctf_ballin_skyfall"
MAXPLAYERS="8"
SVPORT="27015"
LOGSAPI=""
DYNDNS=""
USEVOL=false
DOCKERVOL=""
DOCKERIMG="brettowen/tf2-docker-sm"
CNAME="tf2"
ARGS=$@

eval set -- "$OPTS"

while true; do
    case "$1" in
        --ip )
            USESSH=true
            REMOTEIP="$2"
            shift; shift;;
        --name )
            SVNAME="$2"
            shift; shift;;
        --rcon )
            RCON="$2"
            shift; shift;;
        --map )
            MAP="$2"
            shift; shift;;
        --maxplayers )
            MAXPLAYERS="$2"
            shift; shift;;
        --port )
            SVPORT="$2"
            shift; shift;;
        --logsapi )
            LOGSAPI="$2"
            shift; shift;;
        --dyndns )
            DYNDNS="$2"
            shift; shift;;
        --volume )
            if $2; then
                USEVOL=true
            fi
            DOCKERVOL="$2"
            shift; shift;;
        -- )
            shift; break;;
        * )
            echo "Invalid option: $1" 1>&2
            exit 1;;
    esac
done

echo REMOTEIP=$REMOTEIP
echo SVNAME=$SVNAME
echo RCON=$RCON
echo CNAME=$CNAME
echo MAP=$MAP
echo MAXPLAYERS=$MAXPLAYERS
echo SVPORT=$SVPORT
echo LOGSAPI=$LOGSAPI
echo DYNDNS=$DYNDNS
echo DOCKERVOL=$DOCKERVOL

dcreate()
{
    if $USEVOL; then
        docker create \
                --name=tf2 \
                --network=host \
                --restart=unless-stopped \
                -v $DOCKERIMG:/mnt \
                -e MAP=$MAP \
                -e SV_HOSTNAME="$SVNAME" \
                -e SV_MAXPLAYERS=$MAXPLAYERS \
                -e RCON_PASSWORD="$RCON" \
                -e SV_PORT=$SVPORT \
                -e LOGS_APIKEY=$LOGSAPI \
                $DOCKERIMG
    else
        docker create \
               --name=tf2 \
               --network=host \
               --restart=unless-stopped \
               -e MAP=$MAP \
               -e SV_HOSTNAME="$SVNAME" \
               -e SV_MAXPLAYERS=$MAXPLAYERS \
               -e RCON_PASSWORD="$RCON" \
               -e SV_PORT=$SVPORT \
               -e LOGS_APIKEY=$LOGSAPI \
               $DOCKERIMG
    fi
    curl -s $DYNDNS
    docker start tf2
}

if $USESSH; then
    scp ./tf2.service root@$REMOTEIP:/etc/systemd/system/tf2.service
    if $USEVOL; then
        scp -r ./tf root@$REMOTEIP:$DOCKERVOL
    fi
    ARGS="--name='$SVNAME' --map='$MAP' --maxplayers='$MAXPLAYERS' --port='$SVPORT' --logsapi='$LOGSAPI' --dyndns='$DYNDNS' --rcon='$RCON' --volume='$DOCKERVOL'"
    echo $ARGS
    ssh root@$REMOTEIP systemctl enable tf2.service
    ssh root@$REMOTEIP "bash -s" -- < ./install.sh $ARGS
else
    dcreate
    echo "SERVER PROVISIONED"
fi
