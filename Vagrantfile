# -*- mode: ruby -*-
# vi: set ft=ruby :

$MONGO_SCRIPT = <<EOF
touch /var/log/vagrant-setup.log; \
source /vagrant/config/mongo_config/config.sh | tee -a /var/log/vagrant-setup.log;\
sh /vagrant/config/mongo_config/install.sh    | tee -a /var/log/vagrant-setup.log;
EOF


Vagrant.configure("2") do |config|
  # default Vbox imageß
  config.vm.box = "Fedora-18-VBox"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210.box"
  
  config.vm.define :mongod do |mongod|
    # pick my own version here
    mongod.vm.box = "CentoOS 6.4"
    mongod.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"

    mongod.vm.provider "virtualbox" do |v|
       # v.gui = true
       v.memory = 1024
       # v.customize ["modifyvm", :id, "--cpus", "2"]
       # v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    end

    # mongod.vm.network :forwarded_port, guest: 80, host: 28888
    # mongod.vm.network :forwarded_port, guest: 443, host: 4443
    mongod.vm.network :private_network, ip: "192.168.19.152"
    mongod.vm.hostname = "mongod.example.com"
    mongod.vm.provision :shell, :inline => $MONGO_SCRIPT
  end

  config.vm.define :win1 do |win|
    # a sample windows vbox
    win.vm.box = "windows2008R2"
    win.vm.guest = :windows

    win.vm.provider "virtualbox" do |v|
        v.gui = true
    end

    win.vm.network :private_network, ip: "192.168.19.60"
    win.vm.hostname = "win1.example.com"

    # Port forward WinRM and RDP
    win.vm.network :forwarded_port, guest: 3389, host: 3389
    win.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
  end

end
