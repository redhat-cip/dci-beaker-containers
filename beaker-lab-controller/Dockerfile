FROM centos:7
LABEL name="beaker-lab-controller-container"
RUN yum upgrade -y && \
  yum -y install epel-release dnf dnf-plugins-core
RUN yum-config-manager --save --setopt=epel.exclude=nodejs*,npm
COPY files/beaker-server-RedHatEnterpriseLinux.repo /etc/yum.repos.d/beaker-server-RedHatEnterpriseLinux.repo
RUN dnf -y copr enable bpeck/beaker && \
  dnf -y copr enable bpeck/ipmitool && \
  yum -y install beaker-lab-controller && \
  yum -y install beaker-client && \
  yum -y install conserver && \
  yum -y install conserver-client && \
  yum -y install supervisor && \
  yum -y install tftp-server && \
  yum -y install tftp && \
  yum -y install xinetd && \
  yum -y install fence-agents-lpar && \
  yum clean all && \
  mkdir -p /defaults /config
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/labcontroller.conf /etc/beaker/labcontroller.conf.orig
COPY config/client.conf /etc/beaker/client.conf.orig
COPY config/tftp/tftp /etc/xinetd.d/tftp
COPY files/ipmitool_lanplus /etc/beaker/power-scripts/ipmitool_lanplus
COPY files/redfish /etc/beaker/power-scripts/redfish
COPY files/apc_snmp_container /etc/beaker/power-scripts/apc_snmp_container

EXPOSE 69/udp

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-n"]
