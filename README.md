tf2-docker-sm
=============

**tf2-docker-bball** is a build script for a Team Fortress 2 docker container, the container is pre-configured with [Metamod:Source](https://www.sourcemm.net/) and [SourceMod](https://www.sourcemod.net/) by default, but the entire tf/ directory of the server can be overridden using attached volumes. This is useful for adding maps and configs as well.


Usage
-----
```bash
docker pull brettowen/tf2-docker-sm
docker run -it -d --network=host -v /path/to/tf:/mnt -e MAP=set_a_map -e SV_HOSTNAME="YourServerNameHere" -e SV_MAXPLAYERS=12 -e RCON_PASSWORD="ChangeThis" brettowen/tf2-docker-sm
```
The environment variables you can set are:
- MAP
- SV_HOSTNAME
- SV_MAXPLAYERS
- RCON_PASSWORD
- SV_PORT

By linking a folder containing a structure like the tf folder in Team Fortress 2 (maps/cfg/addons) you can override the defaults for the server and add maps.

For example if you link a folder using -v /path/to/your/folder:/mnt with a directory structure like the following it will override the defaults in the docker container.
```
/path/to/tf
│   maplist.txt  
│
└───cfg
│   │   server.cfg
│   │   ...
│   │
│   └───sourcemod
│       │   sourcemod.cfg
│   
└───maps
    │   your_map_here.bsp
    │   another_map_here.bsp
    |   ...
```

Installation
------------
Personally, I use this with a vps-hosted docker provider, like [DigitalOcean](https://www.digitalocean.com/) or [Vultr](https://www.vultr.com/), but it works fine on a local machine if you have docker installed. On a vps or a local machine you likely need to forward/unblock ports though. The container uses approx 600-800mb of ram when running, depending on load. Works great on a $5/mo vultr vps.

In the `install` folder I've provided an installation script for linux machines.

**Usage**
```bash
./install.sh -g --name="<SERVERNAME>" --map="<MAP>" --maxplayers="<MAXPLAYERS>" --port="<PORT>" --dyndns="<LINK TO DYNDNS UPDATE>" --rcon="<SERVERRCON>" --ip="<REMOTEIP>" --volume="<PATH>"
```
All of the options are optional, REMOTEIP is the ip of a remote server that you have ssh access to. PATH is a path to a `tf` folder containing maps, configs, and other addons.
