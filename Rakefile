#!/usr/bin/env rake
################### Config #####################
# Ethernet Device to pull IP Address of HOST
ETHERNET_DEVICE = 'wlan0'
CHEF_SERVER_IP = %x[ifconfig #{ETHERNET_DEVICE} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'].strip
################################################

task :default => 'install'

desc "Installs prereqs"
task :install do
  Rake::Task["berks"].execute
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
  Rake::Task["upload"].execute
end

desc "Uploads Cookbooks to Chef-Zero"
task :upload do
  sh "knife upload -s http://#{CHEF_SERVER_IP}:8889 -k ./chef-zero.pem -u vagrant --chef-repo-path . ."
end

desc "Shuts down Chef-Zero"
task :done do
  sh "pkill -f chef-zero"
  sh "cd database;vagrant destroy -f"
end

desc "Runs Database Example"
task :database do
  sh "cd database;vagrant up"
end