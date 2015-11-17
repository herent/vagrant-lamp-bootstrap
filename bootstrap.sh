#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECT_FOLDER='project'
PASSWORD='abc123'
GIT_USER='Your Name'
GIT_EMAIL='you@company.com'
# This only works with http repos currently
# Hopefully support for other url formats will come soon
GIT_REPO='https://github.com/concrete5/concrete5.git'

# create project folder
sudo mkdir "/var/www/html/${PROJECT_FOLDER}"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server

# install apache
sudo apt-get install -y apache2 

# apache modules - v1
sudo a2enmod rewrite
sudo a2enmod php5
sudo a2enmod ruby
sudo a2enmod python
sudo a2enmod auth-mysql
sudo a2enmod gzip
sudo a2enmod headers
sudo a2enmod pagespeed
sudo a2enmod xml
sudo a2enmod xml-curl
sudo a2enmod xmlrpc
sudo a2enmod zlib

# apache modules - v2
#sudo apt-get -y install libapache2-mod-rewrite
#sudo apt-get -y install libapache2-mod-php5
#sudo apt-get -y install libapache2-mod-ruby
#sudo apt-get -y install libapache2-mod-python
#sudo apt-get -y install libapache2-mod-auth-mysql
#sudo apt-get -y install libapache2-mod-gzip
#sudo apt-get -y install libapache2-mod-headers
#sudo apt-get -y install libapache2-mod-pagespeed
#sudo apt-get -y install libapache2-mod-xml
#sudo apt-get -y install libapache2-mod-xml-curl
#sudo apt-get -y install libapache2-mod-xmlrpc
#sudo apt-get -y install libapache2-mod-zlib

# install php
sudo apt-get install -y php5
sudo apt-get install -y php5-cli
sudo apt-get install -y php5-dev
sudo apt-get install -y php5-fpm
sudo apt-get install -y php5-cgi
sudo apt-get install -y php5-mysql
sudo apt-get install -y php5-xmlrpc
sudo apt-get install -y php5-curl
sudo apt-get install -y php5-gd
sudo apt-get install -y php-apc
sudo apt-get install -y php-pear
sudo apt-get install -y php5-imap
sudo apt-get install -y php5-mcrypt
sudo apt-get install -y php5-pspell

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# xdebug
sudo apt-get install php5-xdebug
XDEBUGSETTINGS=$(cat <<EOF
	[xdebug]
	zend_extension = /usr/lib/php5/20121212/xdebug.so
	xdebug.default_enable: '1'
	xdebug.remote_autostart: '0'
	xdebug.remote_connect_back: '1'
	xdebug.remote_enable: '1'
	xdebug.remote_handler: dbgp
	xdebug.remote_port: '9000'
EOF
)
echo "${XDEBUGSETTINGS}" > /etc/php5/mods-available/xdebug.ini
sudo ln -s /etc/php5/mods-available/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini
sudo ln -s /etc/php5/mods-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/!{PROJECT_FOLDER}"
    <Directory "/var/www/html/!{PROJECT_FOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# python
sudo apt-get -y install python
sudo apt-get -y install python-mysqldb
# ruby
sudo apt-get -y install ruby

# extra stuff / incidentals
sudo apt-get -y install curl
sudo apt-get -y install build-essential
sudo apt-get -y install libssl-dev
sudo apt-get -y install libreadline-dev
sudo apt-get -y install libyaml-dev
#sudo apt-get -y install sqlite3
#sudo apt-get -y install libsqlite3-dev
#sudo apt-get -y install libxml2-dev
#sudo apt-get -y install libxslt1-dev
#sudo apt-get -y install python-software-properties
sudo apt-get -y install imagemagick
sudo apt-get -y install pv

# install git
sudo apt-get -y install git git-core
# setup git user info
git config --global --unset-all user.name
git config --global --unset-all user.email
git config --global user.name = "${GIT_USER}"
git config --global user.email = "${GIT_EMAIL}"

# grab the repo for this vagrant box
git clone "${GIT_REPO}" "/var/www/html/!{PROJECT_FOLDER}"

# restart apache
service apache2 restart