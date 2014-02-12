# -*- mode: ruby -*-
# vi: set ft=ruby :


$CLIENT_SCRIPT = <<EOF
touch /var/log/vagrant-setup.log; \
source /vagrant/config/client_config/config.sh | tee -a /var/log/vagrant-setup.log;\
sh /vagrant/config/client_config/install.sh    | tee -a /var/log/vagrant-setup.log;
EOF


# Basic Mongod
$MONGOD_SCRIPT = <<EOF
touch /var/log/vagrant-setup.log; \
source /vagrant/config/mongo_config/config.sh | tee -a /var/log/vagrant-setup.log;\
bash /vagrant/config/mongo_config/install.sh    | tee -a /var/log/vagrant-setup.log;
EOF


Vagrant.configure("2") do |config|

  config.vm.define :mongod do |mongod|
    # pick my own version here
    mongod.vm.box = "CentoOS 6.4"
    mongod.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"

    mongod.vm.provider "virtualbox" do |v|
       v.customize ["modifyvm", :id, "--cpus", "2"]
    end

    mongod.vm.network :private_network, ip: "192.168.19.100"
    mongod.vm.hostname = "rhel64.example.com"
    mongod.vm.provision :shell, :inline => $MONGOD_SCRIPT
  end

  config.vm.define :ubuntu1204 do |mongod|
    # pick my own version here
    mongod.vm.box = "Ubunto 12.04"
    mongod.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

    mongod.vm.provider "virtualbox" do |v|
       v.customize ["modifyvm", :id, "--cpus", "2"]
    end

    mongod.vm.network :private_network, ip: "192.168.19.101"
    mongod.vm.hostname = "ubuntu1204.example.com"
    mongod.vm.provision :shell, :inline => $MONGOD_SCRIPT
  end

  config.vm.define :client do |host|
    # pick my own version here
    host.vm.box = "CentoOS 6.4"
    host.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"

    host.vm.provider "virtualbox" do |v|
       v.customize ["modifyvm", :id, "--cpus", "2"]
    end

    host.vm.network :private_network, ip: "192.168.19.200"
    host.vm.hostname = "client.example.com"
    host.vm.provision :shell, :inline => $CLIENT_SCRIPT
  end
end
