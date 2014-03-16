use_inline_resources

def whyrun_supported?
  true
end

action :create do
  
  if ::File.exists?("#{@new_resource.sqlfile}") and %x[mysql -uroot -p#{@new_resource.password} -e "SHOW DATABASES"|grep #{@new_resource.database}] == '' then
    
    ::Chef::Log.info("Setting up Replication Slave on Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
    %x[mysql -uroot -p#{@new_resource.password} < #{@new_resource.sqlfile}]
    ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} -e \"CHANGE MASTER TO MASTER_HOST='#{@new_resource.replication_host}',MASTER_USER='#{@new_resource.replication_user}',MASTER_PASSWORD='#{@new_resource.replication_password}';\"")
    %x[mysql -uroot -p#{@new_resource.password} -e "CHANGE MASTER TO MASTER_HOST='#{@new_resource.replication_host}',MASTER_USER='#{@new_resource.replication_user}',MASTER_PASSWORD='#{@new_resource.replication_password}';"]
    %x[mysql -uroot -p#{@new_resource.password} -e "START SLAVE;"]
    new_resource.updated_by_last_action(true)
    
  end
    
end

action :remove do
  
  
  
end