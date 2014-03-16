use_inline_resources

def whyrun_supported?
  true
end

action :create do
  
  if !::File.exists?(node['mysqlwrapper']['replication_sql']) then
    
    ::Chef::Log.info("mysqldump -uroot -p#{@new_resource.password} --master-data=1 #{@new_resource.database} > #{@new_resource.sqlfile}")
    %x[mysqldump -uroot -p#{@new_resource.password} --master-data=1 #{@new_resource.database} > #{@new_resource.sqlfile}]
    
    if ::File.exists?(@new_resource.sqlfile) then
      new_resource.updated_by_last_action(true)
    else
      ::Chef::Log.error("MySQL Dump of Replication log Failed for Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    end
    
  end
    
end