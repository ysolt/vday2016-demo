FROM centos:7
MAINTAINER "Zsolt Molnar" <ysolt@ysolt.net>
ENV container docker
ARG MARIADB_VERSION=5.5.44-2.el7.centos 
ARG DRUPAL_VERSION=8.2.2
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
EXPOSE 80

RUN   yum install -y mariadb-server-$MARIADB_VERSION epel-release centos-release-scl; \
      yum-config-manager --enable rhel-server-rhscl-7-rpms; \
      yum install -y nginx php-fpm rh-php56-php-fpm rh-php56-php-gd rh-php56-php-pdo rh-php56-php-opcache rh-php56-php-mysqlnd rh-php56-php-xml
ADD vhost-drupal.conf  /etc/nginx/conf.d/vhost-drupal.conf
ADD vhost-default.conf /etc/nginx/nginx.conf
RUN   sed -ie 's!^listen =.*!listen = /var/run/php5-fpm.sock!' /etc/opt/rh/rh-php56/php-fpm.d/www.conf; \
      sed -ie 's!.*listen.owner =.*!listen.owner = nginx!' /etc/opt/rh/rh-php56/php-fpm.d/www.conf; \
      sed -ie 's!user = .*!user = nginx!' /etc/opt/rh/rh-php56/php-fpm.d/www.conf; \
      cd /etc/systemd/system/multi-user.target.wants; \
      ln -s /usr/lib/systemd/system/mariadb.service; \
      ln -s /usr/lib/systemd/system/nginx.service; \
      ln -s /usr/lib/systemd/system/rh-php56-php-fpm.service
RUN   yum install -y wget; \
      mkdir -p /var/www/drupal; \
      wget -q https://ftp.drupal.org/files/projects/drupal-$DRUPAL_VERSION.tar.gz -O /tmp/drupal.tar.gz; \
      tar xfz /tmp/drupal.tar.gz -C /var/www/drupal/  --strip 1; \
      chown nginx.nginx -R /var/www/drupal/

