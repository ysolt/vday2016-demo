# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "centos/7"

  config.ssh.insert_key = false

  config.vm.network "forwarded_port", guest: 80, host: 8082

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "1024"
  end

  config.vm.provision "shell", :path => 'scripts/docker_install.sh'
  config.vm.provision "shell", :path => 'scripts/container_run.sh', :env => { :ENVIRONMENT => "vm", :VERSION => ENV['CONTAINER_VERSION']  }
end
