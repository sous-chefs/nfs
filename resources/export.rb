def initialize(*args)
  super
  @action = :create
end

actions :create

attribute :directory, :name_attribute => true
attribute :network, :required
attribute :writeable, :default => false, :kind_of => [TrueClass, FalseClass]
attribute :sync, :default => true, :kind_of => [TrueClass, FalseClass]
attribute :extra_options, :default => ['root_squash'], :kind_of => Array

attribute :exists, :kind_of => [TrueClass, FalseClass]
