module ServiceOrchestration
  module MysqlWrapper
    module Helpers

      def publish_ssh_key
        pubkey_loc = '/home/mysqlwrapper/.ssh/id_dsa.pub'
        if File.exists?(pubkey_loc) then
          node[:mysqlwrapper][:ssh_pubkey] = IO.read(pubkey_loc)
        end
      end
      
      def find_ssh_key

      end
      
      def mysql_dump

      end
      
      def mysql_load

      end
      
      def mysql_slave

      end
    end
  end
end
