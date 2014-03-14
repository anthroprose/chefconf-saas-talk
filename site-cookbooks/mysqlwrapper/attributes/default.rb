default['mysqlwrapper']['user'] = 'mysqlwrapper'
default['mysqlwrapper']['pubkey_loc'] = '/home/mysqlwrapper/.ssh/id_dsa.pub'
default['mysqlwrapper']['privkey_loc'] = '/home/mysqlwrapper/.ssh/id_dsa'
default['mysqlwrapper']['cluster'] = 'Development'
default['mysqlwrapper']['slave_user'] = 'repl'
default['mysqlwrapper']['sql_loc'] = 'replication.sql'
default['mysqlwrapper']['replication_sql'] = '/var/lib/mysql/replication.sql'
default['mysqlwrapper']['replication_sent'] = 0

override['mysql']['tunable']['server_id'] = 1
override['mysql']['tunable']['log_bin'] = 'mysql-bin'
override['mysql']['tunable']['log_slave_updates'] = false
override['mysql']['tunable']['binlog_format'] = 'statement'
override['mysql']['tunable']['replicate_do_db'] = 'mysqlwrapper'
override['mysql']['tunable']['binlog_do_db'] = 'mysqlwrapper'