#!/bin/bash

function log_info {
  echo "---> `date +%T`     $@"
}

# Poll until MySQL responds to our ping.
function wait_for_mysql() {
  while ! mysqladmin -h 127.0.0.1 -u beaker -pbeaker ping &>/dev/null; do
    log_info "Waiting for MySQL to start ..."
    sleep 1
  done
  log_info "MySQL started successfully"
  beaker-init -u admin -p admin -e root@localhost.localdomain  
  return 0
}

if [ ! -e "/defaults/server.cfg" ]; then
  cp /etc/beaker/server.cfg.orig /defaults/server.cfg
  sed -i "s/#JUMPHOST#/$JUMPHOST/g" /defaults/server.cfg
fi

if [ ! -e "/defaults/client.conf" ]; then
  cp /etc/beaker/client.conf.orig /defaults/client.conf
fi

if [ ! -e "/defaults/beaker-server.conf" ]; then
  cp /etc/httpd/conf.d/beaker-server.conf.orig /defaults/beaker-server.conf
fi

[[ ! -f /config/server.cfg ]] && \
    cp /defaults/server.cfg /config/server.cfg
[[ ! -L /etc/beaker/server.cfg && -f /etc/beaker/server.cfg ]] && \
    rm /etc/beaker/server.cfg
[[ ! -L /etc/beaker/server.cfg ]] && \
    ln -s /config/server.cfg /etc/beaker/server.cfg

[[ ! -f /config/client.conf ]] && \
    cp /defaults/client.conf /config/client.conf
[[ ! -L /etc/beaker/client.conf && -f /etc/beaker/client.conf ]] && \
    rm /etc/beaker/client.conf
[[ ! -L /etc/beaker/client.conf ]] && \
    ln -s /config/client.conf /etc/beaker/client.conf

[[ ! -f /config/beaker-server.conf ]] && \
    cp /defaults/beaker-server.conf /config/beaker-server.conf
[[ ! -L /etc/httpd/conf.d/beaker-server.conf && -f /etc/httpd/conf.d/beaker-server.conf ]] && \
    rm /etc/httpd/conf.d/beaker-server.conf
[[ ! -L /etc/httpd/conf.d/beaker-server.conf ]] && \
    ln -s /config/beaker-server.conf /etc/httpd/conf.d/beaker-server.conf

mkdir -p /data/rpms \
         /data/logs \
         /data/repos \
	 /data/harness
chown -R apache:apache /data

wait_for_mysql

exec "$@"
