#!/bin/bash

source /base-entrypoint.sh

echo "Executing as root: "$@
exec $@