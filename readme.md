# Satisfactory
The following repository contains the source files for building a Satisfactory server.

### Running
To run the container, issue the following example command:
```
docker run -d \
-p 15000:15000/udp \
-p 15777:15777/udp \
-p 7777:7777/udp \
-e SATISFACTORY_SERVER_HOSTNAME="DOCKER SATISFACTORY" \
ghcr.io/netwarlan/satisfactory:latest
```