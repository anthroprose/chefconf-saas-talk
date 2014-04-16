use_inline_resources

def whyrun_supported?
  true
end

action :create do
  
  if %x[mysql -uroot -p#{@new_resource.password} -e "SHOW DATABASES"|grep #{@new_resource.database}] == '' then
    
    ::Chef::Log.info("mysql -uroot -p#{@new_resource.password} -e \"CREATE DATABASE #{@new_resource.database}\"")
    %x[mysql -uroot -p#{@new_resource.password} -e "CREATE DATABASE #{@new_resource.database}"]

    ::Chef::Log.info("Creating Database #{@new_resource.database} for Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")        
    new_resource.updated_by_last_action(true)
    
  end
    
end