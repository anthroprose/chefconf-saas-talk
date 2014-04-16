require 'chef/log'

module Opscode
  class MysqlwrapperHandler < Chef::Handler

    def data
      @run_status.to_hash
    end

    def report
      @run_status = run_status
      Chef::Log.info("MySQLWrapper Report Handler - Updated Resources: " + @run_status.updated_resources.count.to_s)
    end
  end
end