FROM centos:7
LABEL name="beaker-server-container"
COPY files/beaker-server-RedHatEnterpriseLinux.repo /etc/yum.repos.d
# `mirrorlist.centos.org` no longer exists. Use `vault.centos.org`
COPY files/centos-7-vault.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum upgrade -y && \
  yum -y install epel-release dnf dnf-plugins-core
RUN yum-config-manager --save --setopt=epel.exclude=nodejs*,npm
RUN dnf -y copr enable bpeck/beaker && \
  yum -y install beaker-server  && \
  yum -y install beaker-client && \
  yum -y install MySQL-python && \
  yum -y install mariadb && \
  yum -y install supervisor && \
  yum -y install httpd && \
  yum -y install mod_wsgi && \
  yum clean all && \
  mkdir -p /defaults /config
COPY config/server.cfg /etc/beaker/server.cfg.orig
COPY config/client.conf /etc/beaker/client.conf.orig
COPY config/beaker-server.conf /etc/httpd/conf.d/beaker-server.conf.orig
COPY config/supervisord.conf /etc/supervisord.conf

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-n"]
