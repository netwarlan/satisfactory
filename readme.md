# Satisfactory
The following repository contains the source files for building a Satisfactory server.

## Configuring the server

This dedicated server is largely configured by the admin UI in the game client. The first person to connect to a fresh dedicated server will set the admin password and be able to start a new map. The server configuration along with world save data has been configured to be available at `/app/satisfactory_data`. It's recommended that you configure a volume at that path so that progress is not lost when the container is recreated.

### Max Players

The devs of this game suggest that it is only tested with 4 players. However, it is configurable to go beyond this default. You can set the `SATISFACTORY_MAXPLAYERS` envvar to an integer value.


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