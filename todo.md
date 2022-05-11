## Install Procedure:  
https://beaker-project.org/docs/admin-guide/installation.html

### Current Status: Unable to get beaker server and Apache containers to serve /bkr/ (see below)

#### Database:
- container name: dci-beaker-containers_db_1
- enable utf8 charset (DONE)
	+ set via env var MYSQL_CHARSET=utf8 (DONE)
	+ use MYSQL_CHARSET=utf8 instead (DONE VIA ENV IN CONTAINER)
- create DB (beaker) (DONE)
	+ MYSQL_DATABASE (DONE VIA ENV IN CONTAINER)
- create user (beaker) (DONE)
	+ MYSQL_USER (DONE VIA ENV IN CONTAINER)
	+ MYSQL_PASSWORD (DONE VIA ENV IN CONTAINER)
- create root pw (DONE)
	+ MYSQL_ROOT_PASSWORD (DONE VIA ENV IN CONTAINER)
- GRANT ALL on beaker.* TO beaker IDENTIFIED by 'beaker'; (DONE)

#### Beaker Server:
- container name: dci-beaker-containers_beaker_server_1
- depends on DB
	+ TODO: added depends_on with health check for DB (mysqladmin ping).  Health check not implemented in podman-compose yet, but there is a recent PR (https://github.com/containers/podman-compose/pull/453).  Confirmed that after waiting for DB container and then starting beaker server container manually, beakerd service starts fine. (DONE VIA INIT SCRIPT)
- /etc/beaker/server.cfg
	+ Current solution hardcodes DB location to DB container name and user/pw to beaker/beaker (WORKS)
- beaker-init -u admin -p testing -e root@localhost.localdomain (DONE)
	+ creates necessary tables in DB
- TODO: bkr labcontroller-create --fqdn 172.20.0.12 --user host/labctrl --password labctrl --email root@localhost.localdomain
	+ registers lab controller container (NEED TO AUTOMATE THIS COMMAND AFTER beaker-init)

- TODO: install mod_wsgi in httpd container, needed by beaker server

- NOTE: /etc/beaker/client.conf works with beaker server IP, not with container name (but container name can be pinged)

#### Web server (BLOCKER)
- Tried using httpd 2.4 from Red Hat catalog, but unable to install additional packages due to user being set to non-root
- Tried installing mod_wsgi and dependencies (python-setuptools, python-flask, etc).  Eventually hit error related to lack of beaker server python module provided by beaker server install.
	+ Installed beaker server package on apache container to satisfy dependencies, but getting 500 when trying to access /bkr/
	+ Apache error logs (at debug) show nothing obvious

#### Beaker Lab Controller (BLOCKED BY BEAKER SERVER/APACHE SERVER CONTAINERIZATION):
- NOTE: The TFTP service must run directly on the lab controller to allow Beaker to correctly provision test systems. The DHCP, DNS and NTP services may be run on the lab controller, but do not need to be. (https://beaker-project.org/docs/admin-guide/installation.html#external-services)
- TODO: Add ipmitool_lanplus and redfish power scripts to Beaker (scripts mounted in container, but need to officially add to Beaker, maybe do it with agent Ansible?)
- https://beaker-project.org/docs/admin-guide/installation.html#adding-a-lab-controller

- /etc/beaker/labcontroller.conf works with beaker server container IP, not with container name (but container name can be pinged)

- ##### tftp/xinetd:
- included in lab controller container
- mounted container compose directory as /var/lib/tftproot in lab controller container

#### dnsmasq:
- configure beaker.conf file in agent ansible prior to beaker container start, based on settings file

