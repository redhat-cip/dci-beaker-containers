FROM centos:7
LABEL name="beaker_server_container"
RUN yum upgrade -y && \
  yum -y install epel-release
RUN yum-config-manager --save --setopt=epel.exclude=nodejs*,npm
RUN yum-config-manager --add-repo https://beaker-project.org/yum/beaker-server-RedHatEnterpriseLinux.repo && \
  yum -y install beaker-server  && \
  yum -y install beaker-client && \
  yum -y install MySQL-python && \
  yum -y install mariadb && \
  yum -y install supervisor && \
  yum -y install httpd && \
  yum -y install mod_wsgi && \
  yum clean all
COPY config/server.cfg /etc/beaker/server.cfg
COPY config/client.conf /etc/beaker/client.conf
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/beaker-server.conf /etc/httpd/conf.d/beaker-server.conf

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-n"]
