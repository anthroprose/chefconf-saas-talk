config = data_bag_item('mysqlwrapper', node['mysqlwrapper']['cluster'])
node.set['mysql']['server_root_password'] = config['mysqlwrapper']['slave_password']
node.set['mysql']['server_debian_password'] = config['mysqlwrapper']['slave_password']
node.set['mysql']['server_repl_password'] = config['mysqlwrapper']['repl_password']

include_recipe 'mysql::server'

service "mysql" do
  action [ :restart ]
end

nodes = search(:node, "mysqlwrapper_cluster:#{node['mysqlwrapper']['cluster']} AND mysqlwrapper_type:master")
Chef::Log.info("Chef Search: mysqlwrapper_cluster:#{node['mysqlwrapper']['cluster']} AND mysqlwrapper_type:master")

begin
  Chef::Log.info("MySQLWrapper Slave is Searching for Master of Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
  nodes.each do |n|
    
    Chef::Log.info("Searching through Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    
    if n.has_key?'mysqlwrapper' and n['mysqlwrapper'].has_key?'ssh_pubkey' and n['mysqlwrapper']['ssh_pubkey'] != '' then
      
      Chef::Log.info("Has Pubkey In Place: #{node[:mysqlwrapper][:ssh_keys]} for Node: #{n.name} - Cluster: #{n['mysqlwrapper']['ssh_pubkey']}")
      
      if node[:mysqlwrapper][:ssh_keys] != n['mysqlwrapper']['ssh_pubkey'] then
        
        Chef::Log.info("Found Public Key for Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
        node.set["mysqlwrapper"]["ssh_keys"] = n['mysqlwrapper']['ssh_pubkey']
        node.set["mysqlwrapper"]["pulled_pubkey"] = 1
        
        user_account node['mysqlwrapper']['user'] do
          comment       'Mysql User'
          ssh_keygen    true
          manage_home   false
          ssh_keys node[:mysqlwrapper][:ssh_keys]
          action :modify
        end
  
      end
  
      Chef::Log.info("Attempting to run Replication Setup for Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
      mysqlwrapper_slave_replication "/home/#{node['mysqlwrapper']['user']}/#{node['mysqlwrapper']['sql_loc']}" do
        database node['mysql']['tunable']['replicate_do_db']
        password node['mysql']['server_root_password']
        replication_host n['mysqlwrapper']['ip']
        replication_user node['mysqlwrapper']['slave_user']
        replication_password n['mysql']['server_repl_password']
      end
        
    end
    
  end
end