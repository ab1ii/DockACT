#jmt67 act web client container
#get os, webserver, php , yum, etc.
FROM centos:7

#
# Import the Centos-6 RPM GPG key to prevent warnings and Add EPEL Repository
#
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm \
	&& rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum install epel-release \
    yum-config-manager --enablerepo remi-php56

RUN yum -y install \
    httpd \
    mod_ssl \
    php \
    php-cli \
    php-common \
    php-devel \
    php-gd \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-pecl-memcached \
    php-xml \
    php-imap \
    php-soap \
    php-pear.noarch \
    php-opcache \ 
    at 
 


RUN yum update -y


EXPOSE 80


#copy source code
COPY act-webclient /var/www/html/

#create working dir with correct access
RUN mkdir /opt/viewer_jobs
RUN chmod -R a+w /opt/viewer_jobs

ARG shrineURL
ARG i2b2Domain
ARG i2b2PM

#Config Section
RUN sed -i "s|your_SHRINE_URL_here|${shrineURL}|g" /var/www/html/ACT_config.php
RUN sed -i "s|your_i2b2_Domain_here|${i2b2Domain}|g" /var/www/html/i2b2_config_data.js
RUN sed -i "s|your_i2b2_PM_cell_URL_here|${i2b2PM}|g" /var/www/html/i2b2_config_data.js

# Start Apache and start the atd service that's needed by the patient set viewer
CMD /usr/sbin/atd && /usr/sbin/httpd -c "ErrorLog /var/log/httpd/error_log" -DFOREGROUND 

