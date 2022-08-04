# NOTE: Podman/systemd is incompatible with cgroups v2 (F34+).  Revert to v1 if necessary by
# adding kernel arg systemd.unified_cgroup_hierarchy=0.
# https://bugzilla.redhat.com/show_bug.cgi?id=1970237
FROM centos:7
LABEL name="dnsmasq_container"
RUN yum upgrade -y && \
  yum -y install epel-release
RUN yum-config-manager --save --setopt=epel.exclude=nodejs*,npm && \
  yum -y install dnsmasq && \
  yum -y install supervisor && \
  yum clean all

EXPOSE 53/udp
EXPOSE 53/tcp

COPY config/supervisord.conf /etc/supervisord.conf
COPY config/beaker.conf /etc/dnsmasq.d/beaker.conf
CMD ["supervisord", "-n"]
