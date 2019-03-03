#!/bin/bash

wait-for(){
    # 10 Minutes should be plenty of time to WAIT for any service.
    # If you need more you should consider other checking-flows.
    BACK_OFF_VALUE=600 
    IFS=: read WAIT_HOST WAIT_PORT <<<"$1"
    echo "Waiting for ${WAIT_HOST}:${WAIT_PORT} to be available..."
    while [[ $BACK_OFF_VALUE -ne 0 ]]; do
        # 0 - Found something on port at target
        # 1 - Found target, but nothing at port
        # 2 - Did not find target host
        nc -z "${WAIT_HOST}" "${WAIT_PORT}"
        NCRETVAL=$?

        if [[ NCRETVAL -eq 0 ]]; then
            # Host known, return
            break
        fi

        if [[ $NCRETVAL -eq 2 ]]; then
            # Host unknown, exit!
            exit 1
        fi

        # Host found, but no service, lets wait for it
        sleep 1

        # ... but don't wait forever.
        BACK_OFF_VALUE=$((BACK_OFF_VALUE - 1))
        if [[ $BACK_OFF_VALUE -eq 0 ]]; then
            exit 2;
        fi
    done
}

run-as-user(){
    echo "Running as user (${APPLICATION_UNAME} -> $(id -u ${APPLICATION_UNAME}):$(id -g ${APPLICATION_UNAME})): ""$@"
    runuser --user ${APPLICATION_UNAME} -- "$@"
}

run-as-root(){
    echo "Running as root: ""$*"
    "$@"
}

exec-as-user(){
    echo "Executing as user (${APPLICATION_UNAME} -> $(id -u ${APPLICATION_UNAME}):$(id -g ${APPLICATION_UNAME})): ""$@"
    exec runuser --user ${APPLICATION_UNAME} -- "$@"
}

exec-as-root(){
    echo "Executing as root: ""$*"
    exec "$@"
}
