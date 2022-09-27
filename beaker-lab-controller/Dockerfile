FROM centos:7
LABEL name="beaker-lab-controller-container"
RUN yum upgrade -y && \
  yum -y install epel-release dnf dnf-plugins-core
RUN yum-config-manager --save --setopt=epel.exclude=nodejs*,npm
RUN yum-config-manager --add-repo https://beaker-project.org/yum/beaker-server-RedHatEnterpriseLinux.repo && \
  dnf -y copr enable bpeck/beaker && \
  yum -y install beaker-lab-controller && \
  yum -y install beaker-client && \
  yum -y install conserver && \
  yum -y install conserver-client && \
  yum -y install supervisor && \
  yum -y install tftp-server && \
  yum -y install tftp && \
  yum -y install xinetd && \
  yum clean all && \
  mkdir -p /defaults /config
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/labcontroller.conf /etc/beaker/labcontroller.conf.orig
COPY config/client.conf /etc/beaker/client.conf.orig
COPY config/tftp/tftp /etc/xinetd.d/tftp
COPY files/ipmitool_lanplus /etc/beaker/power-scripts/ipmitool_lanplus
COPY files/redfish /etc/beaker/power-scripts/redfish

EXPOSE 69/udp

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-n"]
