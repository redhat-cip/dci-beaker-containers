#!/bin/bash

function log_info {
  echo "---> `date +%T`     $@"
}

# Poll until MySQL responds to our ping.
function wait_for_mysql() {
  while ! mysqladmin -h db -u beaker -pbeaker ping &>/dev/null; do
    log_info "Waiting for MySQL to start ..."
    sleep 1
  done
  log_info "MySQL started successfully" && return 0
}

# Initiate the beaker database
function init_beaker_db() {
  beaker-init -u admin -p admin -e root@localhost 
  touch /tmp/already_initiate
}

wait_for_mysql

if [ ! -f "/tmp/already_initiate" ]; then
  init_beaker_db
fi

exec "$@"