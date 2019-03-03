#!/bin/bash

# Setup environment to effective UID/GID/UNAME
if [[ "${APPLICATION_UID}" != "0" ]]; then
    groupmod --gid ${APPLICATION_GID} --new-name ${APPLICATION_UNAME} application &>/dev/null
    usermod --gid ${APPLICATION_GID} --uid ${APPLICATION_UID} --login ${APPLICATION_UNAME} application &>/dev/null
else
    echo "Warning: Application directory (/opt/application) is owned by root or APPLICATION_UID is set to 0! UID/GID mapping for ${APPLICATION_UNAME} user disabled!"
fi

if [[ "${APPLICATION_UID}" != $(stat -c '%u' /opt/application) ]]; then
    echo "Warning: Detected/Configured APPLICATION_UID (${APPLICATION_UID}) does not match UID of /opt/application ($(stat -c '%u' /opt/application))!"
fi

if [[ "${APPLICATION_UID}" != $(id -u ${APPLICATION_UNAME}) ]]; then
    echo "Warning: APPLICATION_UID (${APPLICATION_UID}) does not match UID of user ${APPLICATION_UNAME}($(id -u ${APPLICATION_UNAME}))!"
fi

