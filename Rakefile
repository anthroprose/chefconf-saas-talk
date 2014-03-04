#!/usr/bin/env rake
ETHERNET_DEVICE = 'wlan0'
task :default => 'install'

desc "Installs prereqs"
task :install do
  sh "berks install --path cookbooks"
  if !File.exist?('chef-zero.pem') then
    sh "ssh-keygen -f chef-zero.pem -t rsa -N ''"
  end
end

desc "Runs Chef-Zero"
task :chefzero do
  CHEF_SERVER_IP = %x[ifconfig #{ETHERNET_DEVICE} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'].strip
  sh "chef-zero -d -H #{CHEF_SERVER_IP}"
  sh "knife upload -s http://#{CHEF_SERVER_IP}:8889 -k ./chef-zero.pem -u vagrant --chef-repo-path . ."
end

desc "Shuts down Chef-Zero"
task :done do
  sh "killall -9 chef-zero"
end