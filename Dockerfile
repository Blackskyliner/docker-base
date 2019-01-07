ARG DOCKER_CENTOS_VERSION=latest
FROM centos:$DOCKER_CENTOS_VERSION

# First time update and fastmirror
RUN set -e \
    && yum -y update

# Disable the search for fast mirrors for later usages
RUN set -e \
    && sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf

# Install some sane defaults
RUN yum -y install epel-release && \
    yum -y install sudo git openssh-clients unzip nmap-ncat gettext \
    && yum clean all && rm -rf /var/cache/yum

# Add our application user
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

# Install our entrypoints
COPY base-entrypoint.sh /base-entrypoint.sh
COPY entrypoint.sh /entrypoint.sh

# Make sure our entrypoints are executable
RUN chmod +x "/base-entrypoint.sh" "/entrypoint.sh"

# Set the work directory to the application directory
WORKDIR /opt/application

# We do not set the application volume as this may break
# Dockerfiles which bundle the whole application and want
# only specific dirs get mounted as VOLUME.
# VOLUME ["/opt/application"]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]