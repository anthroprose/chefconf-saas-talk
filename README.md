chefconf-saas-talk
==================

MySQL Replication using Community Cookbooks some Gluecode with LWRPs

```bash
bundle install
rake magic
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
* 
## Fourth
* MySQL Master - Insert SQL
* MySQL Slave - Read SQL
