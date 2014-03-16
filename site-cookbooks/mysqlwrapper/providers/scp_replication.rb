use_inline_resources

def whyrun_supported?
  true
end

action :create do
  
  found = false
  slaves = Array(node[:mysqlwrapper][:slaves])
  
  slaves.each do |s|
    
    if s == @new_resource.host then
      found = true
    end
    
  end
  
  if ::File.exists?(@new_resource.sqlfile) and found then
    
    ::Chef::Log.info("scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i #{@new_resource.identity} #{@new_resource.sqlfile} #{@new_resource.user}@#{@new_resource.host}:~/")
    %x[scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i #{@new_resource.identity} #{@new_resource.sqlfile} #{@new_resource.user}@#{@new_resource.host}:~/]
    
    slaves.push(@new_resource.host)
    node.set['mysqlwrapper']['slaves'] = slaves
    new_resource.updated_by_last_action(true)
    
  end
    
end

action :remove do
  
  found = false
  slaves = Array(node[:mysqlwrapper][:slaves])
  new_slaves = Array()
  
  slaves.each do |s|
    
    if s != @new_resource.host then
      new_slaves.push(s)
    else
      found = true
    end
    
  end
  
  if found then
    node.set['mysqlwrapper']['slaves'] = slaves
    new_resource.updated_by_last_action(true)
  end
  
end