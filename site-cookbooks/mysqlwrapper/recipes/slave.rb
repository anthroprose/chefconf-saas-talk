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
      
      node.set["mysqlwrapper"]["ssh_keys"] = n['mysqlwrapper']['ssh_pubkey']
      Chef::Log.info("Found Public Key for Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
      
      if File.exists?("/home/#{node['mysqlwrapper']['user']}/#{node['mysqlwrapper']['sql_loc']}") and %x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "SHOW DATABASES"|grep #{node['mysql']['tunable']['replicate_do_db']}] == '' then
        Chef::Log.info("Setting up Replication Slave on Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
        %x[mysql -uroot -p#{node['mysql']['server_root_password']} < /home/#{node['mysqlwrapper']['user']}/#{node['mysqlwrapper']['sql_loc']}]
        Chef::Log.info("mysql -uroot -p#{node['mysql']['server_root_password']} -e \"CHANGE MASTER TO MASTER_HOST='#{n['mysqlwrapper']['ip']}',MASTER_USER='#{node['mysqlwrapper']['slave_user']}',MASTER_PASSWORD='#{n['mysql']['server_repl_password']}';\"")
        %x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "CHANGE MASTER TO MASTER_HOST='#{n['mysqlwrapper']['ip']}',MASTER_USER='#{node['mysqlwrapper']['slave_user']}',MASTER_PASSWORD='#{n['mysql']['server_repl_password']}';"]
        %x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "START SLAVE;"]
      end
    
    else
      Chef::Log.info("Cound not find Public Key for Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    end
    
  end
end