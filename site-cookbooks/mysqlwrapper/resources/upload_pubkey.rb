actions :upload
default_action :upload

attribute :pubkey, :kind_of => String, :name_attribute => true

#attr_accessor :exists

def initialize(*args)
  super
  @action = :upload
end