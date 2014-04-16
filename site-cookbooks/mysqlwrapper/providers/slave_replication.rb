use_inline_resources

def whyrun_supported?
  true
end

action :create do
  
  ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} -e \"SHOW DATABASES\"|grep #{@new_resource.database}")
  
  if ::File.exists?("#{@new_resource.sqlfile}") and %x[mysql -uroot -p#{@new_resource.password} -e "SHOW DATABASES"|grep #{@new_resource.database}] == '' then
    
    ::Chef::Log.info("Setting up Replication Slave on Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")

    ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} < #{@new_resource.sqlfile}")
    %x[mysql -uroot -p#{@new_resource.password} < #{@new_resource.sqlfile}]

    ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} -e \"CHANGE MASTER TO MASTER_HOST='#{@new_resource.replication_host}',MASTER_USER='#{@new_resource.replication_user}',MASTER_PASSWORD='#{@new_resource.replication_password}';\"")
    %x[mysql -uroot -p#{@new_resource.password} -e "CHANGE MASTER TO MASTER_HOST='#{@new_resource.replication_host}',MASTER_USER='#{@new_resource.replication_user}',MASTER_PASSWORD='#{@new_resource.replication_password}';"]

    ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} -e \"START SLAVE;\"")
    %x[mysql -uroot -p#{@new_resource.password} -e "START SLAVE;"]
    
    node.set['mysqlwrapper']['replication_complete'] = 1
    
    new_resource.updated_by_last_action(true)
    
  end
    
end

action :remove do
  
end

action :status do
  
  if %x[mysql -uroot -p#{@new_resource.password} -e "SHOW DATABASES"|grep #{@new_resource.database}] != '' then
    
    status = true    
    seconds_behind = node['mysqlwrapper']['seconds_behind_master']

    ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} -e \"SHOW SLAVE STATUS\\G;\"|grep :")
    sql_out = %x[mysql -uroot -p#{@new_resource.password} -e "SHOW SLAVE STATUS\\G;"|grep :].split("\n")
    
    sql_out.each do |l|
      
      val = l.split(':')
      val[0].strip
      val[1].strip
      
      if (val[0] == 'Slave_IO_Running' or val[0] == 'Slave_IO_Running') and val[1] != 'Yes' then
        
        status = false
        
      end
      
      if val[0] == 'Seconds_Behind_Master' and val[1].to_i >= seconds_behind.to_i then
        
        status = false
        ::Chef::Log.error("Replication Slave Seconds Behind Master is #{val[1]} on Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
        
      end
      
    end
    
    if status == false then
      
      ::Chef::Log.error("Replication Slave Failure on Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
      
    else
      
      ::Chef::Log.info("Replication Slave OK on Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")
      
    end
    
  end
  
end