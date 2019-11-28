#!/bin/sh

# We use /bin/sh in here instead of /bin/bash
# so it can be used by any builing system.

# Fail on error
set -e

# This function will take: 
#   - the working directory of a docker command
#   - the name of the dockerfile
#   - the tag which the built image should get
#   - an arbitrary list of arguments for docker build
# and build the corresponding docker image.
buildImage(){
    FOLDER=$1
    shift
    DOCKERFILE=$1
    shift
    TAG=$1
    shift

    # pushd/popd for /bin/sh
    OLDPWD=$(pwd)
    cd "$FOLDER"
        # Build and tag the file
        docker build --tag="$TAG" --file "$DOCKERFILE" "$@" .
        docker push $TAG
    cd "$OLDPWD"
}

# Build Images and tag them
buildImage    .    Dockerfile    blackskyliner/base    --build-arg DOCKER_CENTOS_VERSION=latest
buildImage    .    Dockerfile    blackskyliner/base:centos-latest    --build-arg DOCKER_CENTOS_VERSION=latest
buildImage    .    Dockerfile    blackskyliner/base:centos-8    --build-arg DOCKER_CENTOS_VERSION=8
buildImage    .    Dockerfile    blackskyliner/base:centos-7         --build-arg DOCKER_CENTOS_VERSION=7
buildImage    .    ubuntu.Dockerfile    blackskyliner/base:ubuntu-latest    --build-arg DOCKER_UBUNTU_VERSION=latest
buildImage    .    ubuntu.Dockerfile    blackskyliner/base:ubuntu-bionic    --build-arg DOCKER_UBUNTU_VERSION=bionic
