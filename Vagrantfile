# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

# Chef Client version to Install (always version pin *everything*)
CHEF_CLIENT_VERSION = '11.10.4'
ETHERNET_DEVICE = 'wlan0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	
	## This just finds the HOST's IP from the interface defined above (for connecting back out to chef-zero)
	CHEF_SERVER_IP = %x[ifconfig #{ETHERNET_DEVICE} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'].strip

	config.chef_zero.enabled = false
	config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
	config.vm.box = "precise64"
	
	config.vm.provider :virtualbox do |vb|
	    vb.customize ["modifyvm", :id, "--memory", "1024"]
	    vb.customize ["modifyvm", :id, "--usb", "off"]
	    vb.customize ["modifyvm", :id, "--cpus", "1"]
	    vb.customize ["modifyvm", :id, "--ioapic", "on"]
	end
	
	config.vm.provision "shell" do |s|
		s.inline = "curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -v #{CHEF_CLIENT_VERSION}"
	end
  		
	config.vm.define "mysql-master" do |mysqlmaster|
	
		mysqlmaster.vm.hostname = "mysql-master"
		mysqlmaster.vm.network "private_network", ip: "10.254.0.2"

		mysqlmaster.vm.provision "chef_client" do |chef|
			chef.chef_server_url = "http://#{CHEF_SERVER_IP}:8889/"
			chef.validation_key_path = 'chef-zero.pem'
			chef.add_recipe 'mysql'
		end
		
	end

end