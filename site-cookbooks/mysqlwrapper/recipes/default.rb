user_account node['mysqlwrapper']['user'] do
  comment       'Mysql User'
  ssh_keygen    true
  manage_home   false
  ssh_keys node[:mysqlwrapper][:ssh_keys]
  notifies :run, "ruby_block[upload_pubkey]"
end

include_recipe 'mysql::server'

## Save the Pubkey to ChefServer
ruby_block "upload_pubkey" do
  block do
    if File.exists?(node['mysqlwrapper']['pubkey_loc']) then
      node.set['mysqlwrapper']['ssh_pubkey'] = IO.read(node['mysqlwrapper']['pubkey_loc'])
      Chef::Log.info("Saving MySQLWrapper PubKey for Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    end
  end
  action :nothing
end