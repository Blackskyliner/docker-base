#!/bin/sh

set -e

PUSH_TAGS=1
PUSH_HOST=''

if [ $1 == '--push' ]; then
    PUSH_TAGS=0
    if [ -z $2 ]; then
        echo "Specify registry as second parameter"
        exit 1
    fi
    PUSH_HOST=$2

    echo "Pushing to docker registry $PUSH_HOST enabled."
fi

PUSH_TAG_ARRAY=""

buildImage(){
    FOLDER=$1
    shift
    DOCKERFILE=$1
    shift
    TAG=$1
    shift

    OLDPWD=$(pwd)
    cd "$FOLDER"
        docker build --tag="$TAG" --file "$DOCKERFILE" $@ .
        if [ $PUSH_TAGS ]; then
            docker tag $TAG $PUSH_HOST/$TAG
            PUSH_TAG_ARRAY="${PUSH_TAG_ARRAY} $PUSH_HOST/$TAG"
        fi
    cd $OLDPWD
}

# Base Images (latest and centos7 are rolling release versions)
buildImage . Dockerfile base --no-cache --build-arg DOCKER_CENTOS_VERSION=latest
buildImage . Dockerfile base:centos-7 --build-arg DOCKER_CENTOS_VERSION=7
buildImage . Dockerfile base:centos-6 --build-arg DOCKER_CENTOS_VERSION=6

if [ ! -z "$PUSH_TAG_ARRAY" ]; then
    if [ $PUSH_TAGS ]; then
        for TAG in $PUSH_TAG_ARRAY; do
            docker push $TAG
        done
    fi
fi
