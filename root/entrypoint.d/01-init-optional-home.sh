#!/bin/bash

if [[ -d "/opt/application/.docker/.home" ]]; then
    usermod -d /opt/application/.docker/.home ${APPLICATION_UNAME}
fi
