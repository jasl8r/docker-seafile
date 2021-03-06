FROM ubuntu:14.04
MAINTAINER jeremy.slater@nuance.com

ENV SEAFILE_VERSION=5.0.4 \
    SEAFILE_HOME="/opt/seafile"

ENV SEAFILE_ROOT_DATA_DIR="${SEAFILE_HOME}/data" \
    SEAFILE_BUILD_DIR="${SEAFILE_HOME}/build" \
    SEAFILE_RUNTIME_DIR="${SEAFILE_HOME}/runtime" \
    SEAFILE_INSTALL_DIR="${SEAFILE_HOME}/seafile-server-${SEAFILE_VERSION}" \
    SEAFILE_LOG_DIR="/var/log/seafile"

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8B3981E7A6852F782CC4951600A6F0A3C300EE8C \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl gettext-base nginx \
    mysql-client python2.7 libpython2.7 python-setuptools python-imaging \
    python-ldap python-mysqldb python-memcache supervisor locales memcached \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && locale-gen en_US.UTF-8 \
 && dpkg-reconfigure locales \
 && rm -rf /var/lib/apt/lists/*

COPY assets/build/ ${SEAFILE_BUILD_DIR}/
RUN bash ${SEAFILE_BUILD_DIR}/install.sh

COPY assets/runtime/ ${SEAFILE_RUNTIME_DIR}/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp

VOLUME ["${SEAFILE_ROOT_DATA_DIR}", "${SEAFILE_LOG_DIR}"]
WORKDIR ${SEAFILE_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
