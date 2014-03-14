node.set['mysqlwrapper']['type'] = 'master'

service "mysql" do
  action [ :restart ]
end

ruby_block "create_database" do
  not_if {%x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "SHOW DATABASES"|grep #{node['mysql']['tunable']['replicate_do_db']}] != ''}
  block do
    %x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "CREATE DATABASE #{node['mysql']['tunable']['replicate_do_db']}"]
  end
  action :run
end

ruby_block "dump_mysql_log" do
  not_if { File.exists?(node['mysqlwrapper']['replication_sql']) }
  block do
    %x[mysqldump -uroot -p#{node['mysql']['server_root_password']} --master-data=1 #{node['mysql']['tunable']['replicate_do_db']} > #{node['mysqlwrapper']['replication_sql']}]
  end
  action :run
end

nodes = search(:node, "mysqlwrapper_cluster:#{node['mysqlwrapper']['cluster']} AND mysqlwrapper_type:slave mysqlwrapper_ssh_keys:*")

begin
  Chef::Log.info("MySQLWrapper Master is Searching for Slave of Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
  nodes.each do |n|
    
    Chef::Log.info("Searching through Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    
    if n.has_key?'mysqlwrapper' and n['mysqlwrapper'].has_key?'ssh_keys' then
      Chef::Log.info("Found Slave with Credentials at Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
      
      if File.exists?(node['mysqlwrapper']['replication_sql']) then
        Chef::Log.info("scp -o 'StrictHostKeyChecking no' -i #{node['mysqlwrapper']['privkey_loc']} #{node['mysqlwrapper']['replication_sql']} #{node['mysqlwrapper']['user']}@#{n['mysqlwrapper']['ip']}:~/")
        %x[scp -o 'StrictHostKeyChecking no' -i #{node['mysqlwrapper']['privkey_loc']} #{node['mysqlwrapper']['replication_sql']} #{node['mysqlwrapper']['user']}@#{n['ipaddress']}:~/]
        node.set['mysqlwrapper']['replication_sent'] = 1
      else
        Chef::Log.error("Found a Slave but Master has no SQL File at Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
      end
      
    else
      Chef::Log.info("Cound not find Slave with Credentials at Node: #{n.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    end
    
  end
end