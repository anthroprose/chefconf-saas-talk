include_recipe "chef_handler"

cookbook_file "#{node["chef_handler"]["handler_path"]}/mysqlwrapper.rb" do
  source "chef_handler-mysqlwrapper.rb"
  owner "root"
  group "root"
  mode 00755
  action :create
end

chef_handler "Opscode::MysqlwrapperHandler" do
  source "#{node["chef_handler"]["handler_path"]}/mysqlwrapper.rb"
  supports :report => true
  action :enable
end

node.set['mysql']['bind_address'] = node['mysqlwrapper']['ip']

user_account node['mysqlwrapper']['user'] do
  comment       'Mysql User'
  ssh_keygen    true
  manage_home   false
  ssh_keys node[:mysqlwrapper][:ssh_keys]
end

mysqlwrapper_upload_pubkey node['mysqlwrapper']['pubkey_loc'] do
  action :upload
end