#!/bin/bash

# Exit on Error
set -e

# Get effective UID/GID/UNAME of environment and fallback to folder UID/GID
APPLICATION_UID=${APPLICATION_UID:-$(stat -c '%u' /opt/application)}
APPLICATION_GID=${APPLICATION_GID:-$(stat -c '%g' /opt/application)}
APPLICATION_UNAME=${APPLICATION_UNAME:-application}

source /functions.bash

for file in /entrypoint.d/*.sh; do
    echo "[entrypoint.d] Loading ${file}"
    source "${file}"
done

"$@"