#!/bin/bash
set -e
set -x

mkdir -p ${SEAFILE_HOME}
cd ${SEAFILE_HOME}

echo "Downloading SeaFile v.${SEAFILE_VERSION}"
curl -OL https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
tar xzf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
rm seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz

cd ${SEAFILE_INSTALL_DIR}/seafile/lib
rm -f liblber-2.4.so.2 libldap-2.4.so.2 libsasl2.so.2 libldap_r-2.4.so.2
cd ${SEAFILE_HOME}

mkdir -p ${SEAFILE_HOME}/sockets/

# disable default nginx configuration and enable gitlab's nginx configuration
rm -rf /etc/nginx/sites-enabled/default

# move nginx logs to ${GITLAB_LOG_DIR}/nginx
sed -i \
  -e "s|access_log /var/log/nginx/access.log;|access_log ${SEAFILE_LOG_DIR}/nginx/access.log;|" \
  -e "s|error_log /var/log/nginx/error.log;|error_log ${SEAFILE_LOG_DIR}/nginx/error.log;|" \
  /etc/nginx/nginx.conf

# configure supervisord to start seafile
cat > /etc/supervisor/conf.d/seafile-controller.conf <<EOF
[program:seafile-controller]
priority=10
directory=${SEAFILE_HOME}
environment=
    LD_LIBRARY_PATH="${SEAFILE_INSTALL_DIR}/seafile/lib",
    PATH="${SEAFILE_INSTALL_DIR}/seafile/bin:$PATH"
command=${SEAFILE_INSTALL_DIR}/seafile/bin/seafile-controller -f \
    -c ${SEAFILE_ROOT_DATA_DIR}/ccnet \
    -d ${SEAFILE_ROOT_DATA_DIR}/seafile \
    -F ${SEAFILE_HOME}/conf \
    -L ${SEAFILE_LOG_DIR}
autostart=true
autorestart=true
stopsignal=QUIT
stdout_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
EOF

#configure supervisord to start seahub
cat > /etc/supervisor/conf.d/seahub.conf <<EOF
[program:seahub]
priority=10
directory=${SEAFILE_HOME}
environment=
    LANG="en_US.UTF-8",
    LC_ALL="en_US.UTF-8",
    CCNET_CONF_DIR="${SEAFILE_ROOT_DATA_DIR}/ccnet",
    SEAFILE_CONF_DIR="${SEAFILE_ROOT_DATA_DIR}/seafile",
    SEAFILE_CENTRAL_CONF_DIR="${SEAFILE_HOME}/conf",
    SEAHUB_LOG_DIR="${SEAFILE_LOG_DIR}",
    PYTHONPATH="${SEAFILE_INSTALL_DIR}/seafile/lib64/python2.6/site-packages:${SEAFILE_INSTALL_DIR}/seahub/thirdpart"
command=python ${SEAFILE_INSTALL_DIR}/seahub/manage.py run_gunicorn -c ${SEAFILE_HOME}/conf/gunicorn.conf --preload
autostart=true
autorestart=true
stopsignal=QUIT
stdout_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
EOF

# configure supervisord to start nginx
cat > /etc/supervisor/conf.d/nginx.conf <<EOF
[program:nginx]
priority=20
directory=/tmp
command=/usr/sbin/nginx -g "daemon off;"
user=root
autostart=true
autorestart=true
stdout_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
EOF

# configure supervisord to start nginx
cat > /etc/supervisor/conf.d/memcached.conf <<EOF
[program:memcached]
command=/usr/bin/memcached -v -p 11211 -u memcache -c 4096
autostart=true
autorestart=true
stdout_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${SEAFILE_LOG_DIR}/supervisor/%(program_name)s.log
EOF
