VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/debian-9.5"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision "shell", path: "provisioner.sh"
  config.vm.synced_folder "workspace/", "/opt/workspace"
  config.vm.synced_folder "config/", "/opt/config"
  config.vm.synced_folder "public/", "/vagrant"
  config.vm.synced_folder "../learning-php-project/", "/var/www/php-src"
end
