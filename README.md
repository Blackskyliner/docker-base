# Docker Baseimage
This docker image(s) provide a foundation for other Docker images.
The image(s) will **not** add an full blown S6 layer (https://github.com/just-containers/s6-overlay), but an easy auto-user detection to mitigate possible quirks when mounting into the container, especially in a development environment.

The default folder is assumed to be  `/opt/application` where any arbitrary application may reside in. 
Its UID and GID will be used for the application user.

The image also provides a simple bash helper to `wait-for` other services spawned through docker(-compose).

Images based on this container should use the provided package manager of the corresponding distribution to install applications if possible.
The whole idea is to use pre packaged stuff instead of compiling everything. If you need that just use something more suited for that e.g. alpine.
The benefit will be that a sysadmin is able setup a non-docker environment based on your Dockerfiles. This may be especially useful if docker is solely for development and should react as close as possible to any production server running the bare os used for the docker image (e.g CentOS).

The executing user which the container starts with is and has to be root, as it needs to have some permissions for the auto-user detection and changes it does. (So don't use USER within the basing image dockerfile or at least return it to root if you are done)
This is to have the ability to bind ports in the system range (< 1024) within a container and to prepare the environment accordingly.
To execute stuff as user within the entrypoint you should use `exec runuser --user ${APPLICATION_UNAME} -- "$@"`
