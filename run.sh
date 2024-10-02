#!/usr/bin/env bash

echo "


╔═══════════════════════════════════════════════╗
║                                               ║
║       _  _____________      _____   ___       ║
║      / |/ / __/_  __/ | /| / / _ | / _ \      ║
║     /    / _/  / /  | |/ |/ / __ |/ , _/      ║
║    /_/|_/___/ /_/   |__/|__/_/ |_/_/|_|       ║
║                                 OFFICIAL      ║
║                                               ║
╠═══════════════════════════════════════════════╣
║ Thanks for using our DOCKER image! Should you ║
║ have issues, please reach out or create a     ║
║ github issue. Thanks!                         ║
║                                               ║
║ For more information:                         ║
║ github.com/netwarlan                          ║
╚═══════════════════════════════════════════════╝"


## Set default values if none were provided
## ==============================================
[[ -z "$SATISFACTORY_SERVER_UPDATE_ON_START" ]] && SATISFACTORY_SERVER_UPDATE_ON_START=true
[[ -z "$SATISFACTORY_SERVER_VALIDATE_ON_START" ]] && SATISFACTORY_SERVER_VALIDATE_ON_START=false
[[ -z "$STEAMCMD_USER" ]] && STEAMCMD_USER="anonymous"
[[ -z "$STEAMCMD_PASSWORD" ]] && STEAMCMD_PASSWORD=""
[[ -z "$STEAMCMD_AUTH_CODE" ]] && STEAMCMD_AUTH_CODE=""




## Update on startup
## ==============================================
if [[ "$SATISFACTORY_SERVER_UPDATE_ON_START" = true ]] || [[ "$SATISFACTORY_SERVER_VALIDATE_ON_START" = true ]]; then
echo "
╔═══════════════════════════════════════════════╗
║ Checking for updates                          ║
╚═══════════════════════════════════════════════╝"
  if [[ "$SATISFACTORY_SERVER_VALIDATE_ON_START" = true ]]; then
    VALIDATE_FLAG='validate'
  else
    VALIDATE_FLAG=''
  fi

  $STEAMCMD_DIR/steamcmd.sh \
  +force_install_dir $GAME_DIR \
  +login $STEAMCMD_USER $STEAMCMD_PASSWORD $STEAMCMD_AUTH_CODE \
  +app_update $STEAMCMD_APP $VALIDATE_FLAG \
  +quit

fi


## Print Variables
## ==============================================
echo "
╔═══════════════════════════════════════════════╗
║ Server set with provided values               ║
╚═══════════════════════════════════════════════╝"
printenv | grep SATISFACTORY




## Run
## ==============================================
echo "
╔═══════════════════════════════════════════════╗
║ Starting Server                               ║
╚═══════════════════════════════════════════════╝"

$GAME_DIR/FactoryServer.sh -unattended