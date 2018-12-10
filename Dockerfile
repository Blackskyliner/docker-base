ARG DOCKER_CENTOS_VERSION=latest
FROM centos:$DOCKER_CENTOS_VERSION

RUN set -e \
    && sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf

RUN yum -y install epel-release && \
    yum -y install sudo git openssh-clients unzip nmap-ncat gettext \
    && yum clean all && rm -rf /var/cache/yum

RUN set -e \
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

COPY base-entrypoint.sh /base-entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x "/base-entrypoint.sh" "/entrypoint.sh"

VOLUME [ "/opt/application" ]
WORKDIR /opt/application

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]