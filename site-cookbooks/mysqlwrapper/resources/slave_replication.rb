actions :create, :remove, :status
default_action :create

attribute :sqlfile, :kind_of => String, :name_attribute => true
attribute :database, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :replication_user, :kind_of => String, :required => true
attribute :replication_password, :kind_of => String, :required => true
attribute :replication_host, :kind_of => String, :required => true

def initialize(*args)
  super
  @action = :create
end