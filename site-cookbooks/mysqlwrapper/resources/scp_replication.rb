actions :create, :remove
default_action :create

attribute :host, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :required => true
attribute :identity, :kind_of => String, :required => true
attribute :sqlfile, :kind_of => String, :required => true


def initialize(*args)
  super
  @action = :create
end