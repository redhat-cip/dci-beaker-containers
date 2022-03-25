# NOTE: Podman/systemd is incompatible with cgroups v2 (F34+).  Revert to v1 if necessary by
# adding kernel arg systemd.unified_cgroup_hierarchy=0
FROM centos:7
LABEL name="beaker_lab_controller_container"
RUN yum upgrade -y && \
  yum-config-manager --add-repo https://beaker-project.org/yum/beaker-server-RedHatEnterpriseLinux.repo && \
  yum -y install beaker-lab-controller && \
  yum -y install conserver && \
  yum -y install conserver-client && \
  yum -y install tftp-server && \
  yum -y install tftp && \
  yum -y install xinetd && \
  yum -y install httpd && \
  yum clean all && \
  systemctl enable xinetd && \
  systemctl enable tftp && \
  systemctl enable beaker-proxy.service && \
  systemctl enable beaker-watchdog.service && \
  systemctl enable beaker-provision.service
CMD [ "/usr/sbin/init" ]
