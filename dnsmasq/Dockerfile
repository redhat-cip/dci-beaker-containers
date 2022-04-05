# NOTE: Podman/systemd is incompatible with cgroups v2 (F34+).  Revert to v1 if necessary by
# adding kernel arg systemd.unified_cgroup_hierarchy=0.
# https://bugzilla.redhat.com/show_bug.cgi?id=1970237
FROM centos:7
LABEL name="dnsmasq_container"
RUN yum upgrade -y && \
  yum -y install dnsmasq && \
  yum clean all && \
  systemctl enable dnsmasq.service
CMD [ "/usr/sbin/init" ]
