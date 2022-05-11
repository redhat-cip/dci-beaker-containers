#!/bin/bash

function log_info {
  echo "---> `date +%T`     $@"
}

# Poll until MySQL responds to our ping.
function wait_for_mysql() {
  while ! mysqladmin -h 127.0.0.1 -u root -ppassword ping &>/dev/null; do
    log_info "Waiting for MySQL to start ..."
    sleep 1
  done
  log_info "MySQL started successfully" && return 0
}

# Initiate the beaker database
function init_beaker_db() {
  beaker-init -u admin -p testing -e root@localhost.localdomain 
  touch /etc/beaker/already_initiate
}

wait_for_mysql

if [ ! -f "/etc/beaker/already_initiate" ]; then
  init_beaker_db
fi

su -s /bin/bash apache -c "/usr/bin/beakerd -p /run/beaker/beakerd.pid -f" &
sleep infinity
