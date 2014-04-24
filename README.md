chefconf-saas-talk
==================

## Chef Conf 2014 - Roll your own AWS RDS SQS or other SaaS

MySQL Replication via Chef with Service Orchestration using Node Attributes, LWRPs, and Multiple Convergences.


```bash
bundle install
rake magic
```

```ruby
desc "Magic Multiple Convergence and Testing"
task :magic do
  Rake::Task["init"].execute
  Rake::Task["up"].execute
  Rake::Task["converge"].execute
  Rake::Task["converge"].execute
  Rake::Task["customer"].execute
  Rake::Task["slave"].execute
end
```

# Convergences

## First
* MySQL Master - Create MySQLWrapper User
* MySQL Master - Install MySQL Server
* MySQL Master - Export MYSQLWrapper Pubkey to Chef Server

## Second
* MySQL Slave - Create MySQLWrapper User
* MySQL Slave - Install MySQL Server
* MySQL Slave - Import MySQLWrapper Pubkey
* MySQL Slave - Export Logic Flag for Pubkey Acceptance

## Third
* MySQL Master - Check for Slave's Pubkey Acceptance
* MySQL Master - MySQLDump Database/Replication SQL
* MySQL Master - SCP Replication SQL to MySQL Slave
* MySQL Slave - Import Replication SQL and Start Slave

## Final
* MySQL Master - Insert SQL
* MySQL Slave - Read SQL
