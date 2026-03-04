# Satisfactory

[![Build](https://img.shields.io/github/actions/workflow/status/netwarlan/satisfactory/build.yml)](https://github.com/netwarlan/satisfactory/actions)
[![Release](https://img.shields.io/github/v/release/netwarlan/satisfactory)](https://github.com/netwarlan/satisfactory/releases)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?logo=discord&logoColor=white)](https://discord.gg/QtqKW9xvzK)

The following repository contains the source files for building a Satisfactory server.

## Configuring the server

This dedicated server is largely configured by the admin UI in the game client. The first person to connect to a fresh dedicated server will set the admin password and be able to start a new map. The server configuration along with world save data has been configured to be available at `/app/satisfactory_data`. It's recommended that you configure a volume at that path so that progress is not lost when the container is recreated.

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `SATISFACTORY_SERVER_UPDATE_ON_START` | `true` | Download/update game files on container start |
| `SATISFACTORY_SERVER_VALIDATE_ON_START` | `false` | Validate game file integrity via SteamCMD on start |
| `SATISFACTORY_SERVER_UPDATE_ONLY_THEN_STOP` | `false` | Download game files only, then stop the container |
| `SATISFACTORY_SERVER_VALIDATE_ONLY_THEN_STOP` | `false` | Download and validate game files, then stop the container |
| `SATISFACTORY_MAXPLAYERS` | `8` | Max player count (devs recommend 4) |


### Running
To run the container, issue the following example command:
```
docker run -d \
    -p 7777:7777/udp \
    -p 7777:7777/tcp \
    -v ./server-data:/app/satisfactory_data \
    -v ./server-bin:/app/satisfactory \
    ghcr.io/netwarlan/satisfactory:latest
```

### Download game files only
To download game files without starting the server:
```
docker run --rm \
    -v ./server-bin:/app/satisfactory \
    -e SATISFACTORY_SERVER_UPDATE_ONLY_THEN_STOP=true \
    ghcr.io/netwarlan/satisfactory:latest
```

To download and validate game files:
```
docker run --rm \
    -v ./server-bin:/app/satisfactory \
    -e SATISFACTORY_SERVER_VALIDATE_ONLY_THEN_STOP=true \
    ghcr.io/netwarlan/satisfactory:latest
```