#!/bin/bash

# Fix SSH-Permissions
if [[ -e /opt/application/.ssh ]]; then
    chmod 0700 /opt/application/.ssh
    chmod 0600 /opt/application/.ssh/*
    chmod 0644 /opt/application/.ssh/*.pub
    
    if [[ -e /opt/application/.ssh/config ]]; then
        chmod 0644 /opt/application/.ssh/config
    fi
    if [[ -e /opt/application/.ssh/known_hosts ]]; then
        chmod 0644 /opt/application/.ssh/known_hosts
    fi
fi