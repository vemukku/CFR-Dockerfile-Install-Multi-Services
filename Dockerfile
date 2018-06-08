
#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for Apache+PHP+Ngnix:centos-7
#+++++++++++++++++++++++++++++++++++++++

FROM centos:7
MAINTAINER The CentOS Project <cloud-ops@centos.org
LABEL Vendor="CentOS"
LABEL Component="nginx"
LABEL Component="apache+mod_php"

# -----------------------------------------------------------
# INSTALLING APACHE+PHP+NGINX
# -----------------------------------------------------------
RUN yum -y update && yum -y install \ 
    epel-release.noarch \
    nginx \
    httpd \
    php7 \	
	git \
	memcached \ OR php-memcached
 && yum clean all
 
# Install Remi Collet's repo for CentOS 7
RUN yum -y install \
  http://rpms.remirepo.net/enterprise/remi-release-7.rpm  \
  
RUN yum -y install --enablerepo=remi,remi-php70 \
  php-cli \
  php-fpm \
  php-gd \
  php-mbstring \
  php-mcrypt \
  php-mysqlnd \
  php-opcache \
  php-pdo \
  php-pear \
  php-soap \
  php-xml \
  php-pecl-imagick \
  php-pecl-apcu

#---------------------------------------------------------------------  
# Remove the default Nginx configuration file
#--------------------------------------------------------------------
RUN rm -v $(NGINX_CONF_PATH)

#--------------------------------------------------------------------
# Remove the default Apache configuration file
#---------------------------------------------------------------------
RUN rm -v $(APACHE_CONF_PATH)

#----------------------------------------------------------------------
# Copy Nginx configuration file from the Local Directory to Container
#----------------------------------------------------------------------
COPY ${NGINX_SOURCE_CONF_PATH} $(NGINX_CONF_PATH}

#-----------------------------------------------------------------------
# Copy Apache configuration file from the Local Directory to Container
#-----------------------------------------------------------------------
COPY ${APACHE_SOURCE_CONF_PATH} ${APACHE_CONF_PATH}

#--------------------------------------------------------------------
# Binding Volume(Mounting) for Nginx Document Root
#--------------------------------------------------------------------
RUN mkdir -p /var/www/nginxdomain.com
RUN chmod 755 /var/www/nginxdomain.com
VOLUME ["/var/www/nginxdomain.com"]

#---------------------------------------------------------------------
# Binding Volume(Mounting) for Apache Document Root
#------------------------------------------------------------------------
RUN mkdir -p /var/www/apachedomain.com
RUN chmod 755 /var/www/apachedomain.com
VOLUME ["/var/www/apachedomain.com"]

#-----------------------------------------------------------------------
# Copy test php to Apache Document Roor
COPY ${PHP_DOCUMENT_INDEX} ${APACHE_DOCUMENT_ROOT}

# -----------------------------------------------------------------------------
# Set ports
# -----------------------------------------------------------------------------
EXPOSE 8080 80

# Set the default command to execute when creating a new container
#ENTRYPOINT ["nginx", "-g", "daemon off;"]
CMD ["/usr/sbin/nginx"]

#ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]

CMD ["memcached", "-u", "daemon"]
              
#ENTRYPOINT ["/usr/sbin/php-fpm", "-F"]

#ENTRYPOINT ["/usr/bin/supervisord"]

# Configure Services and Port
# COPY start.sh /start.sh
# CMD ["./start.sh"]

# -----------------------------------------------------------
# Set environment variables for APACHE+PHP+NGINX 
# -----------------------------------------------------------

ENV APACHE_DOCUMENT_ROOT=/var/www/apachedomain.com \
    NGINX_DOCUMENT_ROOT=/var/www/nginxdomain.com \
    PHP_DOCUMENT_INDEX=test.php \
    APACHE_CONF_PATH=/etc/httpd/conf \
    APACHE_SOURCE_CONF_PATH=/templates/httpd.conf \
    NGINX_CONF_PATH=/etc/nginx/conf.d/default.conf \
    NGINX_SOURCE_CONF_PATH=/templates/default.conf \
