# NOTE: Podman/systemd is incompatible with cgroups v2 (F34+).  Revert to v1 if necessary by
# adding kernel arg systemd.unified_cgroup_hierarchy=0.
# https://bugzilla.redhat.com/show_bug.cgi?id=1970237
FROM centos:7
LABEL name="beaker_web_server"
RUN yum upgrade -y && \
  yum-config-manager --add-repo https://beaker-project.org/yum/beaker-server-RedHatEnterpriseLinux.repo && \
  yum -y install httpd && \
  yum -y install beaker-server && \
#  yum -y install mod_wsgi && \
#  yum -y install python-setuptools && \
#  yum -y install python-flask && \
#  yum -y install epel-release && \
#  yum -y install TurboGears && \
  yum clean all
COPY root /
CMD [ "/usr/bin/init.sh" ]
