actions :create
default_action :create

attribute :database, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String, :required => true

def initialize(*args)
  super
  @action = :create
end