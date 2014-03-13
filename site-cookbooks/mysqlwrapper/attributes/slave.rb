default['mysql']['bind_address']               = node.attribute?('cloud') && node['cloud']['local_ipv4'] ? node['cloud']['local_ipv4'] : node['ipaddress']
default['mysql']['port']                       = 3306
default['mysql']['nice']                       = 0