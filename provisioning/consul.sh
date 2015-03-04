#!/bin/bash

consul_package="0.5.0_linux_amd64.zip"
vagrant_path="/vagrant/bins/"
consul_ui_package="0.5.0_web_ui.zip"

if [ ! -f "$vagrant_path$consul_package" ]; then
  sudo wget -O $vagrant_path$consul_package "https://dl.bintray.com/mitchellh/consul/$consul_package"
fi

sudo yum -y install unzip curl

sudo unzip "$vagrant_path$consul_package" -d /usr/bin

if [ ! -f "$vagrant_path$consul_ui_package" ]; then
  sudo wget -O "$vagrant_path$consul_ui_package" "https://dl.bintray.com/mitchellh/consul/$consul_ui_package"
fi

sudo unzip "$vagrant_path$consul_ui_package" -d /opt/Consul

sudo cp /vagrant/provisioning/consul-server.sh /etc/init.d/consul-server
sudo chmod a+x /etc/init.d/consul-server
sudo /etc/init.d/consul-server start
