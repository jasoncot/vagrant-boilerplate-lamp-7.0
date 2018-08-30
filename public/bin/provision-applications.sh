#!/usr/bin/env bash
if [ -e /home/vagrant/.profile ]; then
  source /home/vagrant/.profile
fi

# Use this while not running as root to run commands local to the vagrant user
if [ ! -e /home/vagrant/bin ]; then
  mkdir -p /home/vagrant/bin
fi

if [ ! -e /home/vagrant/bin/composer.phar ]; then
  cd ~/bin
  php /vagrant/bin/composer-installer

  # Useful tools and resources: http://web-techno.net/code-quality-check-tools-php/
  # Coding Standards Fixer: https://github.com/FriendsOfPHP/PHP-CS-Fixer
  # CodeSniffer: https://github.com/squizlabs/PHP_CodeSniffer
  # Mess detector: https://phpmd.org/download/index.html
  # PHPStan: https://github.com/phpstan/phpstan
  php /home/vagrant/bin/composer.phar global require friendsofphp/php-cs-fixer "squizlabs/php_codesniffer=*" phpmd/phpmd phpstan/phpstan phploc/phploc phpmetrics/phpmetrics

  cd -
  echo 'PATH="$PATH:/home/vagrant/.config/composer/vendor/bin"' | tee /home/vagrant/.profile
fi

nvm > /dev/null
if [ $? -ne 0 ]; then
  # Working with getting node dependencies instaled for the apex code base
  bash /vagrant/bin/nvm-install.sh
  source /home/vagrant/.profile
  nvm install 6.2.0
fi

exit 0;
