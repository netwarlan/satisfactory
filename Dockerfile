## Pull our base image
FROM debian:12-slim

## Image Information
LABEL maintainer="Jeff Nelson <jeff@netwar.org>"
ARG DEBIAN_FRONTEND=noninteractive

## Set Build Arguments
ENV APP_DIR="/app" \
    GAME_DIR="/app/satisfactory" \
    GAME_USER="steam" \
    STEAMCMD_APP="1690800" \
    STEAMCMD_USER="anonymous" \
    STEAMCMD_PASSWORD="" \
    STEAMCMD_AUTH_CODE="" \
    STEAMCMD_DIR="/app/steamcmd"

## Start building our server
RUN apt update \
    && apt install -y \
        curl \
        libgcc-s1 \
        libncurses5-dev \
        lib32stdc++6 \
        libz1 \
        libtinfo5 \
        libc6 \
        zlib1g \
        libsdl2-2.0-0 \
        wget \
        unzip \
        net-tools \
    && apt clean \
    && rm -rf /var/tmp/* /var/lib/apt/lists/* /tmp/* \

    ## Create Directory Structure
    && mkdir -p $GAME_DIR \
    && mkdir -p $STEAMCMD_DIR \

    ## Create our User
    && useradd -ms /bin/bash $GAME_USER \

    ## Set Directory Permissions
    && chown -R $GAME_USER:$GAME_USER $GAME_DIR \
    && chown -R $GAME_USER:$GAME_USER $STEAMCMD_DIR

## Change to our User
USER $GAME_USER

## Download SteamCMD
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -xzC $STEAMCMD_DIR \
    && $STEAMCMD_DIR/steamcmd.sh \
        +login $STEAMCMD_USER $STEAMCMD_PASSWORD $STEAMCMD_AUTH_CODE \
        +quit \

    ## Create symlinks and appid for Steam
    && mkdir -p ~/.steam/sdk64 \
    && ln -s $STEAMCMD_DIR/linux64/steamclient.so ~/.steam/sdk64/steamclient.so \
    && echo "$STEAMCMD_APP" > $GAME_DIR/steam_appid.txt

## Copy our run script into the image
COPY run.sh $APP_DIR/run.sh

## Set working directory
WORKDIR $APP_DIR

## Start the run script
CMD ["bash", "run.sh"]