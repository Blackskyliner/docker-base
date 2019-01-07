#!/bin/sh

set -e

buildImage(){
    FOLDER=$1
    shift
    DOCKERFILE=$1
    shift
    TAG=$1
    shift

    OLDPWD=$(pwd)
    cd "$FOLDER"
        docker build --tag="$TAG" --file "$DOCKERFILE" "$@" .
    cd "$OLDPWD"
}

# Base Images (latest and centos7 are rolling release versions)
buildImage . Dockerfile base --no-cache --build-arg DOCKER_CENTOS_VERSION=latest
buildImage . Dockerfile base:centos-7 --build-arg DOCKER_CENTOS_VERSION=7
