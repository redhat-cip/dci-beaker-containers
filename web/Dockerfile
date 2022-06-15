FROM centos:7
LABEL name="beaker_web_server"
RUN yum upgrade -y && \
   yum-config-manager --add-repo https://beaker-project.org/yum/beaker-server-RedHatEnterpriseLinux.repo && \
  yum -y install httpd && \
  yum -y install mod_wsgi && \
  yum -y install beaker-server && \
  yum clean all
COPY beaker-server.conf /etc/httpd/conf.d/beaker-server.conf
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
