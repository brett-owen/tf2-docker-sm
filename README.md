tf2-docker-sm
=============

**tf2-docker-sm** is a build script for a Team Fortress 2 docker container, the container is pre-configured with [Metamod:Source](https://www.sourcemm.net/) and [SourceMod](https://www.sourcemod.net/) by default, but the entire tf/ directory of the server can be overridden using attached volumes. This is useful for adding maps and configs as well.

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
Personally, I use this with a vps-hosted docker provider, like [DigitalOcean](https://www.digitalocean.com/) or [Vultr](https://www.vultr.com/), but it works fine on a local machine if you have docker installed. On a vps or a local machine you likely need to forward/unblock ports though.

I've provided installation scripts for a typical linux server, they were tested on CoreOS. Just place your desired maps/config files into the tf folder in installation and run `ssh_install.sh <SERVERIP>` from a computer with bash to quickly spin up a server.
