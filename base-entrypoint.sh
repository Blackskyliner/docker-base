#!/bin/bash

# Get effective UID/GID/UNAME of environment and fallback to folder UID/GID
APPLICATION_UID=${APPLICATION_UID:-$(stat -c '%u' /opt/application)}
APPLICATION_GID=${APPLICATION_GID:-$(stat -c '%g' /opt/application)}
APPLICATION_UNAME=${APPLICATION_UNAME:-application}

# Setup environment to effective UID/GID/UNAME
groupmod --gid ${APPLICATION_GID} --new-name ${APPLICATION_UNAME} application &>/dev/null
usermod --gid ${APPLICATION_GID} --uid ${APPLICATION_UID} --login ${APPLICATION_UNAME} application &>/dev/null

wait-for(){
    IFS=: read WAIT_HOST WAIT_PORT <<<"$1"
    echo "Waiting for ${WAIT_HOST}:${WAIT_PORT} to be available..."
    while ! nc -z "${WAIT_HOST}" "${WAIT_PORT}"; do
        if [[ $? -eq 2 ]]; then
            exit 1
        fi
        sleep 1
    done
}