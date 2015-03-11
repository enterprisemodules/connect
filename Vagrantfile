# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hajee/centos-5.10-x86_64"

  config.vm.provision :shell, :inline => "rm -rf /etc/puppet/modules/connect; ln -s /vagrant /etc/puppet/modules/connect"
  config.vm.provision :shell, :inline => "ln -sf /vagrant/hiera.yaml /etc/puppet/hiera.yaml"
  config.vm.provision :shell, :inline => "ln -sf /vagrant/examples /etc/puppet/connect"
end
