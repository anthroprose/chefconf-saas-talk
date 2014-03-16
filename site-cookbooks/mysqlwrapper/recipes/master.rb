mysqlwrapper_create_database node['mysql']['tunable']['replicate_do_db'] do
  password node['mysql']['server_root_password']
  action :create
end

mysqlwrapper_dump_replication_log node['mysqlwrapper']['replication_sql'] do
  password node['mysql']['server_root_password']
  database node['mysql']['tunable']['replicate_do_db']
  action :create
end

nodes = search(:node, "mysqlwrapper_cluster:#{node['mysqlwrapper']['cluster']} AND mysqlwrapper_type:slave mysqlwrapper_ssh_keys:*")

begin
  Chef::Log.info("MySQLWrapper Master is Searching for Slave of Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
  nodes.each do |n|
    
    Chef::Log.info("Searching through Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    
    if n.has_key?'mysqlwrapper' and n['mysqlwrapper'].has_key?'ssh_keys' and n['mysqlwrapper'].has_key?'pulled_pubkey' then
      
      Chef::Log.info("Found Slave with Credentials at Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']} - Pubkey: #{n['mysqlwrapper']['ssh_keys']}")
      
      mysqlwrapper_scp_replication n['mysqlwrapper']['ip'] do
        user node['mysqlwrapper']['user']
        identity node['mysqlwrapper']['privkey_loc']
        sqlfile node['mysqlwrapper']['replication_sql']
      end
      
    else
      Chef::Log.info("Cound not find Slave with Credentials at Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    end
    
  end
end