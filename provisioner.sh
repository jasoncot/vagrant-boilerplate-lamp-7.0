#!/bin/bash
sudo apt-get install python-software-properties -y
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get remove php php5 -y
sudo apt-get install php7.0 php7.0-{cgi,cli,common,dev,fpm,gd,json,mbstring,mcrypt,mysql,phpdbg,readline,soap,xml} -y
sudo apt-get --purge autoremove -y
sudo service php7.0-fpm restart

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server mysql-client
sudo service mysql start

sudo apt-get install apache2 apache2-utils libapache2-mod-php7.0 -y
sudo bash -c 'echo "ServerName server_domain_or_IP" >> /etc/apache2/apache2.conf'
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo a2enmod php7.0

sudo cp /vagrant/apache-virtual-host.conf /etc/apache2/sites-available/001-php-site.conf
sudo a2ensite 001-php-site
sudo service apache2 restart
