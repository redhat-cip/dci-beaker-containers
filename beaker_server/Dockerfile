# NOTE: Podman/systemd is incompatible with cgroups v2 (F34+).  Revert to v1 if necessary by
# adding kernel arg systemd.unified_cgroup_hierarchy=0.
# https://bugzilla.redhat.com/show_bug.cgi?id=1970237
FROM centos:7
LABEL name="beaker_server_container"
RUN yum upgrade -y && \
  yum-config-manager --add-repo https://beaker-project.org/yum/beaker-server-RedHatEnterpriseLinux.repo && \
  yum -y install beaker-server  && \
  yum -y install beaker-client && \
  yum -y install MySQL-python && \
  yum -y install httpd && \
  yum clean all && \
  systemctl enable httpd.service && \
  systemctl enable beakerd.service
CMD [ "/usr/sbin/init" ]
