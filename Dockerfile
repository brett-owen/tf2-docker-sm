from brettowen:tf2-docker-base

MAINTAINER Brett Owen <brett@brettowen.ca>

WORKDIR /home/steam/steamcmd/tf2/tf
RUN wget https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git959-linux.tar.gz
RUN tar -xvzf mmsource-1.10.7-git959-linux.tar.gz
RUN wget https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6027-linux.tar.gz
RUN tar -xvzf sourcemod-1.8.0-git6027-linux.tar.gz

ADD metamod.vdf /home/steam/steamcmd/tf2/tf/addons/metamod.vdf

ENV MAP="cp_badlands"
ENV SV_MAXPLAYERS=12
ENV SV_HOSTNAME="changeme"
ENV RCON_PASSWORD="changeme"
ENV SV_PORT=27015

EXPOSE 27015 27015/udp

ENTRYPOINT ["/home/steam/steamcmd/startserver.sh"]