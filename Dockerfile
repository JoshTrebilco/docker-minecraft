FROM java:8

MAINTAINER joshtrebilco

ENV APT_GET_UPDATE 2016-04-23
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  imagemagick \
  lsof \
  nano \
  sudo \
  vim \
  jq \
  && apt-get clean

RUN useradd -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && mkdir /data/world \
  && mkdir /data/world_the_end \
  && mkdir /data/world_nether \
  && mkdir /config \
  && mkdir /mods \
  && mkdir /plugins \
  && mkdir /home/minecraft \
  && chown minecraft:minecraft /data /data/world /data/world_the_end /data/world_nether /config /mods /plugins /home/minecraft

EXPOSE 25565 25575

ADD https://github.com/itzg/restify/releases/download/1.0.3/restify_linux_amd64 /usr/local/bin/restify
COPY start.sh /start
COPY start-minecraft.sh /start-minecraft
COPY mcadmin.jq /usr/share
RUN chmod +x /usr/local/bin/*

VOLUME ["/data","/data/world","/data/world_the_end","/data/world_nether","/mods","/config","/plugins","/home/minecraft"]
COPY server.properties /tmp/server.properties
WORKDIR /data

ENTRYPOINT [ "/start" ]

ENV UID=1000 GID=1000 \
    MOTD="MOTD from repo Dockerfile" \
    JVM_OPTS="-Xmx1024M -Xms1024M" \
    TYPE=VANILLA VERSION=LATEST LEVEL=world PVP=true DIFFICULTY=easy \
    LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK= ONLINE_MODE=TRUE CONSOLE=true
