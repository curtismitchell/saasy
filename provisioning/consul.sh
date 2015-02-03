#!/bin/bash
sudo apt-get --assume-yes install unzip curl
sudo unzip /vagrant/bins/0.4.1_linux_amd64.zip -d /usr/bin
mkdir -p /opt/Consul/data
mkdir -p /opt/Consul/config
sudo cp /vagrant/provisioning/consul-config.json /opt/Consul/config/
sudo unzip /vagrant/bins/0.4.1_web_ui.zip -d /opt/Consul
sudo chown -R vagrant: /opt/Consul
sudo cp /vagrant/provisioning/consul-server.sh /etc/init.d/consul-server
sudo chmod a+x /etc/init.d/consul-server
sudo /etc/init.d/consul-server start
