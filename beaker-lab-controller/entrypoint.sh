#!/bin/bash

function log_info {
  echo "---> `date +%T`     $@"
}

function wait_for_http_ok() {
  while [[ `curl -IL ${1} -o /dev/null -w '%{http_code}' -s` -ne 200 ]]; do
    log_info "Waiting for Beaker server to start..."
    sleep 1
  done
  log_info "Beaker server started successfully" && return 0
}

function mirror_tasks() {
  tempdir=$(mktemp -d)
  pushd $tempdir
  for task in $(curl https://beaker-project.org/tasks/ | awk -F\" '/\.rpm/ { print $8 }'); do
    curl -O https://beaker-project.org/tasks/$task
    bkr task-add $task
  done
  popd
}

# Poll until Beaker server responds to our ping.
wait_for_http_ok "http://127.0.0.1/bkr/"

if [ ! -e "/defaults/client.conf" ]; then
  cp /etc/beaker/client.conf.orig /defaults/client.conf
  sed -i "s/#JUMPHOST#/$JUMPHOST/g" /defaults/client.conf
fi

if [ ! -e "/defaults/labcontroller.conf" ]; then
  cp /etc/beaker/labcontroller.conf.orig /defaults/labcontroller.conf
  sed -i "s/#JUMPHOST#/$JUMPHOST/g" /defaults/labcontroller.conf
fi

if [ ! -e "/defaults/anamon" ]; then
  cp /usr/share/bkr/lab-controller/anamon /defaults/anamon
fi

if [ ! -e "/defaults/anamon3" ]; then
  cp /usr/share/bkr/lab-controller/anamon3 /defaults/anamon3
fi

if [ ! -e "/defaults/anamon.init" ]; then
  cp /usr/share/bkr/lab-controller/anamon.init /defaults/anamon.init
fi

if [ ! -e "/defaults/anamon.service" ]; then
  cp /usr/share/bkr/lab-controller/anamon.service /defaults/anamon.service
fi

[[ ! -f /data/harness/anamon ]] && \
    cp /defaults/anamon /data/harness/anamon

[[ ! -f /data/harness/anamon3 ]] && \
    cp /defaults/anamon3 /data/harness/anamon3

[[ ! -f /data/harness/anamon.init ]] && \
    cp /defaults/anamon.init /data/harness/anamon.init

[[ ! -f /data/harness/anamon.service ]] && \
    cp /defaults/anamon.service /data/harness/anamon.service

[[ ! -f /config/client.conf ]] && \
    cp /defaults/client.conf /config/client.conf
[[ ! -L /etc/beaker/client.conf && -f /etc/beaker/client.conf ]] && \
    rm /etc/beaker/client.conf
[[ ! -L /etc/beaker/client.conf ]] && \
    ln -s /config/client.conf /etc/beaker/client.conf

[[ ! -f /config/labcontroller.conf ]] && \
    cp /defaults/labcontroller.conf /config/labcontroller.conf
[[ ! -L /etc/beaker/labcontroller.conf && -f /etc/beaker/labcontroller.conf ]] && \
    rm /etc/beaker/labcontroller.conf
[[ ! -L /etc/beaker/labcontroller.conf ]] && \
    ln -s /config/labcontroller.conf /etc/beaker/labcontroller.conf

# We need to use the FQDN of the host running the container
if [ ! -f "/tmp/lab_controller_registered" ]; then
  bkr labcontroller-create --fqdn $JUMPHOST \
      --user host/labctrl --password labctrl \
      --email labctrl@beaker-server.localdomain \
      > /tmp/lab_controller_registered
fi

exec "$@"
