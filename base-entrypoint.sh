#!/bin/bash

# Get effective UID/GID/UNAME of environment and fallback to folder UID/GID
# of the application folder which therefore could get bind-mounted and have other UID/GID.
APPLICATION_UID=${APPLICATION_UID:-$(stat -c '%u' /opt/application)}
APPLICATION_GID=${APPLICATION_GID:-$(stat -c '%g' /opt/application)}
APPLICATION_UNAME=${APPLICATION_UNAME:-application}

# Setup environment to effective UID/GID/UNAME
# To do this we modify our base application user which is created within the Dockerfile
groupmod --gid ${APPLICATION_GID} --new-name ${APPLICATION_UNAME} application &>/dev/null
usermod --gid ${APPLICATION_GID} --uid ${APPLICATION_UID} --login ${APPLICATION_UNAME} application &>/dev/null

# This helper function waits for dependent services.
# Example usage: `wait-for www:80` will wait for an service 
# with the (Docker-)DNS name 'www' to run something to be available at port '80'
wait-for(){
    # Spliy by ':' into WAIT_HOST and WAIT_PORT
    IFS=: read WAIT_HOST WAIT_PORT <<<"$1"
    echo "Waiting for ${WAIT_HOST}:${WAIT_PORT} to be available..."
    while ! nc -z "${WAIT_HOST}" "${WAIT_PORT}"; do
        if [[ $? -eq 2 ]]; then
            exit 1
        fi

        # Let the scheduler schedule some time so we ain't hog the whole CPU
        sleep 2
    done
}

# This helper function runs any given parameters as command.
# It will do so in the name of the containers application user.
# To run the service of a docker-container use 'exec-as-user'.
run-as-user(){
    runuser --user ${APPLICATION_UNAME} -- "$@"
}

# This helper function is the same as run-as-user but it will replace 
# the current shell with the given command and should be used for the
# primary service run by the docker container.
exec-as-user(){
    exec runuser --user ${APPLICATION_UNAME} -- "$@"
}