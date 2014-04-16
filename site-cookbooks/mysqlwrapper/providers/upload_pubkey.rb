use_inline_resources

def whyrun_supported?
  true
end

action :upload do
  
  if ::File.exists?(new_resource.pubkey) then
    
    pubkey = IO.read(new_resource.pubkey)
      
    if pubkey != node[:mysqlwrapper][:ssh_pubkey] then

      node.set['mysqlwrapper']['ssh_pubkey'] = pubkey
      ::Chef::Log.info("Saving MySQLWrapper PubKey for Node: #{node.name} - Cluster: #{node['mysqlwrapper']['cluster']}")        
      new_resource.updated_by_last_action(true)
    
    end

  end
    
end