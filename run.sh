#!/usr/bin/env bash
set -e

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
SATISFACTORY_SERVER_UPDATE_ON_START="${SATISFACTORY_SERVER_UPDATE_ON_START:-true}"
SATISFACTORY_SERVER_VALIDATE_ON_START="${SATISFACTORY_SERVER_VALIDATE_ON_START:-false}"
SATISFACTORY_SERVER_UPDATE_ONLY_THEN_STOP="${SATISFACTORY_SERVER_UPDATE_ONLY_THEN_STOP:-false}"
SATISFACTORY_SERVER_VALIDATE_ONLY_THEN_STOP="${SATISFACTORY_SERVER_VALIDATE_ONLY_THEN_STOP:-false}"
SATISFACTORY_MAXPLAYERS="${SATISFACTORY_MAXPLAYERS:-8}"
STEAMCMD_USER="${STEAMCMD_USER:-anonymous}"
STEAMCMD_PASSWORD="${STEAMCMD_PASSWORD:-}"
STEAMCMD_AUTH_CODE="${STEAMCMD_AUTH_CODE:-}"

## Validate numeric inputs
## ==============================================
if [[ ! "$SATISFACTORY_MAXPLAYERS" =~ ^[0-9]+$ ]]; then
  echo "Error: SATISFACTORY_MAXPLAYERS must be a valid number"
  exit 1
fi


# Link the server data directory to the one created in $DATA_DIR
mkdir -p "$DATA_DIR"
mkdir -p "/home/$GAME_USER/.config/Epic/"
test -L "/home/$GAME_USER/.config/Epic/FactoryGame" || ln -s "$DATA_DIR" "/home/$GAME_USER/.config/Epic/FactoryGame"

## Download game files only (without starting server)
## ==============================================
if [[ "$SATISFACTORY_SERVER_UPDATE_ONLY_THEN_STOP" = true ]] || [[ "$SATISFACTORY_SERVER_VALIDATE_ONLY_THEN_STOP" = true ]]; then
echo "
╔═══════════════════════════════════════════════╗
║ Downloading game files only                   ║
╚═══════════════════════════════════════════════╝"
  if [[ "$SATISFACTORY_SERVER_VALIDATE_ONLY_THEN_STOP" = true ]]; then
    VALIDATE_FLAG='validate'
  else
    VALIDATE_FLAG=''
  fi

  "$STEAMCMD_DIR/steamcmd.sh" \
  +force_install_dir "$GAME_DIR" \
  +login "$STEAMCMD_USER" "$STEAMCMD_PASSWORD" "$STEAMCMD_AUTH_CODE" \
  +app_update "$STEAMCMD_APP" $VALIDATE_FLAG \
  +quit

echo "
╔═══════════════════════════════════════════════╗
║ Game files downloaded. Stopping container.    ║
╚═══════════════════════════════════════════════╝"
  exit 0
fi

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

  "$STEAMCMD_DIR/steamcmd.sh" \
  +force_install_dir "$GAME_DIR" \
  +login "$STEAMCMD_USER" "$STEAMCMD_PASSWORD" "$STEAMCMD_AUTH_CODE" \
  +app_update "$STEAMCMD_APP" $VALIDATE_FLAG \
  +quit

fi


## Print Variables
## ==============================================
echo "
╔═══════════════════════════════════════════════╗
║ Server set with provided values               ║
╚═══════════════════════════════════════════════╝"
printenv | grep SATISFACTORY || true




## Run
## ==============================================
echo "
╔═══════════════════════════════════════════════╗
║ Starting Server                               ║
╚═══════════════════════════════════════════════╝"

"$GAME_DIR/FactoryServer.sh" \
  -unattended \
  "-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=$SATISFACTORY_MAXPLAYERS" \
  "-ini:GameUserSettings:[/Script/Engine.GameSession]:MaxPlayers=$SATISFACTORY_MAXPLAYERS"
