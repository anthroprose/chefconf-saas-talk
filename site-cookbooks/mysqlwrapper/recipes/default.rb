node.set['mysql']['bind_address'] = node['mysqlwrapper']['ip']

user_account node['mysqlwrapper']['user'] do
  comment       'Mysql User'
  ssh_keygen    true
  manage_home   false
  ssh_keys node[:mysqlwrapper][:ssh_keys]
end

include_recipe 'mysql::server'

service "mysql" do
  action [ :restart ]
end

mysqlwrapper_upload_pubkey node['mysqlwrapper']['pubkey_loc'] do
  action :upload
end