ARG DOCKER_CENTOS_VERSION=latest
FROM centos:$DOCKER_CENTOS_VERSION

RUN set -e \
    && yum -y install epel-release \
    && yum -y install yum-utils git openssh-clients unzip nmap-ncat wget \
    && yum clean all && rm -rf /var/cache/yum \
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
