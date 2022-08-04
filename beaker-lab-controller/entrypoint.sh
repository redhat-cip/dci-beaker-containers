#!/bin/bash

function log_info {
  echo "---> `date +%T`     $@"
}

function wait_for_http_ok() {
  while [[ `curl -IL ${0} -o /dev/null -w '%{http_code}' -s` -eq 200 ]]; do
    log_info "Waiting for Beaker server to start..."
    sleep 1
  done
  log_info "Beaker server started successfully" && return 0
}

# Poll until Beaker server responds to our ping.
wait_for_http_ok "http://beaker-server/bkr/"
sleep 10

if [ ! -f "/tmp/lab_controller_registered" ]; then
  bkr labcontroller-create --fqdn beaker-lab-controller \
      --user host/labctrl --password labctrl \
      --email labctrl@beaker-server.localdomain \
      > /tmp/lab_controller_registered
fi

exec "$@"
