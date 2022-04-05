## Install Procedure:  
https://beaker-project.org/docs/admin-guide/installation.html

### To Do:

### Overall:
- (DONE) Hard-coded IPs of containers for use in static config files:
	+ DB: 172.20.0.10
	+ beaker server: 172.20.0.11
	+ beaker lab controller: 172.20.0.12

#### Database:
- container name: dci-beaker-containers_db_1
- enable utf8 charset
	+ set via env var MYSQL_CHARSET=utf8 (DONE)
	+ use MYSQL_CHARSET=utf8 instead (DONE VIA ENV IN CONTAINER)
- create DB (beaker)
	+ MYSQL_DATABASE (DONE VIA ENV IN CONTAINER)
- create user (beaker)
	+ MYSQL_USER (DONE VIA ENV IN CONTAINER)
	+ MYSQL_PASSWORD (DONE VIA ENV IN CONTAINER)
- create root pw
	+ MYSQL_ROOT_PASSWORD (DONE VIA ENV IN CONTAINER)
- GRANT ALL on beaker.* TO beaker IDENTIFIED by 'beaker'; (DONE)

#### Beaker Server (with httpd):
- container name: dci-beaker-containers_beaker_server_1
- depends on DB
	+ TODO: added depends_on with health check for DB (mysqladmin ping).  Health check not implemented in podman-compose yet, but there is a recent PR (https://github.com/containers/podman-compose/pull/453).  Confirmed that after waiting for DB container and then starting beaker server container manually, beakerd service starts fine.
- /etc/beaker/server.cfg
	+ Current solution hardcodes DB location to DB container name and user/pw to beaker/beaker (WORKS)
- beaker-init -u admin -p testing -e root@localhost.localdomain (NEED TO AUTOMATE THIS COMMAND)
	+ creates necessary tables in DB
- bkr labcontroller-create --fqdn 172.20.0.12 --user host/labctrl --password labctrl --email root@localhost.localdomain
	+ registers lab controller container (NEED TO AUTOMATE THIS COMMAND AFTER beaker-init)

- NOTE: /etc/beaker/client.conf works with beaker server IP, not with container name (but container name can be pinged)

#### Beaker Lab Controller:
- The TFTP service must run directly on the lab controller to allow Beaker to correctly provision test systems. The DHCP, DNS and NTP services may be run on the lab controller, but do not need to be. (https://beaker-project.org/docs/admin-guide/installation.html#external-services)
- TODO: Add ipmitool_lanplus and redfish power scripts to Beaker (scripts mounted in container, but need to officially add to Beaker, maybe do it with agent Ansible?)
- https://beaker-project.org/docs/admin-guide/installation.html#adding-a-lab-controller

- /etc/beaker/labcontroller.conf works with beaker server container IP, not with container name (but container name can be pinged)

- ##### tftp/xinetd:
- included in lab controller container
- mounted container compose directory as /var/lib/tftproot in lab controller container

#### dnsmasq:
- configure beaker.conf file in agent ansible prior to beaker container start, based on settings file

