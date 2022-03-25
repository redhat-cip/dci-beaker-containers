## Install Procedure:  
https://beaker-project.org/docs/admin-guide/installation.html

### To Do:

#### Database:
- container name: dci-beaker-containers_db_1
- enable utf8 charset
	+ mount custom my.cnf file in container and set MYSQL_DEFAULTS_FILE to point to it (UNDONE)
	+ use MYSQL_CHARSET=utf8 instead (DONE VIA ENV IN CONTAINER)
- create DB (beaker)
	+ MYSQL_DATABASE (DONE VIA ENV IN CONTAINER)
- create user (beaker)
	+ MYSQL_USER (DONE VIA ENV IN CONTAINER)
	+ MYSQL_PASSWORD (DONE VIA ENV IN CONTAINER)
- create root pw
	+ MYSQL_ROOT_PASSWORD (DONE VIA ENV IN CONTAINER)
- GRANT ALL on beaker.* TO beaker IDENTIFIED by 'beaker';
	+ !!!NEED TO AUTOMATE!!!

#### Beaker Server (with httpd):
- container name: dci-beaker-containers_beaker_server_1
- depends on DB
	+ TODO: added depends_on to container_compose.yml but beakerd service is failing on startup but starts fine manually
- /etc/beaker/server.cfg (NEED TO AUTOMATE)
	+ update DB user/pw/location:
		* sqlalchemy.dburi = "mysql://beaker:PASSWORD@dci-beaker-containers_db_1/beaker?charset=utf8"
- beaker-init -u admin -p testing -e root@localhost.localdomain
	+ creates necessary tables in DB (NEED TO AUTOMATE)

- NOTE: /etc/beaker/client.conf works with beaker server IP, not with container name (but container name can be pinged)

#### Beaker Lab Controller:
- The TFTP service must run directly on the lab controller to allow Beaker to correctly provision test systems. The DHCP, DNS and NTP services may be run on the lab controller, but do not need to be. (https://beaker-project.org/docs/admin-guide/installation.html#external-services)
- TODO: Add ipmitool_lanplus and redfish power scripts to Beaker (scripts mounted in container, but need to officially add to Beaker)
- https://beaker-project.org/docs/admin-guide/installation.html#adding-a-lab-controller

- /etc/beaker/labcontroller.conf works with beaker server container IP, not with container name (but container name can be pinged)

- ##### tftp/xinetd:
- included in lab controller container
- mounted container compose directory as /var/lib/tftproot in lab controller container

#### dnsmasq:
- TODO
