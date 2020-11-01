# 7d2d-server
Run a 7 Days to Die spigot server in a Docker container.

This uses steamCMD to automatically update your server software.

[![Docker Automated build](https://img.shields.io/docker/automated/nsnow/7d2d-server.svg)](https://hub.docker.com/r/nsnow/7d2d-server)
[![Docker Stars](https://img.shields.io/docker/stars/nsnow/7d2d-server.svg)](https://hub.docker.com/r/nsnow/7d2d-server)
[![Docker Pulls](https://img.shields.io/docker/pulls/nsnow/7d2d-server.svg)](https://hub.docker.com/r/nsnow/7d2d-server)
[![Docker Build Status](https://img.shields.io/docker/build/nsnow/7d2d-server.svg)](https://hub.docker.com/r/nsnow/7d2d-server/builds)


This Dockerfile will download the 7 Days to Die Server app and set it up, along with its dependencies.

If you run the container as is, the `game` directory will be created inside the container, which is inadvisable.
It is highly recommended that you store your game files outside the container using a mount (see the example below).
Ensure that your file system permissions are correct, `chown 1000:1000 mount/path`, and/or modify the UID/GUID variables as needed (see below).

It is also likely that you will want to customize your `serverconfig.xml` file.
To do this, use the `-e <ENVIRONMENT_VARIABLE>=<value>` for each setting in the `serverconfig.xml`.
The `serverconfig.xml` file will be overwritten every time the container is launched. See below for details.


## Run the server

Use this `docker run` command to launch a container with a few customized `serverconfig.xml`.
Replace `<ENVIRONMENT_VARIABLE>=<VALUE>` with the appropriate values (see section "Server properties and environment variables" below).

```
docker run -d -it --name=sevend2d \
  -v /opt/sevend2d/world1/data:/home/sevend2d/server \
  -v /opt/sevend2d/world1/saves:/home/sevend2d/.local/share/7DaysToDie/Saves \
  -p 26900:26900/tcp \
  -p 26900:26902/udp \
  -e <ENVIRONMENT_VARIABLE>=<VALUE> \
  nsnow/7d2d-server:latest
```


## Additional Docker commands

**kill and remove all docker containers**

`docker kill $(docker ps -qa); docker rm $(docker ps -qa)`

**docker logs**

`docker logs -f sevend2d`

**server logs**

`tail -f /mnt/docker/sevend2d/world1/7DaysToDieServer_Data/output_log_*`

**attach to the sevend2d server console**

You don't need any rcon nonsense with docker attach!

Use `ctrl+p` then `ctrl+q` to quit.

`docker attach sevend2d`

**exec into the container's bash console**

`docker exec sevend2d bash`


**NOTE**: referencing containers by name is only possible if you specify the `--name` flag in your docker run command.


## Set selinux context for mounted volumes

`chcon -Rt svirt_sandbox_file_t /path/to/volume`


## Server properties and environment variables

**Set user and/or group id (optional)**
* `SEVEND2D_UID=1000`
* `SEVEND2D_GUID=1000`

### serverconfig.xml
Use [this file](https://github.com/japtain-cack/7d2d-server/blob/master/remco/templates/serverconfig.xml) for the full environment variable reference.
 
This project uses [Remco config management](https://github.com/HeavyHorst/remco).
This allows for templatization of config files and options can be set using environment variables.
This allows for easier deployments using most docker orchistration/management platforms including Kubernetes.

The remco tempate uses keys. This means you should see a string like `"/sevend2d/some-option"` within the `getv()` function.
This directly maps to a environment variable, the `/` becomes an underscore basically. The other value in the `getv()` function is the default value.
For instance, `"/sevend2d/some-option"` will map to the environment variable `SEVEND2D_SOME-OPTION`.

`getv("/sevend2d/some-option", "default-value")`

becomes

`docker run -e SEVEND2D_SOME-OPTION=my-value ...`

