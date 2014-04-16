#!/usr/bin/env rake
################### Config #####################
# Ethernet Device to pull IP Address of HOST
# Also set these in the Vagrantfile
ETHERNET_DEVICE = 'wlan0'
CHEF_SERVER_IP = %x[ifconfig #{ETHERNET_DEVICE} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'].strip
################################################

task :default => 'init'

desc "Initializes the MySQLWrapper Cluster"
task :init do
  Rake::Task["keygen"].execute
  Rake::Task["chefzero"].execute
end

desc "Refreshes Everything"
task :refresh do
  Rake::Task["berks"].execute
  Rake::Task["upload"].execute
end

desc "Berksfile "
task :berks do
  sh "berks install --path cookbooks"
end

desc "Generates Key"
task :keygen do
  if !File.exist?('chef-zero.pem') then
    sh "ssh-keygen -f chef-zero.pem -t rsa -N ''"
  end
end

desc "Runs Chef-Zero"
task :chefzero do
  sh "chef-zero -d -H #{CHEF_SERVER_IP}"
  Rake::Task["refresh"].execute
end

desc "Uploads Cookbooks to Chef-Zero"
task :upload do
  sh "knife upload -s http://#{CHEF_SERVER_IP}:8889 -k ./chef-zero.pem -u vagrant --chef-repo-path . ."
end

desc "Shuts down Chef-Zero"
task :destroy do
  sh "pkill -f chef-zero"
  sh "vagrant destroy -f"
  sh "rm -rf cookbooks/*"
end

desc "Runs Cluster Example"
task :up do
  sh "vagrant up"
end

desc "Provisions Machines"
task :provision do
  sh "vagrant provision"
end

desc "Deploys and Converges Cluster"
task :converge do
  Rake::Task["up"].execute
  Rake::Task["provision"].execute
end

desc "Sets up Tablespace for Customer"
task :customer do
  sh "vagrant ssh mysql-master -c \"mysql -uroot -pxxxxxxxxxx -e \\\"USE mysqlwrapper;CREATE TABLE IF NOT EXISTS mysqlwrapper.customers (id BIGINT NOT NULL AUTO_INCREMENT ,name VARCHAR(128) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL , PRIMARY KEY (id));\\\"\""
  sh "vagrant ssh mysql-master -c \"mysql -uroot -pxxxxxxxxxx -e \\\"USE mysqlwrapper;INSERT INTO mysqlwrapper.customers (name) VALUES ('ChefConf2014');\\\"\""
end

desc "Tests the Customer Slave/Replication Setup"
task :slave do
  sh "vagrant ssh mysql-slave -c \"mysql -uroot -pxxxxxxxxxx -e \\\"\SELECT * FROM mysqlwrapper.customers;\\\"\""
end

desc "Magic Multiple Convergence and Testing"
task :magic do
  Rake::Task["init"].execute
  Rake::Task["up"].execute
  Rake::Task["converge"].execute
  Rake::Task["converge"].execute
  Rake::Task["customer"].execute
  Rake::Task["slave"].execute
end