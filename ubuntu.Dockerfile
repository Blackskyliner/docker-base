ARG DOCKER_UBUNTU_VERSION=latest
FROM ubuntu:$DOCKER_UBUNTU_VERSION

RUN set -e \
    && apt-get update \
    && apt-get -y install git openssh-client unzip netcat-openbsd wget \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 application \
    && useradd --uid 1000 \
    --gid 1000 \
    --home-dir /opt/application \
    --no-create-home \
    --shell /bin/bash \
    application \
    && mkdir /opt/application \
    && chmod 0755 /opt/application \
    && chown -R application:application /opt/application

ADD root/ /
RUN chmod +x "/entrypoint.sh"
WORKDIR /opt/application

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run-as-user", "/bin/bash" ]
