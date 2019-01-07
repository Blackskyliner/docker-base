#!/bin/bash

# We source the base entrypoint, and every custom entrypoint.sh
# should also do this. The entrypoint will provide some easy to use
# bash functions and also ensure the correct mapping of UID and GID
source /base-entrypoint.sh

# As we are running as root per default we tell them.
# Other entrypoint overwrites should also consider to
# echoing the executing user they are running with.
echo "Executing as root: "$@
exec $@