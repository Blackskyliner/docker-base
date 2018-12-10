# Docker Baseimage
This docker image(s) provide a foundation for other Docker images.
The image(s) will **not** add an full blown S6 layer (https://github.com/just-containers/s6-overlay), but an easy auto-user detection to mitigate possible quirks when mounting into the container, especially in a development environment.
The default folder for this container is `/opt/application` where any arbitrary application may reside in. Its UID and GID will be used for the application user.
The image also provides a simple bash helper to `wait-for` other services spawned through docker.

The basing images should use the provided package manager of the distribution to install applications if possible.

If the basing image overwrites the entrypoint.sh, for application specific entries, it should source the base-entrypoint.sh to get the benefits from this image(s).
The executing user which the container starts with is and has to be root, as it needs to have some permissions for the auto-user detection and changes it does. (So don't use USER within the basing image dockerfile or at least return it to root if you are done)
This is to have the ability to bind ports in the system range (< 1024) within a container and to prepare the environment accordingly.
To execute stuff as user within the entrypoint you should use `exec runuser --user ${APPLICATION_UNAME} -- "$@"`
