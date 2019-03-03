#!/bin/bash

if [[ -n "${WAIT_FOR_SERVICES}" ]]; then
    for service in ${WAIT_FOR_SERVICES}; do
        wait-for ${service}
    done
fi