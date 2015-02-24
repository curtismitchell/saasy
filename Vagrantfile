# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true
    vb.memory = 256
    vb.cpus = 1
  end

  chipmunks = ["alvin", "simon", "theodore"]
  ips = ["192.168.24.2", "192.168.24.3", "192.168.24.4"]

  chipmunks.each_with_index do |cm, ndx|
    config.vm.define cm do |cbox|
      ip = ips[ndx]
      cbox.vm.box = "ubuntu/trusty64"
      cbox.vm.hostname = cm + ".local.dev"
      cbox.vm.network "private_network", ip: ip
      #cbox.vm.provision "shell", path: "provisioning/ansible.sh"
      cbox.vm.provision "shell", inline: <<-SCRIPT
mkdir -p /opt/Consul/data
chown vagrant:vagrant /opt/Consul/data
sudo cp /vagrant/provisioning/consul-upstart.conf /etc/init/consul.conf

mkdir -p /etc/consul.d/server
SCRIPT
      if ndx == 0
        cbox.vm.provision "shell", inline: <<-SCRIPT
sudo cat > /etc/consul.d/server/config.json <<- CFG
{
  "bootstrap_expect": #{chipmunks.length},
  "datacenter": "local-vagrant",
  "data_dir": "/opt/Consul/data",
  "log_level": "DEBUG",
  "server": true,
  "ui_dir": "/opt/Consul/dist",
  "client_addr": "#{ip}",
  "bind_addr": "#{ip}"
}
CFG
SCRIPT
      else
        cbox.vm.provision "shell", inline: <<-SCRIPT
sudo cat > /etc/consul.d/server/config.json <<- CFG
{
  "bootstrap": false,
  "datacenter": "local-vagrant",
  "data_dir": "/opt/Consul/data",
  "log_level": "DEBUG",
  "server": true,
  "ui_dir": "/opt/Consul/dist",
  "client_addr": "#{ip}",
  "bind_addr": "#{ip}",
  "start_join": #{(ips.select{|x| x != ip}).to_s}
}
CFG
SCRIPT
      end
      cbox.vm.provision "shell", path: "provisioning/consul.sh"
    end
  end

  config.vm.define "db" do |db|
    db.vm.box = "chef/centos-7.0"
    db.vm.hostname = "mysql1.local.dev"
    db.vm.network "private_network", ip: "192.168.24.30"
    # config.vm.network "forwarded_port", guest: 3306, host: 3306
    db.vm.provision "shell", inline: <<-SCRIPT
sudo yum -y install mariadb-server mariadb
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service
mysqladmin -u root password 7layer

sudo yum -y install unzip curl
sudo unzip /vagrant/bins/0.4.1_linux_amd64.zip -d /usr/bin
mkdir -p /opt/Consul/data
mkdir -p /opt/Consul/config

sudo cat > /opt/Consul/config/consul-config.json <<- CFG
{
  "bootstrap": false,
  "datacenter": "local-vagrant",
  "data_dir": "/opt/Consul/data",
  "log_level": "debug",
  "server": false,
  "client_addr": "192.168.24.30",
  "bind_addr": "192.168.24.30",
  "start_join": #{ips.to_s}
}
CFG

echo '{"service": {"name":"mysql","tags": ["rdbs"], "port": 3306}}' > /opt/Consul/config/mysql.json

sudo chown -R vagrant: /opt/Consul
sudo cp /vagrant/provisioning/consul-server.sh /etc/init.d/consul-server
sudo chmod a+x /etc/init.d/consul-server
sudo /etc/init.d/consul-server start
SCRIPT

  end

end
