name              'mysqlwrapper'
maintainer        'Alex Corley'
maintainer_email  'corley@avast.com'
license           'GPLv2'
description       'Installs and configures mysql server replication'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.0.1'
recipe            'mysqlwrapper', 'Wrapper Cookbook to control Versioning, also contains helper lwrps.'
recipe            'mysqlwrapper::master', 'Installs & Dumps MySQL Server'
recipe            'mysqlwrapper::slave', 'Installs & Loads the Slave'

# actually tested on
supports 'redhat'
supports 'amazon'
supports 'centos'
supports 'debian'
supports 'ubuntu'

depends 'mysql', '~> 4.1'
depends 'user', '~> 0.3'
