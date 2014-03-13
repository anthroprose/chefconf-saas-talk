module ServiceOrchestration
  module MysqlWrapper
    module Helpers
      def debian_before_squeeze?
        (node['platform'] == 'debian') && (node['platform_version'].to_f < 6.0)
      end

      def ubuntu_before_lucid?
        (node['platform'] == 'ubuntu') && (node['platform_version'].to_f < 10.0)
      end

      def assign_root_password_cmd
        str = '/usr/bin/mysqladmin'
        str << ' -u root password '
        str << node['mysql']['server_root_password']
      end

      def install_grants_cmd
        str = '/usr/bin/mysql'
        str << ' -u root '
        node['mysql']['server_root_password'].empty? ? str << ' < /etc/mysql_grants.sql' : str << " -p#{node['mysql']['server_root_password']} < /etc/mysql_grants.sql"
      end
    end
  end
end
