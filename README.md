# Docker Baseimage
This docker image(s) provide a foundation for other Docker images.
The image(s) will **not** add an full blown S6 layer (https://github.com/just-containers/s6-overlay), but an easy auto-user detection to mitigate possible quirks when mounting into the container, especially in a development environment.

The default folder is assumed to be  `/opt/application` where any arbitrary application may reside in. 
Its UID and GID will be used for the `application` user.

The image also provides some simple bash helper to `wait-for` other services spawned through docker(-compose) and also some little helpers to run software as root `run-as-root` or as user `run-as-user` or reuse the process via exec as root `exec-as-root` or as user `exec-as-user`.

Images based on this container should use the provided package manager of the corresponding distribution to install applications if possible.
The whole idea is to use pre packaged stuff instead of compiling everything. If you need that just use something more suited for that e.g. alpine.
The benefit will be that a sysadmin is able setup a non-docker environment based on your Dockerfiles. This may be especially useful if docker is solely for development and should react as close as possible to any production server running the bare os used for the docker image (e.g CentOS).

The executing user which the container starts with is and has to be root, as it needs to have some permissions for the auto-user detection and changes it does. (So don't use USER within the basing image dockerfile or at least return it to root if you are done)
This is to have the ability to bind ports in the system range (< 1024) within a container and to prepare the environment accordingly. This is needed as some distributions require to run certain services without any hassel, if installed through their package manager. (e.G. apache from CentOS Repositories)
To execute stuff always use the available helper functions (see `functions.bash`).

If you need initialisation work to be done you may drop an executable script into the `entrypoint.d` folder of the container. The files execution order is determined by filename and thus those files are prepended with a two digit number and a dash. (e.G. `00-init-user.sh` or `90-wait-for-services.sh`).

Those files should not be used to spawn services but should be used to prepare the application specific environment. If you need this functionallity you should better use any other image integrating an S6 Overlay or other multi-service managers for containers.