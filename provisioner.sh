#!/bin/bash
#sudo apt-get install python-software-properties -y

apt-get install apt-transport-https lsb-release ca-certificates git git-core zip unzip -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# sudo bash -c 'echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list'
apt-get update
apt-get remove php php5 -y
apt-get install php7.2 php7.2-{bz2,cgi,cli,curl,dev,fpm,gd,json,mbstring,mysql,phpdbg,readline,soap,xml,xmlrpc,zip} php-xdebug -y
apt-get --purge autoremove -y

sed -e 's/www-data/vagrant/g' -i /etc/php/7.2/fpm/pool.d/www.conf

service php7.2-fpm restart

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -y install mysql-server mysql-client
service mysql start

apt-get install apache2 apache2-utils libapache2-mod-php7.2 -y
bash -c 'echo "ServerName server_domain_or_IP" >> /etc/apache2/apache2.conf'
sed -e 's/www-data/vagrant/g' -i /etc/apache2/envvars

a2enmod rewrite vhost_alias proxy proxy_http php7.2 proxy_fcgi setenvif
a2enconf php7.2-fpm
a2dissite 000-default

# Disabling this because this is my personal code
sudo cp /opt/config/*.conf /etc/apache2/sites-available/
sudo a2ensite apache-virtual-host

service apache2 restart

su -c "bash /vagrant/bin/provision-applications.sh" - vagrant
